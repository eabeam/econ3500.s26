#!/usr/bin/env bash
set -euo pipefail

OUT="external-links.txt"

# Extract external links from built HTML
rg -oN 'https?://[^"'\'' )>]+' \
  public/**/*.html \
| sed 's/[),.]*$//' \
| sort -u > "$OUT"

echo "Extracted $(wc -l < "$OUT") unique external links to $OUT"

# Check them
lychee "$OUT" \
  --verbose \
  --no-progress \
  --accept 200,206,301,302,303,307,308 \
  --timeout 20 \
  --format markdown \
  --output linkcheck-external.md

