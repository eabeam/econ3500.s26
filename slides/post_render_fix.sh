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

sync_chapter() {
  local chapter_dir="$1"
  local dest_slug="$2"
  local src_dir="$ROOT_DIR/$chapter_dir"
  local dest_dir="$REPO_ROOT/static/slides/$dest_slug"
  [ -d "$src_dir" ] || return 0

  local html=""
  if [ -f "$src_dir/index.html" ]; then
    html="$src_dir/index.html"
  elif compgen -G "$src_dir/*.html" >/dev/null; then
    html="$(ls -t "$src_dir"/*.html | head -n1)"
  fi

  [ -n "$html" ] || return 0
  mkdir -p "$dest_dir"
  cp "$html" "$dest_dir/index.html"

  for dir in "$src_dir"/*_files; do
    [ -d "$dir" ] || continue
    rsync -a --delete "$dir/" "$dest_dir/$(basename "$dir")/"
  done

  for figdir in "$src_dir"/ch*_figures; do
    [ -d "$figdir" ] || continue
    rsync -a --delete "$figdir/" "$dest_dir/$(basename "$figdir")/"
  done
}

# Fix HTML in slides project and in static output
fix_html "$ROOT_DIR"
fix_html "$REPO_ROOT/static/slides"

# Keep static copies in sync for chapters that use local render output
sync_chapter ch4 ch4-quarto
sync_chapter ch6 ch6-quarto
sync_chapter ch8 ch8-quarto

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

# Same for ch6 (HTML may live in slides/ch6/ or static/slides/ch6-quarto/)
CH6_HTML="$REPO_ROOT/static/slides/ch6-quarto/index.html"
CH6_HTML_ALT="$ROOT_DIR/ch6/index.html"
CH6_PDF="$REPO_ROOT/static/slides/ch6-slides.pdf"
CH6_QMD="$REPO_ROOT/slides/ch6/ch6_multiple_regression.qmd"

if [ -f "$CH6_QMD" ]; then
  if [ -f "$CH6_HTML" ] || [ -f "$CH6_HTML_ALT" ]; then
    REF="$CH6_HTML"
    [ -f "$REF" ] || REF="$CH6_HTML_ALT"
    if [ ! -f "$CH6_PDF" ] || [ "$REF" -nt "$CH6_PDF" ]; then
      if ! "$REPO_ROOT/slides/render_reveal_pdf.sh" "$CH6_QMD" "$CH6_PDF"; then
        echo "Warning: PDF render failed for $CH6_QMD"
      else
        if [ -x "$REPO_ROOT/static/make_slidepng.sh" ]; then
          "$REPO_ROOT/static/make_slidepng.sh"
        fi
      fi
    fi
  fi
fi

# Ch8 (HTML may be in slides/ch8/ or static/slides/ch8-quarto/)
CH8_HTML="$REPO_ROOT/static/slides/ch8-quarto/index.html"
CH8_HTML_ALT="$ROOT_DIR/ch8/index.html"
CH8_PDF="$REPO_ROOT/static/slides/ch8-slides.pdf"
CH8_QMD="$REPO_ROOT/slides/ch8/ch8_nonlinear_relationships.qmd"

if [ -f "$CH8_QMD" ]; then
  if [ -f "$CH8_HTML" ] || [ -f "$CH8_HTML_ALT" ]; then
    REF="$CH8_HTML"
    [ -f "$REF" ] || REF="$CH8_HTML_ALT"
    if [ ! -f "$CH8_PDF" ] || [ "$REF" -nt "$CH8_PDF" ]; then
      if ! "$REPO_ROOT/slides/render_reveal_pdf.sh" "$CH8_QMD" "$CH8_PDF"; then
        echo "Warning: PDF render failed for $CH8_QMD"
      else
        if [ -x "$REPO_ROOT/static/make_slidepng.sh" ]; then
          "$REPO_ROOT/static/make_slidepng.sh"
        fi
      fi
    fi
  fi
fi
