#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Usage: $0 <slides.qmd> <slug>"
  echo "Example: $0 /Users/ebeam/Dropbox/ECON3500/ch4_linear_regression.qmd ch4-quarto"
  exit 1
fi

QMD="$1"
SLUG="$2"

if [ ! -f "$QMD" ]; then
  echo "QMD not found: $QMD"
  exit 1
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST_ROOT="$REPO_ROOT/static/slides/$SLUG"

SRC_DIR="$(cd "$(dirname "$QMD")" && pwd)"
BASE="$(basename "$QMD" .qmd)"

mkdir -p "$DEST_ROOT"

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

for f in styles.css custom-econometria.scss lazyload-fix.html; do
  if [ -f "$SRC_DIR/$f" ]; then
    cp "$SRC_DIR/$f" "$DEST_ROOT/$f"
  fi
done

echo "Syncing static → public"
rsync -a --delete "$REPO_ROOT/static/slides/" "$REPO_ROOT/public/slides/"

echo "Done."
