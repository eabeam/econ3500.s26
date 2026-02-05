#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Usage: $0 <slides.qmd> <slug> [pdf_name]"
  echo "Example: $0 /Users/ebeam/Dropbox/ECON3500/ch4_linear_regression.qmd ch4-quarto ch4-slides.pdf"
  exit 1
fi

QMD="$1"
SLUG="$2"
PDF_NAME="${3:-}"

if [ ! -f "$QMD" ]; then
  echo "QMD not found: $QMD"
  exit 1
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST_ROOT="$REPO_ROOT/static/slides/$SLUG"

SRC_DIR="$(cd "$(dirname "$QMD")" && pwd)"
BASE="$(basename "$QMD" .qmd)"

mkdir -p "$DEST_ROOT"

STATA_RUN_ALL="$SRC_DIR/stata/run_all.do"
if [ -f "$STATA_RUN_ALL" ] && [ "${SKIP_STATA:-0}" != "1" ]; then
  echo "Running Stata logs: $STATA_RUN_ALL"
  /Applications/StataNow/StataSE.app/Contents/MacOS/StataSE -b do "$STATA_RUN_ALL" "$REPO_ROOT" "$SRC_DIR"
fi

echo "Rendering: $QMD"
pushd "$SRC_DIR" >/dev/null
quarto render "$(basename "$QMD")"
popd >/dev/null

if [ ! -f "$SRC_DIR/$BASE.html" ]; then
  echo "Expected HTML not found: $SRC_DIR/$BASE.html"
  exit 1
fi

echo "Syncing HTML + assets to: $DEST_ROOT"
cp "$SRC_DIR/$BASE.html" "$DEST_ROOT/index.html"

if [ -d "$SRC_DIR/${BASE}_files" ]; then
  rsync -a --delete "$SRC_DIR/${BASE}_files/" "$DEST_ROOT/${BASE}_files/"
fi

if [ -d "$SRC_DIR/figures_temp" ]; then
  rsync -a --delete "$SRC_DIR/figures_temp/" "$DEST_ROOT/figures_temp/"
fi

for figdir in "$SRC_DIR"/ch*_figures; do
  if [ -d "$figdir" ]; then
    rsync -a --delete "$figdir/" "$DEST_ROOT/$(basename "$figdir")/"
  fi
done

for f in styles.css custom-econometria.scss lazyload-fix.html; do
  if [ -f "$SRC_DIR/$f" ]; then
    cp "$SRC_DIR/$f" "$DEST_ROOT/$f"
  fi
done

if [ -z "$PDF_NAME" ]; then
  if [[ "$SLUG" =~ ^ch([0-9]+)-quarto$ ]]; then
    CH_NUM="${BASH_REMATCH[1]}"
    PDF_NAME="ch${CH_NUM}-slides.pdf"
  fi
fi

if [ -n "$PDF_NAME" ]; then
  PDF_OUT="$REPO_ROOT/static/slides/$PDF_NAME"
  REVEAL_PDF_SCRIPT="$SRC_DIR/render_reveal_pdf.sh"
  if [ ! -x "$REVEAL_PDF_SCRIPT" ]; then
    REVEAL_PDF_SCRIPT="$REPO_ROOT/slides/render_reveal_pdf.sh"
  fi

  if [ -x "$REVEAL_PDF_SCRIPT" ]; then
    echo "Rendering slide PDF to: $PDF_OUT"
    "$REVEAL_PDF_SCRIPT" "$QMD" "$PDF_OUT"
    if [ "${UPDATE_THUMBS:-0}" = "1" ]; then
      echo "Refreshing slide thumbnails"
      "$REPO_ROOT/static/make_slidepng.sh"
    else
      echo "Skipping slide thumbnails (set UPDATE_THUMBS=1 to enable)"
    fi
  else
    echo "PDF script not found/executable: $REVEAL_PDF_SCRIPT"
    echo "Skipped PDF and thumbnail generation."
  fi
fi

echo "Syncing static → public"
rsync -a --delete "$REPO_ROOT/static/slides/" "$REPO_ROOT/public/slides/"

echo "Done."
