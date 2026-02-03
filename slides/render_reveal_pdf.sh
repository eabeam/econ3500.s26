#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <slides.qmd> [output.pdf]"
  exit 1
fi

QMD="$1"
OUT="${2:-}"  # optional

if [ ! -f "$QMD" ]; then
  echo "QMD not found: $QMD"
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "$QMD")" && pwd)"
BASE_NAME="$(basename "$QMD" .qmd)"
HTML_FILE="$ROOT_DIR/${BASE_NAME}.html"

if [ -z "$OUT" ]; then
  OUT="$ROOT_DIR/${BASE_NAME}.pdf"
fi

CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
if [ ! -x "$CHROME" ]; then
  echo "Chrome not found at: $CHROME"
  echo "Set CHROME to a valid Chrome/Chromium binary."
  exit 1
fi

if [ ! -f "$HTML_FILE" ]; then
  echo "Expected HTML not found: $HTML_FILE"
  echo "Run: quarto render \"$QMD\""
  exit 1
fi

PORT="${PORT:-8000}"
python3 -m http.server "$PORT" --directory "$ROOT_DIR" >/tmp/reveal_pdf_server.log 2>&1 &
SERVER_PID=$!
trap 'kill "$SERVER_PID" >/dev/null 2>&1 || true' EXIT

sleep 1

URL="http://localhost:$PORT/${BASE_NAME}.html?print-pdf"

echo "Printing to PDF: $OUT"
"$CHROME" \
  --headless \
  --disable-gpu \
  --print-to-pdf-no-header \
  --print-to-pdf="$OUT" \
  --virtual-time-budget=20000 \
  --run-all-compositor-stages-before-draw \
  "$URL"

echo "Done: $OUT"
