#!/usr/bin/env bash
set -euo pipefail

# Ensure revealjs images load without relying on lazy loader
# Also remove r-stretch class to avoid reveal layout collapsing images.
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$ROOT_DIR/.." && pwd)"

fix_html() {
  local target_dir="$1"
  [ -d "$target_dir" ] || return 0
  find "$target_dir" -maxdepth 2 -name "*.html" -print0 | while IFS= read -r -d '' f; do
    perl -0pi -e 's/\bdata-src="/src="/g; s/\br-stretch\b//g; s/  +/ /g' "$f"
  done
}

# Fix HTML in slides project and in static output
fix_html "$ROOT_DIR"
fix_html "$REPO_ROOT/static/slides"

# If the ch4 Quarto output is newer than the PDF, refresh PDF + thumbnails
CH4_HTML="$REPO_ROOT/static/slides/ch4-quarto/index.html"
CH4_PDF="$REPO_ROOT/static/slides/ch4-slides.pdf"
CH4_QMD="$REPO_ROOT/slides/ch4/ch4_linear_regression.qmd"

if [ -f "$CH4_HTML" ] && [ -f "$CH4_QMD" ]; then
  if [ ! -f "$CH4_PDF" ] || [ "$CH4_HTML" -nt "$CH4_PDF" ]; then
    if ! "$REPO_ROOT/slides/render_reveal_pdf.sh" "$CH4_QMD" "$CH4_PDF"; then
      echo "Warning: PDF render failed for $CH4_QMD"
    else
      if [ -x "$REPO_ROOT/static/make_slidepng.sh" ]; then
        "$REPO_ROOT/static/make_slidepng.sh"
      fi
    fi
  fi
fi
