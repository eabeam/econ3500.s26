# ECON3500 Slides

Quarto Reveal.js slide decks for ECON3500: Econometrics and Applications.

## Directory Structure

```
slides/
├── _quarto.yml              # Project config with global defaults
├── _styles/                 # Shared styling resources
│   ├── custom-econometria.scss
│   ├── styles.css
│   ├── lazyload-fix.html
│   └── README.md
├── ch4/                     # Chapter 4: Linear Regression
│   ├── ch4_linear_regression.qmd
│   ├── ch4_figures/
│   ├── generate_regression_figures_education_wages_real.R
│   └── README.md
├── ch5/                     # Chapter 5: Hypothesis Tests
│   ├── ch5_hypothesis_tests.qmd
│   ├── ch5_figures/
│   ├── generate_ch5_figures.R
│   └── stata/
├── ch7/                     # Chapter 7: Hypothesis Tests (Multiple Regression)
├── ch9/                     # Chapter 9: Assessing Studies (no Stata)
├── ch10/                    # Chapter 10: Panel Data
├── ch12/                    # Chapter 12: Instrumental Variables
├── render_reveal_pdf.sh     # Script to render PDFs
└── post_render_fix.sh       # Post-render cleanup script
```

---

## Creating a New Chapter

### 1. Create the chapter directory

```bash
mkdir ch6
mkdir ch6/ch6_figures
```

### 2. Create the QMD file

Create `ch6/ch6_topic.qmd` with minimal YAML (inherits global settings):

```yaml
---
title: "Chapter Title"
subtitle: "SW Chapter 6"
author: "ECON3500: Econometrics and Applications"
date: "2026-01-01"
format:
  revealjs:
    footer: "ECON3500 | Chapter Topic"
---

## First Slide

Content here...
```

> **Important:** Do **not** add `output-dir` or `output-file` to per-file YAML.
> The `_quarto.yml` project config controls the output location, and per-file
> overrides are silently ignored. Rendered HTML will appear in the chapter
> folder (e.g. `slides/ch6/ch6_topic.html`).

### 3. Add figures, R scripts, and Stata logs as needed (see below)

Not every chapter needs all of these. Conceptual chapters (e.g. Ch9) may have no R figures or Stata output.

### 4. Render

```bash
quarto render ch6/ch6_topic.qmd
```

### 5. Copy to site

Rendered output must be manually copied to `static/slides/` for the Hugo site:

```bash
mkdir -p ../static/slides/ch6-quarto
cp ch6/ch6_topic.html ../static/slides/ch6-quarto/index.html
cp -r ch6/ch6_topic_files ../static/slides/ch6-quarto/
cp -r ch6/ch6_figures ../static/slides/ch6-quarto/
```

---

## Figures

### Where to put them

Each chapter has its own figures directory:

```
ch6/
├── ch6_topic.qmd
├── ch6_figures/           # All figures for this chapter
│   ├── ch6_scatter.png
│   ├── ch6_regression.png
│   └── ...
└── generate_ch6_figures.R
```

### Naming convention

Use the chapter prefix to avoid conflicts:
- `ch6_scatter.png`
- `ch6_regression_line.png`
- `ch6_residuals.png`

### Referencing in QMD

Use relative paths from the QMD file:

```markdown
![Scatter plot](./ch6_figures/ch6_scatter.png){width=60%}
```

With caption and alignment:

```markdown
![Regression results](./ch6_figures/ch6_regression.png){width=70% fig-align="center"}
```

### Recommended formats

- **PNG**: Best for most figures (good quality, reasonable size)
- **SVG**: For simple diagrams that need to scale
- **PDF**: Avoid for slides (use PNG instead)

### Recommended dimensions

Target 1280×720 slide dimensions. Good figure sizes:
- Full-width: 1100×600 px
- Half-width: 550×400 px
- Export at 150-200 DPI for crisp display

---

## R Code for Figure Generation

### Where to put it

Keep R scripts in the chapter directory:

```
ch6/
├── ch6_topic.qmd
├── ch6_figures/
└── generate_ch6_figures.R    # R script to generate all figures
```

### Script structure

```r
# generate_ch6_figures.R
# Generates figures for Chapter 6 slides
# Run from the ch6/ directory

library(ggplot2)
library(dplyr)

# Set output directory
fig_dir <- "./ch6_figures"
if (!dir.exists(fig_dir)) dir.create(fig_dir)

# Color palette (matches SCSS theme)
eco_navy <- "#19375F"
eco_teal <- "#008080"
eco_gold <- "#B8860B"
eco_silver <- "#708090"

# Theme for consistent styling
theme_econ <- theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(color = eco_navy, face = "bold"),
    axis.title = element_text(color = eco_navy),
    panel.grid.minor = element_blank()
  )

# Figure 1: Scatter plot
p1 <- ggplot(data, aes(x = x, y = y)) +
  geom_point(color = eco_teal, alpha = 0.7) +
  labs(title = "Title", x = "X Label", y = "Y Label") +
  theme_econ

ggsave(file.path(fig_dir, "ch6_scatter.png"), p1, 
       width = 10, height = 6, dpi = 150)

# Figure 2: ...
```

### Running the script

```bash
cd slides/ch6
Rscript generate_ch6_figures.R
```

Or from R:

```r
setwd("slides/ch6")
source("generate_ch6_figures.R")
```

---

## Stata Output

### Where to put log files

Keep Stata logs in a `stata/` subdirectory:

