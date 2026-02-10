# Global Styles for ECON3500 Slides

Shared styling resources for all Quarto Reveal.js slide decks in this course.

## Files

| File | Description |
|------|-------------|
| `custom-econometria.scss` | SCSS theme defining colors, typography, and component styles |
| `styles.css` | CSS overrides for spacing, overflow handling, and overview mode |
| `lazyload-fix.html` | JavaScript fix for lazy-loaded images in Reveal.js |

## Color Palette

| Variable | Hex | Usage |
|----------|-----|-------|
| `$eco-navy` | `#19375F` | Headings, primary text, emphasis |
| `$eco-teal` | `#008080` | Links, accents, h2 underlines |
| `$eco-gold` | `#B8860B` | Important callouts, title slide accents |
| `$eco-silver` | `#708090` | Footer, table borders |
| `$eco-light-teal` | `#E6F4F1` | Note callout backgrounds |
| `$eco-light-gold` | `#FFF8E1` | Important callout backgrounds |
| `$eco-light-gray` | `#F5F5F5` | Code backgrounds |

## Callout Types

Use Quarto's built-in callout syntax:

```markdown
::: {.callout-note}
## Title
Content here
:::
```

Available types:
- `.callout-note` — Teal, for definitions and key concepts
- `.callout-important` — Gold, for critical points
- `.callout-tip` — Green, for helpful hints
- `.callout-warning` — Orange, for cautions and common mistakes

## Custom Classes

- `.alert` — Red bold text for emphasis (like Beamer's `\alert{}`)
- `.kw` — Navy bold for keywords
- `.smaller` — 85% font size for dense slides
- `.small`, `.tiny`, `.large`, `.larger` — Additional size variants

## Usage in Chapter QMD Files

Individual chapter files inherit all global settings from `_quarto.yml`. 
Only chapter-specific settings (like `footer`) need to be specified:

```yaml
---
title: "Chapter Title"
subtitle: "SW Chapter X"
author: "ECON3500: Econometrics and Applications"
date: "2026-01-01"
format:
  revealjs:
    footer: "ECON3500 | Chapter Topic"
---
```

## Modifying Styles

1. **Global changes**: Edit files in this directory — affects all chapters
2. **Chapter-specific overrides**: Add a local `styles.css` in the chapter folder and reference it in the chapter's YAML

To add a chapter-specific CSS file:

```yaml
format:
  revealjs:
    footer: "ECON3500 | Topic"
    css: 
      - ../_styles/styles.css  # Global (inherited)
      - local-overrides.css    # Chapter-specific
```
