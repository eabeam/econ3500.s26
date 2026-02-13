# Site Development Guide

Quick reference for developing and maintaining this Hugo course site.

## Local Preview

```bash
# Basic preview
hugo server

# Preview including future-dated content (useful during semester prep)
hugo server --buildFuture

# Or use the included script
./view.sh
```

Then open http://localhost:1313 in your browser. Changes auto-reload.

## Content Dates

Hugo respects the `date:` field in front matter. Content with future dates won't appear unless you use `--buildFuture`. This is useful for staging content before release.

```yaml
---
title: Week 5
date: "2026-02-09"    # Won't show until this date (or with --buildFuture)
---
```

Netlify deploy previews use `--buildFuture` so you can review staged content there.

## Adding Content

All content is plain Markdown (`.md`). No R or blogdown required.

### Shortcodes

Use Hugo shortcodes for dynamic elements:

```markdown
# Embed slides (uses pdf/thumb from front matter)
{{</* slides */>}}

# Embed a tweet
{{</* tweet "https://x.com/username/status/123" */>}}

# Embed YouTube video
{{</* youtube VIDEO_ID */>}}

# Course info block
{{</* courseinfo */>}}
```

### Front Matter for Content Pages

```yaml
---
title: Week 5 - Topic Name
sitetitle: Week 5
summary: "ECON3500 - Week 5 description"
date: "2026-02-01"
type: docs
menu:
  content:
    parent: Course content
    weight: 5

pdf: /slides/ch5-slides.pdf
thumb: /slides/ch5-slides.png
# Optional: interactive HTML version (see SLIDES_INTEGRATION_GUIDE.md)
slides_html: /slides/ch5-quarto/
---
```

### Adding Stata Code Blocks

Use fenced code blocks with `stata` language identifier:

~~~markdown
```stata
regress y x1 x2, robust
predict yhat, xb
```
~~~

## File organization

See **[README.md](README.md#repository-structure)** for the full directory tree. Summary: `content/` holds assignment, bonus, weekly content, home, schedule, syllabus; `config/_default/` has site and course settings; `layouts/` has templates and shortcodes; `static/` holds slides, images, and media; `scripts/` and `slides/` are for building lab PDFs and lecture slides.

## Updating Course Info

Edit `config/_default/params.yaml`:

```yaml
course:
  number: "ECON3500"
  semester: "Spring 2026"
  days: "TTh"
  time: "1:15–2:30"
  dates: "January 12 - May 8"
  location: "Living/Learning CM 314"

instructor:
  name: Dr. Emily Beam
  email: "emily.beam@uvm.edu"
  office: "337 Old Mill"
  office_hours: "Thursdays 2:30-4:30 PM"
```

## Building for Production

```bash
# Build the site
hugo --gc --minify

# Output goes to public/
```

Netlify builds automatically on push to master.

## Common Tasks

| Task | Command/Location |
|------|------------------|
| Preview site | `hugo server --buildFuture` or `./view.sh` |
| Add new week | Create `content/content/XX-content.md` |
| Add lab | Create `content/assignment/XX-lab.md` (and .tex if building PDF) |
| Add problem set | Create `content/assignment/XX-ps.md` |
| Update schedule | Edit `content/schedule/_index.md` |
| Change nav menu | Edit `config/_default/menus.toml` |
| Add lecture slides | Put PDF (and optional HTML) in `static/slides/`, set `pdf` and optional `slides_html` in content front matter. Build slides from `slides/` with Quarto (see `slides/README.md`, `SLIDES_INTEGRATION_GUIDE.md`) |
| Rebuild lab PDFs | `scripts/build_lab_pdf.py` etc. |

## Troubleshooting

**Content not showing?**
- Check the `date:` field - future dates are hidden by default
- Use `hugo server --buildFuture` to preview all content

**Shortcode not rendering?**
- Make sure syntax is `{{</* name */>}}` not backtick-r syntax
- Check shortcode exists in `layouts/shortcodes/`

**Build errors?**
- Run `hugo --verbose` for detailed output
- Check YAML front matter formatting (indentation matters)
