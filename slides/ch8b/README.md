# Chapter 8b: Causal Diagrams and Identifying Causal Effects

**Status:** Scaffold created, figures to be generated

## Overview

This chapter introduces students to directed acyclic graphs (DAGs) as a tool for understanding causality and determining which variables to control for in regression analysis. The chapter bridges the gap between Chapter 8 (hypothesis tests with multiple regression) and Chapter 9 (assessing studies), providing the conceptual framework for understanding causal identification.

### Learning Objectives

By the end of this chapter, students will be able to:

1. Draw and interpret directed acyclic graphs (DAGs)
2. Identify causal paths, backdoor paths, and colliders
3. Determine which variables to control for to identify a causal effect
4. Explain why controlling for the wrong variables creates bias
5. Apply DAG logic to real research questions

---

## Files in This Directory

| File | Purpose |
|------|---------|
| `ch8b_dags_causality.qmd` | Main slide deck (Quarto Reveal.js) |
| `generate_dag_figures.R` | R script to generate all DAG visualizations |
| `ch8b_figures/` | Generated PNG figures (run R script to populate) |
| `README.md` | This file |

---

## Building the Slides

### Step 1: Generate Figures

Run the R script to generate all DAG visualizations:

```bash
cd /Users/ebeam/Dropbox/Github/econ3500.s26/slides/ch8b
Rscript generate_dag_figures.R
```

This creates PNG files in `ch8b_figures/` for:
- Simple causal relationships
- Confounding and backdoor paths
- Collider bias
- Randomized experiments
- Example DAGs for knowledge checks

### Step 2: Render the Deck

From the repo root:

```bash
quarto render slides/ch8b/ch8b_dags_causality.qmd
```

### Step 3: Copy to Site

After rendering successfully:

```bash
mkdir -p static/slides/ch8b-quarto
cp slides/ch8b/ch8b_dags_causality.html static/slides/ch8b-quarto/index.html
cp -r slides/ch8b/ch8b_dags_causality_files static/slides/ch8b-quarto/
cp -r slides/ch8b/ch8b_figures static/slides/ch8b-quarto/
```

Or use the automated script:

```bash
./scripts/render_quarto_slides.sh /Users/ebeam/Dropbox/Github/econ3500.s26/slides/ch8b/ch8b_dags_causality.qmd ch8b-quarto ch8b-slides.pdf
```

### Step 4: Generate PDF and Thumbnail

```bash
cd slides
./render_reveal_pdf.sh
```

---

## Content Structure

The slide deck is organized into the following sections:

### 1. **What Is Causality?**
   - Distinction between association and causation
   - Why causality matters for policy and research
   - Introduction to DAGs as a framework

### 2. **Drawing and Reading DAGs**
   - DAG basics: nodes (variables) and arrows (causal relationships)
   - Example: Class size and student achievement
   - Types of paths: causal, backdoor, front door

### 3. **Confounding and Backdoor Bias**
   - Definition of confounding through common causes
   - How backdoor paths create bias
   - Blocking backdoor paths by controlling for confounders

### 4. **Which Variables to Control For?**
   - The Backdoor Criterion (mechanical rule for identifying causal effects)
   - Collider bias: why controlling for some variables creates bias
   - Real-world challenges (unobserved confounders)

### 5. **Application: Identifying Causal Effects**
   - Example 1: Education and earnings (unobserved ability)
   - Example 2: Program treatment effects (randomized experiments)

### 6. **Knowledge Checks and Practice**
   - Guided knowledge checks with reveal-on-click answers
   - Practice problems for students to think through DAG logic
   - Discussion prompts

### 7. **Appendix: Technical Details**
   - Formal definition of DAGs
   - d-Separation (advanced topic for depth)

---

## Pedagogy Notes

### Reasoning Over Memorization
The chapter emphasizes *why* we control for certain variables, not just *which* variables to control for. Students learn the mechanical Backdoor Criterion, but understand it through intuition and examples.

### Animations and Visuals
DAG figures illustrate each concept. The R script generates publication-quality visualizations that are clear and readable even in large lecture halls.

### Knowledge Checks
Embedded knowledge checks test understanding with:
- DAG interpretation questions
- Identification of confounders
- Reasoning about when to control for variables

Answers are revealed on click for discussion and review.

### Causality Language
All content adheres to the ECON3500 causality guardrails from the repo README:
- Careful distinction between "association," "causal effect," and "unbiased estimate"
- No overstating causal claims
- Clear language about what we can and cannot identify from data

---

## Source Material

This chapter draws on:

- **Primary reference:** "The Effect: An Introduction to Research Design and Causality" by Nick Huntington-Klein ([theeffectbook.net](https://theeffectbook.net/)), particularly Chapters 6–9 on DAGs and causal inference
- **Theory foundation:** Stock and Watson (the course textbook) on causality and identification
- **Pedagogy:** Emphasis on intuition and real-world examples

---

## Next Steps (After Content Review)

1. **Fill in application examples** from your research or domain expertise
2. **Add Stata knowledge checks** if regression output is needed (currently none)
3. **Embed Plotly animations** if interactive DAG exploration is desired
4. **Link to Chapter 9** (threats to internal validity) to show how DAGs connect to study design

---

## Technical Notes

- **QMD format:** Quarto Reveal.js (HTML5 slides)
- **Figures:** R + `ggdag` package (publication-quality PNG)
- **Rendering:** Quarto handles all dependencies
- **Output:** Self-contained HTML with embedded figures

---

## Questions?

Refer to:
- `slides/SLIDE_DEVELOPMENT_INSTRUCTIONS.md` for general slide conventions
- `slides/README.md` for Quarto configuration and rendering troubleshooting
- `SLIDES_INTEGRATION_GUIDE.md` (repo root) for site wiring
