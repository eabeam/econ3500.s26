#!/usr/bin/env bash
set -euo pipefail

# EDIT THIS to your local export folder (where your PDFs land)
SRC="/Users/ebeam/Library/CloudStorage/OneDrive-UniversityofVermont(2)/UVM-Teaching/UVM-EC200/ECON3500-Spring_2026/00_ECON3500_Shared/01_Lecture_PDF"

# Course site publish folder (already in your repo)
DEST="static/slides"

if [ ! -d "$SRC" ]; then
  echo "Source folder not found: $SRC"
  echo "Edit SRC in scripts/publish_slides.sh"
  exit 1
fi

mkdir -p "$DEST"

# Copy only PDFs (non-destructive)
rsync -av --include="*/" --include="*.pdf" --exclude="*" "$SRC/" "$DEST/"

git add "$DEST"

echo ""
echo "✅ Slides copied into $DEST and staged."
echo "Next: git commit -m \"Update slides\" && git push"
