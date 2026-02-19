# Slide Development Instructions (Remaining Chapters)

Use this document when developing or revising lecture slides for chapters not yet in the current Quarto Reveal.js format. It focuses on **conceptual work and content**; **do not** design new templates or themes. 

**Remaining chapters:** 13–14 blend, 15.
**Completed:** 4, 5, 6, 7, 8, 9, 10, 12.

---

## 1. Source Materials and Output Format

### Source (Beamer .tex, PDF, or PPTX)

- **Location:**
  `'/Users/ebeam/Library/CloudStorage/OneDrive-UniversityofVermont(2)/UVM-Teaching/UVM-EC200/ECON3500-Spring_2026/00_ECON3500_Shared/03 Lecture Slides'`
- These are the original decks. Use them for subject matter, learning points, presentation style, and pedagogy.
- **Not all chapters have .tex files.** Some chapters (e.g. Ch12) only have PDF or PPTX. Read the PDF page by page to extract content and structure. The same conversion workflow applies regardless of source format.

### Output (Quarto Reveal.js)

- **Do not** create a new Beamer style or design.
- **Use existing templates** from chapters already in the repo:
  - **Ch4:** `ch4/ch4_linear_regression.qmd`
  - **Ch5:** `ch5/ch5_hypothesis_tests.qmd`
  - **Ch6:** `ch6/ch6_multiple_regression.qmd`
  - **Ch7:** `ch7/ch7_hypothesis_tests_multiple.qmd`
  - **Ch8:** `ch8/ch8_nonlinear_relationships.qmd`
  - **Ch9:** `ch9/ch9_assessing_studies.qmd` *(conceptual chapter — no Stata output)*
  - **Ch10:** `ch10/ch10_panel_data.qmd` *(panel data with Stata do-file)*
  - **Ch12:** `ch12/ch12_instrumental_variables.qmd` *(IV — built from PDF, Stata code blocks)*
- Mirror their YAML (title, subtitle, author, date, `format.revealjs.footer`).
- **Do not** use `output-dir` or `output-file` in per-file YAML — the `_quarto.yml` project config overrides them. Output lands in the chapter folder (e.g. `slides/ch7/`).
- Follow **README.md** (this directory) for directory layout, figure naming, R/Stata workflow, and styling (callouts, `.smaller`, `.scrollable`, etc.).
- Built output must be **manually copied** to `../static/slides/chN-quarto/` (see §6 build steps). PDF and thumbnail via `render_reveal_pdf.sh` and `../static/make_slidepng.sh`.

---

## 2. Content and Pedagogy

### Rhetoric and narrative

- Restructure the **same subject matter and key learning points** with a **new rhetoric** where it improves clarity.
- Preserve **your pedagogy** as detected from the .tex (pacing, emphasis, order of ideas).
- Maintain **technical rigor**; textbook is **Stock and Watson** (see repo root **README.md**).

### Instructor style

- **Reasoning over memorization:** Prefer clear reasoning so students understand *why*; avoid asking students to memorize without explanation.
- **Proofs in appendix slides:** Put formal proofs in appendix slides so the main narrative stays focused; students can go deeper when they want.
- **Animations and interactive demos:** When an animation or Plotly (or similar) demo can increase understanding, include it.
- **Precise language:** Use precise, technically correct wording throughout; avoid vagueness or informal shortcuts that could mislead.
- **Test understanding and the *why*:** Include opportunities for students to test their understanding and think through the *why* (e.g. knowledge checks, “why does this hold?”, interpretation questions).

### Cognitive density and flow

- **Optimal cognitive density:** smooth delivery, not overloaded at the slide level.
- Distribute content so density is **balanced across slides**; avoid single slides that are too dense.
- Use **section dividers** (`# Section Title`) and clear slide titles (`## Slide Title`).
- Use `.smaller` or `.scrollable` when a slide has more content; use fragments (`. . .`) to reveal stepwise.

