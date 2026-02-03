# Chapter 4 Slides Integration Guide

## What Was Done

Successfully integrated the Chapter 4 Linear Regression slides into your Hugo website with REAL ACS 2024 data!

### Files Added to Website

1. **PDF Version (for download)**
   - Location: `/static/slides/ch4-slides.pdf`
   - Source: Beamer PDF (199 pages) with real ACS data
   - Students can download this for offline study

2. **Interactive HTML Version (for presenting)**
   - Location: `/static/slides/ch4-quarto/index.html`
   - Source: Quarto RevealJS presentation with real ACS data
   - Features:
     - Interactive navigation
     - Chalkboard mode (`C` key)
     - Speaker notes (`S` key)
     - Search functionality (Ctrl+Shift+F)
     - Beautiful Econometria theme

3. **Thumbnail**
   - Location: `/static/slides/ch4-slides.png`
   - Shows first slide preview

### Updated Files

1. **`layouts/shortcodes/slides.html`**
   - Enhanced to show TWO buttons:
     - "View Slides Online (for presenting)" → Opens interactive HTML
     - "Download PDF" → Downloads PDF version
   - Falls back to PDF-only mode if no HTML version exists

2. **`content/content/04-content.md`**
   - Added: `slides_html: /slides/ch4-quarto/`
   - Keeps: `pdf: /slides/ch4-slides.pdf`
   - Keeps: `thumb: /slides/ch4-slides.png`

## How Students/You Will Use It

### On the Website (Week 4 Content Page)

Students will see:

```
📊 View Slides Online (for presenting)    📥 Download PDF
[Thumbnail image of first slide]
```

**Click "View Slides Online"**:
- Opens interactive RevealJS presentation in new tab
- Perfect for you to present in class
- Students can follow along online
- Full keyboard shortcuts available

**Click "Download PDF"**:
- Downloads the 199-page PDF
- Perfect for printing, annotating, offline study
- Same content, static format

## Testing Your Website

1. **Build the site**:
   ```bash
   cd /Users/ebeam/Dropbox/GitHub/econ3500.s26
   hugo server
   ```

2. **Navigate to**:
   ```
   http://localhost:1313/content/04-content/
   ```

3. **You should see**:
   - Two buttons at the top of the slides section
   - Thumbnail showing first slide
   - Both buttons functional

## File Structure

```
econ3500.s26/
├── static/slides/
│   ├── ch4-slides.pdf          # PDF version (3.0 MB)
│   ├── ch4-slides.png          # Thumbnail
│   └── ch4-quarto/             # Interactive HTML version
│       ├── index.html          # Main presentation file
│       ├── figures_temp/       # All 11 figures with real data
│       ├── custom-econometria.scss  # Econometria theme
│       ├── styles.css          # Custom styles
│       └── ch4_linear_regression_files/  # RevealJS dependencies
│
├── content/content/
│   └── 04-content.md           # Updated with slides_html parameter
│
└── layouts/shortcodes/
    └── slides.html             # Enhanced shortcode
```

## Deploying to Live Website

When you're ready to push to your live site:

```bash
cd /Users/ebeam/Dropbox/GitHub/econ3500.s26

# Add all the new files
git add static/slides/ch4-slides.pdf
git add static/slides/ch4-quarto/
git add layouts/shortcodes/slides.html
git add content/content/04-content.md

# Commit
git commit -m "Add Ch4 slides with real ACS 2024 data - both interactive HTML and PDF versions"

# Push
git push origin main
```

Your website will automatically rebuild with the new slides!

## Using for Future Chapters

For other chapters, you can now add both HTML and PDF versions:

1. **Add to content file** (e.g., `05-content.md`):
   ```yaml
   pdf: /slides/ch5-slides.pdf
   slides_html: /slides/ch5-quarto/
   thumb: /slides/ch5-slides.png
   ```

2. **Copy files to**:
   - PDF: `/static/slides/ch5-slides.pdf`
   - HTML: `/static/slides/ch5-quarto/index.html` (plus dependencies)
   - Thumb: `/static/slides/ch5-slides.png`

The shortcode will automatically show both buttons!

### Regenerating Slide Thumbnails

Thumbnails are generated from the first page of each PDF in `static/slides/`:

```bash
/Users/ebeam/Dropbox/GitHub/econ3500.s26/static/make_slidepng.sh
```

This updates files like `static/slides/ch4-slides.png` to match the current PDF.

## Keyboard Shortcuts for Presenting

When using the interactive HTML version:

| Shortcut | Function |
|----------|----------|
| `→` or `Space` | Next slide |
| `←` | Previous slide |
| `S` | Speaker view (notes, timer, next slide preview) |
| `O` or `ESC` | Overview mode (thumbnail grid) |
| `C` | Chalkboard mode (draw on slides) |
| `F` | Fullscreen |
| `?` | Show all shortcuts |
| `Ctrl+Shift+F` | Search slides |

## Real Data Details

All figures now use real ACS 2024 microdata:
- Sample: 300 observations, ages 25-64
- β₁ = 13.02 (each year education → $13,020 more wages)
- β₀ = -114.7
- R² = 0.155 (realistic - education doesn't explain everything!)

Much more realistic than the simulated data!

## Troubleshooting

**Slides don't show up?**
- Run `hugo server` and check http://localhost:1313
- Make sure files are in `/static/slides/`
- Check browser console (F12) for errors

**Figures missing in HTML version?**
- Verify `figures_temp/` directory exists in `/static/slides/ch4-quarto/`
- Check that all 11 PNG files are present

**PDF download doesn't work?**
- Ensure `ch4-slides.pdf` is in `/static/slides/`
- Clear browser cache and try again

## Success!

Your students now have:
- ✅ Interactive presentation for following along in class
- ✅ Downloadable PDF for study and printing
- ✅ Real ACS 2024 data throughout
- ✅ Beautiful Econometria design
- ✅ Easy access from course website

Enjoy presenting with real data!
