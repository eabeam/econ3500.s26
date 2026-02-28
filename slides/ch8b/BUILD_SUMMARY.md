# Chapter 8b: Causal Diagrams — Build Summary

**Created:** February 27, 2026
**Status:** Scaffold complete, ready for figure generation and rendering

---

## What's Been Created

### 1. **Main Slide Deck** (`ch8b_dags_causality.qmd`)
A comprehensive Quarto Reveal.js slide deck with:

- **Title & Learning Objectives** (5 clear learning goals)
- **7 major sections:**
  1. What Is Causality? (association vs. causation)
  2. Drawing and Reading DAGs (basics, path types)
  3. Confounding and Backdoor Bias (identification problem)
  4. Which Variables to Control For? (Backdoor Criterion, colliders)
  5. Application: Identifying Causal Effects (education/earnings, RCT example)
  6. Knowledge Checks and Practice (embedded with reveals)
  7. Appendix: Technical Details (d-separation for advanced students)

- **Features included:**
  - Callouts for key concepts and warnings
  - Keyword highlighting (`.kw`, `.alert`)
  - Reveal fragments (`. . .`) for stepwise disclosure
  - Placeholder references to figures (ready for PNG insertion)
  - 3+ embedded knowledge checks with hidden answers
  - Clear learning progression from intuition → mechanical rules → applications

### 2. **R Figure Generation Script** (`generate_dag_figures.R`)
Generates 8 publication-quality DAG visualizations:

1. `ch8b_simple_causal.png` — Basic Class Size → Test Scores
2. `ch8b_confounding.png` — Confounding via Wealth
3. `ch8b_blocking_backdoor.png` — Controlling for Wealth
4. `ch8b_unobserved_confounder.png` — Ability (unobserved)
5. `ch8b_collider.png` — Talent & Connections → Job Hiring
6. `ch8b_rct.png` — Randomized experiment (broken confounding)
7. `ch8b_knowledge_check_1.png` — Health Insurance example
8. `ch8b_complex_dag.png` — SES, Education, Connections, Earnings

All use `ggdag` package for clean, consistent styling.

### 3. **Documentation**
- `README.md` — Build instructions, pedagogy notes, file structure
- `BUILD_SUMMARY.md` — This file (quick reference)

### 4. **Directory Structure**
```
slides/ch8b/
├── ch8b_dags_causality.qmd         (main slide deck)
├── generate_dag_figures.R          (R script for figures)
├── ch8b_figures/                   (will be populated by R script)
├── README.md                       (chapter documentation)
└── BUILD_SUMMARY.md                (this file)
```

---

## Quick Build Instructions

### Step 1: Generate Figures (5 minutes)
```bash
cd /Users/ebeam/Dropbox/Github/econ3500.s26/slides/ch8b
Rscript generate_dag_figures.R
```
This populates `ch8b_figures/` with 8 PNG files.

### Step 2: Render Slides (2 minutes)
```bash
cd /Users/ebeam/Dropbox/Github/econ3500.s26
quarto render slides/ch8b/ch8b_dags_causality.qmd
```

### Step 3: Copy to Site (1 minute)
```bash
./scripts/render_quarto_slides.sh \
  /Users/ebeam/Dropbox/Github/econ3500.s26/slides/ch8b/ch8b_dags_causality.qmd \
  ch8b-quarto \
  ch8b-slides.pdf
```

### Step 4: Generate PDF & Thumbnail (1 minute)
```bash
cd slides && ./render_reveal_pdf.sh
```

---

## Content Highlights

### Pedagogical Approach
- **Intuition first:** Starts with "what is causality?" before introducing DAGs
- **Visual reasoning:** Heavy use of DAG diagrams to teach identification
- **Mechanical rules:** Introduces the Backdoor Criterion as a tool for answering "which variables to control for?"
- **Real applications:** Examples from education/earnings, health insurance, job hiring
- **Knowledge checks:** 3+ embedded checks with reveal-on-click answers

### Key Concepts Covered
- Distinction between association and causation
- Causal paths, backdoor paths, colliders
- Confounding and how to block it
- Unobserved confounding (limits of observational data)
- Why randomized experiments work (break confounding)
- Collider bias (controlling for the wrong variable)

### Aligns With Your Causality Guardrails
- Careful language: never overstates causal claims
- Clear about what we can and cannot identify
- Emphasizes confounding as a central challenge
- Notes when unobserved variables prevent causal identification

---

## Next Steps (Your Review)

### Content Review
1. **Verify examples** align with course level and audience
2. **Add domain-specific examples** from your research if desired
3. **Check knowledge check answers** for clarity and accuracy
4. **Adjust pacing** — add/remove slides as needed

### After Content Approval
1. Run figures generation script
2. Render and check for Quarto errors
3. Review slide layout and readability
4. Update site navigation (wire into Chapter 8.5 in course content)

### Optional Enhancements
- **Stata examples:** Add regression output if causal estimation is needed
- **Plotly interactive DAGs:** Allow students to explore path-blocking interactively
- **More practice problems:** Expand the practice section with 2–3 additional examples

---

## File Paths for Reference

| Item | Path |
|------|------|
| Main slide deck | `/Users/ebeam/Dropbox/Github/econ3500.s26/slides/ch8b/ch8b_dags_causality.qmd` |
| Figure script | `/Users/ebeam/Dropbox/Github/econ3500.s26/slides/ch8b/generate_dag_figures.R` |
| Output (figures) | `/Users/ebeam/Dropbox/Github/econ3500.s26/slides/ch8b/ch8b_figures/` |
| Rendered HTML | `/Users/ebeam/Dropbox/Github/econ3500.s26/slides/ch8b/ch8b_dags_causality.html` (after rendering) |
| Site location | `/Users/ebeam/Dropbox/Github/econ3500.s26/static/slides/ch8b-quarto/` (after copying) |

---

## Key Design Decisions

1. **Quarto Reveal.js format:** Consistent with existing chapters (ch4–ch12)
2. **R-generated figures:** Using `ggdag` for publication-quality DAGs
3. **No Stata needed:** Chapter 8b is conceptual (identification theory); Chapter 9 applies it to study design
4. **Placement:** Between Chapter 8 (multiple regression mechanics) and Chapter 9 (validity and study design) for logical flow
5. **Accessibility:** Heavy use of examples and visuals to make DAGs intuitive, not just formal

---

## Questions or Adjustments?

Before running the build steps, review the slide content in `ch8b_dags_causality.qmd` and let me know if you'd like to:

- Adjust section order or emphasis
- Add/remove examples
- Modify knowledge checks
- Change any phrasing or terminology
- Add additional applications from your research

Otherwise, ready to generate figures and render!