### Causality (mandatory)

- Follow **README.md** (repo root):
  - As an example, The **three least squares assumptions** are the criteria for **unbiasedness** of the OLS estimator. They are **not** the criteria for a **causal interpretation** of a regression.
  - Be **conservative** with causal claims; do not treat “unbiased under the assumptions” as equivalent to “causal.”
- Review all slide text and callouts and remove or soften any wording that overstates causality. (Accurate stating of causality is fine)

---

## 3. R vs Stata: Demos, Illustrations, and Regression

### R: demos and illustrations

- Use **R** for **demos and illustrations**: figures, conceptual visuals, scatter plots, diagrams, and any graphics that illustrate ideas.
- R scripts live in the chapter folder (e.g. `generate_ch6_figures.R`), writing to that chapter’s figure folder (e.g. `./chN_figures/`). **Run the R code first**, then insert the generated PNGs (and TeX if needed) into the deck.
- See **README.md** (this directory) for paths and naming (`chN_*.png`).

### Stata: regression code and output (what students see)

- Whenever students **see code and interpret regression results**, use **Stata** only.
- Embed Stata code in the QMD with ` ```stata ` code blocks.
- For **Stata regression output** (tables, diagnostics), prefer **Stata screenshot images** over `stata-output` HTML blocks. The `<pre class="stata-output">` pattern has known spacing/alignment issues in Reveal.js. Screenshot images placed in `chN/chN_figures/` render more reliably.
  - **Fallback:** When screenshots are not available (e.g. building from a PDF source without access to run Stata), ` ```stata ` code blocks with the output pasted in are acceptable. They render cleanly and can be swapped for screenshots later.
  - If you do use `stata-output` HTML blocks, see **README.md** (this directory) for the raw HTML pattern.
- Provide **accompanying Stata do-files** so you can do walkthroughs and students can run the same commands. Keep do-files (and logs) in `chN/stata/` (e.g. `run_all.do`, or topic-specific do-files). The slides should reference or mirror these scripts.
- **Not every chapter needs Stata.** Conceptual chapters (e.g. Ch9: Assessing Studies) may have no regression output at all. Only create `stata/` directories and do-files when the chapter includes regression demonstrations.

---

## 4. Figures and Tables

### Generation (R)

- Figures and tables used as **illustrations** are based on **R output** (PNG and, if needed, TeX for tables). Run R first; then insert generated files into the deck.
- Regression **output** that students see (coefficients, SEs, tests) comes from **Stata** (see §3).

### Quality and placement

- Aim for **clear, readable figures and tables**; avoid cluttered or mislabeled graphics.
- In QMD, reference figures with relative paths: `./chN_figures/chN_filename.png`, with `{width=...}` or `fig-align="center"` as needed.
- If you use any coordinate-based graphics (e.g. TikZ in R), **check label positions and coordinates** so labels are not cut off or misplaced (these often do not show up as compile errors).

---

## 5. Knowledge Checks and Practice

- Include **more knowledge checks** (e.g. short conceptual questions with optional reveal).
- Include **practice problems** where appropriate (formulas, interpretation, Stata output).
- Use callouts (e.g. `::: {.callout-tip}` for “Knowledge Check” or “Try it”) and optional “Answer” overlay reveals.

---

## 6. Multi-Agent Build and Review

Use a **multi-agent** workflow: one agent builds and compiles; a second reviews content and narrative; a third reviews graphics only.

### Agent 1: Build and compile

