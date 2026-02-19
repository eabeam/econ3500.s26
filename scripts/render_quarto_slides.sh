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

get_yaml_field() {
  local field="$1"
  local file="$2"
  awk -v field="$field" '
    /^---[[:space:]]*$/ {in_yaml = !in_yaml; next}
    in_yaml && $0 ~ "^" field ":" {
      sub("^[^:]+:[[:space:]]*", "", $0)
      gsub(/^["'\'']|["'\'']$/, "", $0)
      print $0
      exit
    }
  ' "$file"
}

resolve_path() {
  local base_dir="$1"
  local rel="$2"
  if [ -z "$rel" ]; then
    echo ""
    return
  fi
  python3 - <<PY "$base_dir" "$rel"
import os, sys
base, rel = sys.argv[1], sys.argv[2]
print(os.path.abspath(os.path.join(base, rel)))
PY
}

OUTPUT_DIR_RAW="$(get_yaml_field "output-dir" "$QMD")"
OUTPUT_FILE="$(get_yaml_field "output-file" "$QMD")"
OUTPUT_DIR="$SRC_DIR"
if [ -n "$OUTPUT_DIR_RAW" ]; then
  OUTPUT_DIR="$(resolve_path "$SRC_DIR" "$OUTPUT_DIR_RAW")"
fi
if [ -z "$OUTPUT_FILE" ]; then
  OUTPUT_FILE="${BASE}.html"
fi

STATA_RUN_ALL="$SRC_DIR/stata/run_all.do"
if [ -f "$STATA_RUN_ALL" ] && [ "${SKIP_STATA:-0}" != "1" ]; then
  echo "Running Stata logs: $STATA_RUN_ALL"
  /Applications/StataNow/StataSE.app/Contents/MacOS/StataSE -b do "$STATA_RUN_ALL" "$REPO_ROOT" "$SRC_DIR"
fi

echo "Rendering: $QMD"
pushd "$SRC_DIR" >/dev/null
quarto render "$(basename "$QMD")"
popd >/dev/null

HTML_FILE="$OUTPUT_DIR/$OUTPUT_FILE"
SRC_HTML_BASE="$SRC_DIR/$BASE.html"
SRC_HTML_INDEX="$SRC_DIR/index.html"

prefer_src_html() {
  local src="$1"
  local dest="$2"
  [ -f "$src" ] || return 1
  [ -f "$dest" ] || return 0

  if [ "$src" -nt "$dest" ]; then
    return 0
  fi

  if rg -q "textcolor" "$dest" && rg -q "\\\\color\\{#008080\\}" "$src"; then
    return 0
  fi

  return 1
}

if [ ! -f "$HTML_FILE" ]; then
  if [ -f "$SRC_HTML_BASE" ]; then
    HTML_FILE="$SRC_HTML_BASE"
  elif [ -f "$SRC_HTML_INDEX" ]; then
    HTML_FILE="$SRC_HTML_INDEX"
  else
    echo "Expected HTML not found: $HTML_FILE"
    exit 1
  fi
else
  if prefer_src_html "$SRC_HTML_BASE" "$HTML_FILE"; then
    HTML_FILE="$SRC_HTML_BASE"
  elif prefer_src_html "$SRC_HTML_INDEX" "$HTML_FILE"; then
    HTML_FILE="$SRC_HTML_INDEX"
  fi
fi

echo "Syncing HTML + assets to: $DEST_ROOT"
if [ "$HTML_FILE" != "$DEST_ROOT/index.html" ]; then
  cp "$HTML_FILE" "$DEST_ROOT/index.html"
fi
# Fix stylesheet path if Quarto wrote ../_styles/styles.css (so fragments and custom styles work)
if grep -q '_styles/styles.css' "$DEST_ROOT/index.html" 2>/dev/null; then
  perl -i -pe 's|../_styles/styles\.css|styles.css|g' "$DEST_ROOT/index.html"
  echo "Fixed styles.css link in index.html"
fi

FILES_DIR=""
if [ -d "$OUTPUT_DIR/${BASE}_files" ]; then
  FILES_DIR="$OUTPUT_DIR/${BASE}_files"
elif [ -d "$SRC_DIR/${BASE}_files" ]; then
  FILES_DIR="$SRC_DIR/${BASE}_files"
fi

if [ -n "$FILES_DIR" ]; then
  DEST_FILES="$DEST_ROOT/$(basename "$FILES_DIR")"
  if [ "$FILES_DIR" != "$DEST_FILES" ]; then
    rsync -a --delete "$FILES_DIR/" "$DEST_FILES/"
  fi
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
  elif [ -f "$REPO_ROOT/slides/_styles/$f" ]; then
    cp "$REPO_ROOT/slides/_styles/$f" "$DEST_ROOT/$f"
  fi
done

# Post-process HTML in destination for lazyload + r-stretch issues
find "$DEST_ROOT" -maxdepth 2 -name "*.html" -print0 | while IFS= read -r -d '' f; do
  perl -0pi -e 's/\bdata-src="/src="/g; s/\br-stretch\b//g; s/  +/ /g' "$f"
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
