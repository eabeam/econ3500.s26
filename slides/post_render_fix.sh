#!/usr/bin/env bash
set -euo pipefail

# Ensure revealjs images load without relying on lazy loader
# Also remove r-stretch class to avoid reveal layout collapsing images.
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

find "$ROOT_DIR" -maxdepth 2 -name "*.html" -print0 | while IFS= read -r -d '' f; do
  perl -0pi -e 's/\bdata-src="/src="/g; s/\br-stretch\b//g; s/  +/ /g' "$f"
done
