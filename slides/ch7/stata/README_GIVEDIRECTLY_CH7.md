# Chapter 7: Hypothesis Tests — GiveDirectly Kenya Data

## Overview

This folder contains Stata do-files and data for demonstrating three types of hypothesis tests in multiple regression, using data from Egger et al. (2022): *"General Equilibrium Effects of Cash Transfers: Experimental Evidence from Kenya"* (Econometrica 90(6):2603-2643).

**Study Context:**
- Location: 653 villages in rural Kenya
- Intervention: Unconditional cash transfers (~$1,000 per household)
- Sample: 10,500+ households
- Key outcomes: Consumption, income, assets, prices
- Design: Randomized at village level; within-village eligibility variation

---

## Files in This Directory

### Data Preparation (RUN FIRST)
- **`00_prepare_data.do`** — Prepares the data for analysis
  - Input: `GE_HHLevel_ECMA.dta` from replication materials
  - Outputs:
    - `ge_ch7_analysis_data.dta` (full dataset, 10,500+ households)
    - `ge_ch7_student_data.dta` (classroom dataset, 1,200 households)

### Analysis Do-Files (RUN AFTER DATA PREP)
- **`ge_ch7_analysis.do`** — Complete hypothesis testing demonstration
  - Instructor reference / Full analysis
  - Demonstrates all three test types with detailed explanations
  - Type 1: Single coefficient (β_eligible = 0?)
  - Type 2: Equality test (β_eligible = β_ineligible?)
  - Type 3: Joint F-test (all effects = 0?)
  - ~1,200 lines with interpretation

- **`ge_ch7_student_working.do`** — Interactive student exercise
  - 18 fill-in-the-blank questions
  - Students work through the three test types
  - Uses smaller `ge_ch7_student_data.dta`
  - ~300 lines, classroom-friendly

### Data Files (After running 00_prepare_data.do)
- **`ge_ch7_analysis_data.dta`** — Full analysis dataset
  - 10,500+ households, 8 variables
  - Used by instructors and for publication figures

- **`ge_ch7_student_data.dta`** — Classroom working dataset
  - ~1,200 households (random sample)
  - Faster to compute, easier for classroom demos
  - Used by `ge_ch7_student_working.do`

---

## How to Use

### Step 1: Prepare Data
Open Stata and run:
```stata
do 00_prepare_data.do
```

This will:
1. Load the replication materials from `/Users/ebeam/Downloads/replication_materials/analysisdata/GE_HHLevel_ECMA.dta`
2. Verify key variables exist (eligible, treat, consumption)
3. Create `ge_ch7_analysis_data.dta` (10,500+ households)
4. Create `ge_ch7_student_data.dta` (~1,200 households, 8 variables)

**Note:** This step requires write access to this directory and the ability to read from the replication materials folder.

### Step 2A: Instructor Analysis (Full Reproduction)
Open Stata and run:
```stata
do ge_ch7_analysis.do
```

Output:
- Complete demonstration of all three hypothesis test types
- Manual calculations alongside Stata commands
- Economic interpretation
- Summary tables comparing models
- Ready for extracting figures/tables for slides

### Step 2B: Classroom Exercise (Student Activity)
Distribute to students:
- `ge_ch7_student_data.dta`
- `ge_ch7_student_working.do`

Students open Stata and work through:
```stata
do ge_ch7_student_working.do
```

They will answer questions (Q1-Q18) throughout the file, demonstrating understanding of:
- Type 1 tests (single coefficient)
- Type 2 tests (equality of coefficients)
- Type 3 tests (joint F-tests)
- Interpretation of results

---

## Key Variables in Student Dataset

