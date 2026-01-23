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

## File Organization

```
content/
├── assignment/      # Labs, problem sets, research paper
│   └── materials/   # Data files (.dta), do-files, templates
├── bonus/           # Resources, FAQ, supplementary material
├── content/         # Weekly course content
├── home/            # Homepage widgets
├── schedule/        # Course schedule
└── syllabus/        # Syllabus

static/
├── slides/          # Lecture PDFs and thumbnails
├── img/             # Site images, icons
└── media/           # Hero image, other media

config/_default/
├── config.yaml      # Main Hugo config
├── params.yaml      # Course details, instructor info
└── menus.toml       # Navigation structure
```

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
| Preview site | `hugo server --buildFuture` |
| Add new week | Create `content/content/XX-content.md` |
| Add assignment | Create `content/assignment/XX-lab.md` |
| Update schedule | Edit `content/schedule/_index.md` |
| Change nav menu | Edit `config/_default/menus.toml` |
| Add slide PDF | Put in `static/slides/`, reference in front matter |

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
