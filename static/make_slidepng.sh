#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

IN_DIR="$SCRIPT_DIR/slides"          # where your PDFs are
OUT_DIR="$SCRIPT_DIR/slides"         # where you want PNGs
#mkdir -p "$OUT_DIR"

for pdf in "$IN_DIR"/*.pdf; do
  [ -e "$pdf" ] || continue
  base="$(basename "$pdf" .pdf)"
  out="$OUT_DIR/${base}.png"

  # -Z sets max dimension in pixels (adjust 800/1200/etc)
  sips -s format png -Z 800 "$pdf" --out "$out" >/dev/null
  echo "Made: $out"
done