| Variable | Type | Description | Values |
|----------|------|-------------|--------|
| `hh_id` | Numeric | Household ID | Unique identifier |
| `village_id` | Numeric | Village code | Groups households by village |
| `eligible` | Binary | =1 if eligible for direct transfer | 0 or 1 |
| `treat` | Binary | =1 if village assigned to treatment | 0 or 1 |
| `ineligible` | Binary | =1 if NOT eligible | 0 or 1 |
| `consumption` | Continuous | Household consumption (KES/month) | Numeric, PPP-adjusted |
| `female_head` | Binary | =1 if household head is female | 0 or 1 |
| `hh_size` | Continuous | Household size (# members) | Numeric |
| `age_head` | Continuous | Age of household head | Numeric, years |

---

## Three Types of Hypothesis Tests Demonstrated

### Type 1: Single Coefficient Test (t-test)
```
H₀: β_eligible = 0
Question: Is there a direct effect of eligibility on consumption?
Test: t = β̂ / SE(β̂)
Stata: regress consumption eligible, robust
```

### Type 2: Equality of Two Coefficients (t-test)
```
H₀: β_eligible = β_ineligible
Question: Are direct effects equal to spillover effects?
Test: t-test (or equivalently, F-test with 1 restriction)
Stata: test eligible = ineligible
```

### Type 3: Joint Significance F-test
```
H₀: β_eligible = β_ineligible = β_treat = 0
Question: Can we exclude all treatment variables?
Test: F = [(SSR_r - SSR_ur) / q] / [SSR_ur / (n - k - 1)]
Stata: testparm eligible ineligible treat
```

---

## Expected Results

### Main Findings (Typical Output)
- **Direct Effect (eligible):** +1,200 to +1,800 KES/month (p < 0.05)
- **Spillover Effect (ineligible):** +500 to +1,200 KES/month (p < 0.05-0.10)
- **Village Treatment Effect (treat):** -100 to +500 KES/month (p > 0.05)
- **Type 2 Test (β_eligible = β_ineligible):** F ≈ 1-3, p ≈ 0.05-0.20
- **Type 3 Test (joint significance):** F ≈ 15-25, p < 0.001

Note: Exact values depend on the sample drawn and controls included.

---

## Important Notes

### Data Source
- **Original Study:** Egger et al. (2022), Econometrica
- **Replication Materials:** https://www.econometricsociety.org/publications/econometrica/2022/11/01/General-Equilibrium-Effects-of-Cash-Transfers-Experimental-Evidence-From-Kenya
- **Public Data:** GE_HHLevel_ECMA.dta (no restricted GPS data included)

### Simplified Design for Teaching
For pedagogical clarity, the student exercise focuses on:
- **Treatment structure:** Eligible vs. ineligible households in treatment vs. control villages
- **Outcome:** Consumption only (not income, assets, prices, or other outcomes)
- **Robustness:** All analyses use heteroskedasticity-robust standard errors

This simplified design maps directly to the three types of hypothesis tests without overwhelming complexity.

### Reproducibility
- All do-files use **absolute paths** (adjust if needed on your system)
- Analysis uses **robust standard errors** throughout (heteroskedasticity-consistent)
- Student dataset created with **fixed seed** for reproducibility
- No external packages required beyond base Stata

---

## Troubleshooting

### Error: "GE_HHLevel_ECMA.dta not found"
- Check that the replication materials are downloaded at `/Users/ebeam/Downloads/replication_materials/`
- Update the path in `00_prepare_data.do` if your materials are stored elsewhere

### Error: "Variable not found"
- Run `00_prepare_data.do` first to create the analysis datasets
- Check that you're running the student analysis on `ge_ch7_student_data.dta`, not the raw materials

### Output looks different from expected
- Results may vary slightly due to:
  - Different random sample in `ge_ch7_student_data.dta`
  - Rounding in display options
  - Stata version differences
- Interpretation and test types remain the same

---

## For Instructors

### Classroom Workflow
1. **Before class:** Run `ge_ch7_analysis.do` to generate output for slides
2. **During class:** Display rendered slides (from Quarto QMD)
3. **Live coding (optional):** Run sections of `ge_ch7_student_working.do` as demo
4. **Student assignment:** Have students complete `ge_ch7_student_working.do` individually or in pairs
5. **Discussion:** Review answers using `ge_ch7_analysis.do` as answer key

### Generating Slide Figures
After running `ge_ch7_analysis.do`, capture Stata output:
1. Run each regression in Stata
2. Copy/paste output into text editor
3. Convert to PNG (300 dpi, clean formatting)
4. Store in `ch7_figures/` folder
5. Link in Quarto QMD file

### Adaptations
- **Shorter class period:** Use only Type 1 test, skip Type 2-3
- **Advanced class:** Add interaction terms, run spatial analysis (coordinates available with permission)
- **Different outcome:** Substitute income, assets, or prices (all available in source data)

---

## Citation

If using these materials in teaching, please cite:

**Original Paper:**
Egger, D., Haushofer, J., Miguel, E., Niehaus, P., & Walker, M. W. (2022). General equilibrium effects of cash transfers: Experimental evidence from Kenya. *Econometrica*, 90(6), 2603–2643. https://doi.org/10.3982/ECTA17945

**Replication Materials:**
Egger, D., Haushofer, J., Miguel, E., Niehaus, P., & Walker, M. W. (2022). Replication data and code for: General equilibrium effects of cash transfers: Experimental evidence from Kenya. *Econometric Society Data Repository*. https://doi.org/10.5281/zenodo.6526319

---

## Questions?

See the Quarto markdown file (`ch7_hypothesis_tests_multiple.qmd`) for full lecture slides.

For issues with the data or code, refer to the original replication materials and paper.
