# Chapter 4: Linear Regression with One Regressor

Quarto Reveal.js slides for ECON3500 covering simple linear regression.

## Contents

| File | Description |
|------|-------------|
| `ch4_linear_regression.qmd` | Main slide deck source |
| `ch4_linear_regression.html` | Rendered HTML output |
| `generate_regression_figures_education_wages_real.R` | R script to generate figures |
| `ch4_figures/` | Generated figure images |
| `ch4_linear_regression_files/` | Quarto-generated libs (Reveal.js, syntax highlighting, etc.) |

## Rendering

From the `slides/` directory:

```bash
quarto render ch4/ch4_linear_regression.qmd
```

Or render all slides in the project:

```bash
quarto render
```

## Style Files

This chapter inherits global styles from `../_styles/`. See `_styles/README.md` for details.

**Global styles include:**
- `custom-econometria.scss` — SCSS theme (colors, typography, callouts)
- `styles.css` — CSS overrides (spacing, overflow, overview mode)
- `lazyload-fix.html` — JavaScript fix for lazy-loaded images

To add chapter-specific style overrides, create a local CSS file and reference it in the YAML front matter.

## Topics Covered

1. The linear regression model
2. Estimating coefficients: Ordinary Least Squares (OLS)
3. Measuring model fit (R², TSS, ESS, SSR, SER)
4. Assumptions for unbiased estimates (zero conditional mean)
5. Sampling distributions and uncertainty
6. Common misconceptions
7. Stata implementation

## Dependencies

- Quarto (≥1.3)
- R (for figure generation)
- ggplot2, dplyr (R packages)