```
ch6/
├── ch6_topic.qmd
├── ch6_figures/
└── stata/
    ├── run_all.do          # Master do-file
    ├── regression.log
    └── diagnostics.log
```

### Preferred: Stata screenshot images

For regression tables and diagnostics, **Stata screenshot images** are preferred over HTML blocks. They render more reliably in Reveal.js with correct column alignment and spacing. Place screenshots in `chN/chN_figures/` with the chapter prefix (e.g. `ch7_stata_regression_base.png`).

### Alternative: The `stata-output` block

> **Known issue:** The `stata-output` HTML blocks have spacing and alignment problems in some Reveal.js configurations. Use screenshot images when possible.

Column alignment is only preserved if the output is **not** run through Markdown (which collapses spaces). Use a **raw HTML block** and the class `stata-output`:

1. In the QMD, add a raw HTML block and paste your Stata log inside `<pre class="stata-output">...</pre>`.
2. Escape HTML special characters in the pasted text so the block parses correctly:
   - `>` → `&gt;`  (e.g. `Prob > F` → `Prob &gt; F`, `P>|t|` → `P&gt;|t|`)
   - `<` → `&lt;`  (if any)
   - `&` → `&amp;` (if any)

Example:

```markdown
::: {=html}
<pre class="stata-output">. regress y x, robust

Linear regression                               Number of obs     =      1,388
                                                F(1, 1386)        =      12.34
                                                Prob &gt; F          =     0.0004
                                                R-squared         =     0.0088
...
       y | Coefficient  std. err.      t    P&gt;|t|     [95% conf. interval]
-------------+----------------------------------------------------------------
</pre>
:::
```

Global styling for `pre.stata-output` (monospace, `white-space: pre`, scroll, line-height) is in `_styles/styles.css`. YAML has `code-overflow: scroll` under `format.revealjs`.

### Generating clean log files

In your do-file:

```stata
* run_all.do - Generate logs for Chapter 6 slides

log using "regression.log", text replace
regress y x, robust
log close

log using "diagnostics.log", text replace
estat hettest
estat vif
log close
```

### Tips for readable logs

- Use `set linesize 80` for narrower output
- Trim unnecessary header/footer from logs
- Consider `quietly` for setup commands you don't want shown

---

## Slide Content Guidelines

### Slide structure

```markdown
## Slide Title {.smaller}

Content here...

. . .

More content (revealed on click)

::: {.callout-note}
## Box Title
Important concept here
:::
```

### Available callout types

```markdown
::: {.callout-note}
## Definition
For definitions and key concepts (teal)
:::

::: {.callout-important}
## Key Point
For critical takeaways (gold)
:::

::: {.callout-tip}
## Hint
For helpful tips (green)
:::

::: {.callout-warning}
## Caution
For common mistakes (orange)
:::
```

### Text styling

```markdown
[highlighted text]{.alert}           # Red bold
[keyword]{.kw}                       # Navy bold
[colored]{style="color: #008080;"}   # Custom color (teal)
```

### Size classes

Add to slide title for the whole slide:

```markdown
## Dense Slide {.smaller}
```

Or wrap specific content:

```markdown
::: {.smaller}
This text is smaller
:::
```

Available: `.tiny`, `.small`, `.smaller`, `.large`, `.larger`

### Math

Inline: `$\beta_1$`

Display:

```markdown
$$
\hat{\beta}_1 = \frac{\sum(X_i - \bar{X})(Y_i - \bar{Y})}{\sum(X_i - \bar{X})^2}
$$
```

### Code blocks

````markdown
```stata
regress wages education, robust
```
````

### Section dividers

Use level-1 headers for section breaks (styled with gradient background):

```markdown
# Section Title
```

---

## Rendering

### Single chapter

```bash
quarto render ch6/ch6_topic.qmd
```

### All chapters

```bash
quarto render
```

### PDF export

```bash
./render_reveal_pdf.sh ch6/ch6_topic.qmd
```

### Preview while editing

```bash
quarto preview ch6/ch6_topic.qmd
```

---

## Global Configuration

All chapters inherit settings from `_quarto.yml`:

| Setting | Value |
|---------|-------|
| Dimensions | 1280×720 |
| Theme | `_styles/custom-econometria.scss` |
| CSS | `_styles/styles.css` |
| Slide numbers | Yes |
| Chalkboard | Yes |
| Transitions | Fade |
| Scrollable | Yes |

Chapter-specific settings (like `footer`) override globals in each QMD file.

## Style Customization

See `_styles/README.md` for:
- Color palette reference
- Callout types and usage
- Custom CSS classes
- How to add chapter-specific overrides

---

## Dependencies

- **Quarto** ≥1.3
- **R** (for figure generation)
  - ggplot2, dplyr, tidyr
- **Stata** (for log file generation)

---

## Checklist for New Chapters

- [ ] Create chapter directory: `ch#/`
- [ ] Create figures directory: `ch#/ch#_figures/`
- [ ] If `ch#_figures/` already exists, check for stale files from prior attempts
- [ ] Create QMD file with minimal YAML header (**no** `output-dir` or `output-file`)
- [ ] Create R script for figures if needed: `generate_ch#_figures.R`
- [ ] Create Stata directory if needed: `ch#/stata/` (not all chapters need Stata)
- [ ] Generate figures before rendering
- [ ] Test render: `quarto preview ch#/ch#_topic.qmd`
- [ ] Final render: `quarto render ch#/ch#_topic.qmd`
- [ ] Copy rendered output to `static/slides/ch#-quarto/` (see step 5 above)