1. Convert/author the deck using the templates and conventions above.
2. **Check for stale files:** If `chN/chN_figures/` already exists, inspect it — previous attempts may have left unrelated images. Remove anything not used by the new deck.
3. **Render:** From repo root, `quarto render slides/chN/chN_topic.qmd`. Resolve any Quarto errors.
4. **Copy to site:** The rendered HTML lands in `slides/chN/` (not `static/`). Manually copy:
   ```bash
   mkdir -p static/slides/chN-quarto
   cp slides/chN/chN_topic.html static/slides/chN-quarto/index.html
   cp -r slides/chN/chN_topic_files static/slides/chN-quarto/
   cp -r slides/chN/chN_figures static/slides/chN-quarto/
   ```
   Or use the single-step build + sync script:
   ```bash
   ./scripts/render_quarto_slides.sh /Users/ebeam/Dropbox/GitHub/econ3500.s26/slides/chN/chN_topic.qmd chN-quarto chN-slides.pdf
   ```
5. **PDF:** Run `slides/render_reveal_pdf.sh` for the chapter. Fix any overfull/underfull or layout issues.
6. Recompile after fixes until the deck builds cleanly.

### Agent 2: Content and narrative review

- Evaluate whether the instructions in this document were met:
  - Rhetoric, pedagogy, narrative flow, technical rigor (Stock and Watson).
  - **Instructor style:** reasoning over memorization; proofs in appendix where appropriate; animations/Plotly when they aid understanding; precise language; opportunities to test understanding and think through the *why*.
  - Cognitive density and balance across slides.
  - Causality language (no overclaim; README rules followed).
  - R for illustrations/demos; Stata for all regression code and output that students see.
  - Knowledge checks and practice problems present.
- Recommend concrete edits (slide text, structure, callouts). Apply adjustments and recompile.

### Agent 3: Graphics-only review

- Check **only** figures and tables:
  - Correct labels, alignment, and numerical accuracy.
  - No mislabeled or misplaced elements (especially in coordinate-based/TikZ-style graphics).
- Recommend fixes to R scripts or placements. Apply and recompile a final time.

### After review: site wiring

- If the chapter is new, add `slides_html: /slides/chN-quarto/` to the corresponding `content/content/NN-content.md` and ensure PDF/thumbnail are in `static/slides/` (see **SLIDES_INTEGRATION_GUIDE.md** in repo root).

---

## 7. References in This Repo

| Document | Location | Purpose |
|----------|----------|--------|
| **README.md** | This directory (`slides/`) | Quarto slide conventions, figures, R/Stata, callouts, rendering |
| **README.md** | Repo root | Causality rules, textbook as source of truth, repo structure |
| **SLIDES_CH6_CH8_PLAN.md** | Repo root | Example conversion plan (Beamer → Quarto) for Ch6 and Ch8 |
| **SLIDES_INTEGRATION_GUIDE.md** | Repo root | How built slides hook into the site (PDF, HTML, shortcode) |
| **DEVELOPMENT.md** | Repo root | Content dates, shortcodes, front matter |

---

## 8. Checklist for a New or Revised Chapter

- [ ] Use existing QMD template (ch4, ch5, ch6, ch7, ch8, ch9); no new theme design.
- [ ] YAML has `format.revealjs.footer` but **no** `output-dir` or `output-file`.
- [ ] Instructor style: reasoning over memorization; proofs in appendix as needed; animations/Plotly where helpful; precise language; chances to test understanding and the *why*.
- [ ] R for demos/illustrations (figures); Stata for regression code and output students see (if applicable — not all chapters need Stata).
- [ ] Stata output shown as **screenshot images** (preferred), ` ```stata ` code blocks (fallback), or `stata-output` HTML blocks. Stata do-files in `chN/stata/` when applicable.
- [ ] Causality language checked against repo root README.md.
- [ ] Knowledge checks and/or practice problems added.
- [ ] R figures generated first; paths `./chN_figures/chN_*.png`.
- [ ] Check `chN_figures/` for stale files from prior attempts; remove unused images.
- [ ] Multi-agent review: build → content pass → graphics pass; recompile after each.
- [ ] Rendered HTML **manually copied** to `static/slides/chN-quarto/`.
- [ ] PDF and thumbnail generated; site wiring updated if new chapter.
