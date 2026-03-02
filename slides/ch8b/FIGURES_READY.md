# ✓ Chapter 8b Figures Generated

**Completed:** February 28, 2026

## All 8 DAG Figures Created

| Figure | Size | Description |
|--------|------|-------------|
| `ch8b_simple_causal.png` | 41 KB | Simple causal path: Class Size → Test Scores |
| `ch8b_confounding.png` | 94 KB | Confounding via common cause (Wealth) |
| `ch8b_collider.png` | 83 KB | Collider bias: Talent & Connections → Job Hiring |
| `ch8b_unobserved_confounder.png` | 88 KB | Unobserved confounding: Ability confounds Education → Earnings |
| `ch8b_rct.png` | 88 KB | RCT breaks confounding: random assignment |
| `ch8b_knowledge_check_1.png` | 87 KB | Health Insurance example |
| `ch8b_complex_dag.png` | 137 KB | Complex DAG: SES, Education, Connections, Earnings |
| `ch8b_backdoor_path.png` | 61 KB | Backdoor path illustration |

**Total:** 1.4 MB of high-quality figures at 300 DPI

---

## Next Steps

### 1. Render the Slide Deck
```bash
cd /Users/ebeam/Dropbox/Github/econ3500.s26
quarto render slides/ch8b/ch8b_dags_causality.qmd
```

### 2. Copy to Site
```bash
./scripts/render_quarto_slides.sh \
  /Users/ebeam/Dropbox/Github/econ3500.s26/slides/ch8b/ch8b_dags_causality.qmd \
  ch8b-quarto \
  ch8b-slides.pdf
```

### 3. Generate PDF & Thumbnail
```bash
cd slides && ./render_reveal_pdf.sh
```

---

## Figure Locations

All figures are in: `/Users/ebeam/Dropbox/Github/econ3500.s26/slides/ch8b/ch8b_figures/`

The QMD file automatically references them with relative paths like `./ch8b_figures/ch8b_simple_causal.png`

---

## Ready to Preview

Once rendered, the slides will be available at:
`/Users/ebeam/Dropbox/Github/econ3500.s26/slides/ch8b/ch8b_dags_causality.html`

Open in browser to review before publishing to the course site.
