# Ch6 and Ch8 Slides Update Plan

This document captures the plan for adding Quarto Reveal.js decks for **Chapter 6 (Multiple Regression)** and **Chapter 8 (Nonlinear Relationships)** to the course site, converting from existing Beamer/LaTeX and R figure scripts.

---

## Source materials

| Chapter | Deck (Beamer .tex) | R figure script | Figure output |
|---------|--------------------|-----------------|---------------|
| **Ch6** | `/Users/ebeam/Dropbox/ECON3500/ch6_multiple_regression_new.tex` | `generate_multiple_regression_figures.R` | 7 PNGs in `ECON3500/Lab/figures/` (ch6_*) |
| **Ch8** | `/Users/ebeam/Dropbox/ECON3500/ch8_nonlinear_relationships_new.tex` | `generate_ch8_figures.R` | 8 PNGs in `ECON3500/Lab/figures/` (ch8_*) |

**Note:** The Ch8 deck and script were renamed from ch7 → ch8; the nonlinear content is SW Chapter 8. Week 7 remains “Hypothesis Tests with Multiple Regressions” (Ch7); Week 8 is “Nonlinear Regression Functions” (Ch8).

---

## Chapter 6: Multiple Regression

### Source (unchanged)

- **Deck:** `/Users/ebeam/Dropbox/ECON3500/ch6_multiple_regression_new.tex`
- **R script:** `/Users/ebeam/Dropbox/ECON3500/generate_multiple_regression_figures.R`
  - Uses `setwd("/Users/ebeam/Dropbox/ECON3500/Lab")` and writes to `figures/`
  - **Figures (7):** ch6_omitted_variable_bias.png, ch6_ceteris_paribus.png, ch6_r2_vs_adj_r2.png, ch6_perfect_multicollinearity.png, ch6_imperfect_multicollinearity.png, ch6_partial_regression.png, ch6_ovb_sign.png
  - **R packages:** ggplot2, gridExtra, grid, scales, dplyr; optional tikzDevice; one plot uses `tidyr::pivot_longer`

### Repo structure

- `slides/ch6/`
- `slides/ch6/ch6_figures/` (all Ch6 PNGs)
- `slides/ch6/ch6_multiple_regression.qmd` (converted deck)
- Optional: `slides/ch6/generate_ch6_figures.R` (adapted script), `slides/ch6/stata/` (if linking walkthrough)

### Conversion (Beamer → Quarto)

1. **YAML**  
   Mirror ch4: title, subtitle (e.g. "Chapter 6" / "SW Chapter 6"), author, date, and:
   - `output-dir: ../../static/slides/ch6-quarto`
   - `output-file: index.html`
   - `format.revealjs.footer` for Ch6

2. **Structure**
   - `\section{...}` → `# Section Title`
   - `\begin{frame}{...}` → `## Slide Title` (add `.smaller` / `.scrollable` where useful)

3. **Content**
   - `\begin{definition}`, `\begin{keyconcept}` / `\begin{alertblock}` → `::: {.callout-note}` / `::: {.callout-important}` (and tip/warning as needed)
   - `\includegraphics{Lab/figures/ch6_...}` → `./ch6_figures/ch6_...` with `![...](...){width=...}`
   - `\begin{lstlisting}[style=Stata}` → ` ```stata` code blocks
   - `\bhat` → `$\hat{\beta}$`; other math unchanged (LaTeX)
   - `\pause` → `. . .` or fragments
   - Example/alert blocks for “Knowledge Check” → callouts, optional “Answer” reveal

4. **R script in repo (optional but recommended)**
   - Copy `generate_multiple_regression_figures.R` → `slides/ch6/generate_ch6_figures.R`
   - Set working directory to `slides/ch6/` and write only to `./ch6_figures/` (drop or keep TikZ optional; Quarto only needs PNG)
   - Ensure `tidyr` is loaded for `pivot_longer`
   - Run from `slides/ch6/` so PNGs go into `ch6_figures/`

### Build and site wiring

- **HTML:** From repo root: `quarto render slides/ch6/ch6_multiple_regression.qmd`
- **PDF:** `slides/render_reveal_pdf.sh ch6/ch6_multiple_regression.qmd` → `static/slides/ch6-slides.pdf`
- **Thumbnail:** Run `static/make_slidepng.sh` so `static/slides/ch6-slides.png` exists
- **Content page:** In `content/content/06-content.md` add `slides_html: /slides/ch6-quarto/` so the shortcode shows “View Slides Online” and “Download PDF”

### Ch6 deck scope (from .tex)

- Why multiple regression; the multiple regression model; OLS estimation (and optional matrix slide); interpreting coefficients (ceteris paribus, wage example, knowledge check); omitted variable bias (setup, formula, when OVB occurs, signing bias, visuals, examples); measures of fit (R², adjusted R², knowledge check, R² vs adj R² plot, Stata example); least squares assumptions (four assumptions, zero conditional mean, no perfect multicollinearity, perfect/imperfect multicollinearity); Stata (syntax, VIF, partial regression plot); synthesis and key formulas; “Looking ahead” to nonlinear (Ch8).

---

## Chapter 8: Nonlinear Relationships

### Source (renamed from ch7)

- **Deck:** `/Users/ebeam/Dropbox/ECON3500/ch8_nonlinear_relationships_new.tex`
- **R script:** `/Users/ebeam/Dropbox/ECON3500/generate_ch8_figures.R`
  - Writes to `Lab/figures/` with filenames `ch8_*.png`
  - **Figures (8):** ch8_quadratic_relationship.png, ch8_marginal_effect_quadratic.png, ch8_interaction_continuous.png, ch8_interaction_binary.png, ch8_loglog_specification.png, ch8_log_specifications.png, ch8_interpretation_guide.png, ch8_testing_functional_form.png

### Repo structure

- `slides/ch8/`
- `slides/ch8/ch8_figures/`
- `slides/ch8/ch8_nonlinear_relationships.qmd` (converted from ch8_nonlinear_relationships_new.tex)
- Optional: `slides/ch8/generate_ch8_figures.R` (adapted to output to `./ch8_figures/`)

### Conversion

Same approach as Ch6: Beamer → Quarto (sections, frames, callouts, image paths `./ch8_figures/ch8_*`, Stata blocks, math, fragments). YAML with `output-dir: ../../static/slides/ch8-quarto`, `output-file: index.html`.

### Build and site wiring

- Render QMD; run `render_reveal_pdf.sh` for ch8; run `make_slidepng.sh`
- In `content/content/08-content.md` add `slides_html: /slides/ch8-quarto/`

---

## Suggested order of work

| Step | Task |
|------|------|
| 1 | Create `slides/ch6/`, `slides/ch6/ch6_figures/`; optionally adapt and run Ch6 R script so figures are in `ch6_figures/` |
| 2 | Convert `ch6_multiple_regression_new.tex` → `slides/ch6/ch6_multiple_regression.qmd` |
| 3 | Render Ch6 HTML and PDF; generate thumbnail; add `slides_html` to `06-content.md` |
| 4 | Repeat for Ch8: create `slides/ch8/`, `ch8_figures/`, convert .tex to .qmd, adapt R script, render, add `slides_html` to `08-content.md` |

---

## References

- **slides/README.md** — Quarto slide conventions, figure naming, R/Stata workflow, styling
- **SLIDES_INTEGRATION_GUIDE.md** — How built slides hook into the site (PDF + HTML, shortcode, content front matter)
- **DEVELOPMENT.md** — Content dates, shortcodes, front matter for `pdf` / `thumb` / `slides_html`
