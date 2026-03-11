---
type: plan
project: econ3500
status: to-process
date: 2026-03-11
---

# Lab 7 & 8 Revision Plan

## Goal
Revise Labs 7 (Difference-in-Differences) and 8 (Instrumental Variables) to:
1. Match the updated template conventions established in Labs 4 and 6
2. Fill knowledge gaps so students can succeed
3. Fix typos and unclear sections

---

## Phase 1: Template alignment (both labs) — DONE

### 1a. Lab 7

- [x] Update Materials to link `econ3500_lab_template.do` (not `labtemplate_f21.do`)
- [x] Add **Data context** section for both datasets (`banks.dta` and `nsly_marijuana.dta`)
- [x] Add **Variables we'll use** tables for both datasets
- [x] Add **Workflow overview** section
- [x] Add **"What do I submit?"** section with submission checklist
- [x] Add robust SE reminder where appropriate
- [x] Add `{{% alert note %}}` hint boxes for tricky steps
- [x] Renumber Part B questions to continue from Part A (continuous 1-19)

### 1b. Lab 8

- [x] Update Materials to link `econ3500_lab_template.do` (not `labtemplate_f21.do`)
- [x] Add **Data context** section for `voucher.dta`
- [x] Add **Variables we'll use** table
- [x] Add **Workflow overview** section
- [x] Add **"What do I submit?"** section with submission checklist (including outreg2 table)
- [x] Add robust SE reminder
- [x] Add `{{% alert note %}}` hint boxes for tricky steps

---

## Phase 2: Knowledge gap scaffolding — DONE

### Lab 7

- [x] Added "What is panel data?" section explaining cross-sectional vs. panel data
- [x] Added "What is difference-in-differences?" intuition section
- [x] Scaffolded hand-drawn graph (Q3) with hint box about counterfactual line
- [x] Scaffolded manual DiD table (Q4) with `browse`/`list` hint
- [x] Added variable generation guidance (Q5) with `tab` + code example
- [x] Clarified in-regression `if` syntax (Q6) with example
- [x] Added hint for time-invariant controls (Q17)
- [x] Added variables table for both datasets (students know what's available)
- [x] Expanded `xtset`/`xtreg` + `cluster()` explanation in Key Commands
- [x] Added `codebook id` + `tab year` hint for data exploration (Q12)

### Lab 8

- [x] Added "Why instrumental variables?" intuition section connecting to Labs 6-7
- [x] Added instrument validity explanation (relevance + exclusion restriction)
- [x] Scaffolded first stage (Q5) with `testparm` reminder and F>10 rule of thumb
- [x] Scaffolded manual 2SLS (Q6) with `predict` syntax reminder
- [x] Added note about SE difference between manual 2SLS and `ivregress` (Q7 hint box)
- [x] Scaffolded multiple instruments syntax (Q9 hint box)
- [x] Added `ssc install outreg2` installation reminder (prominent alert box)
- [x] Added `outreg2` replace/append workflow hint (Q10)

---

## Phase 3: Typos and unclear sections — DONE

All typos fixed as part of the full rewrite:
- Template links updated to `econ3500_lab_template.do`
- `abosrb` → `absorb`, `becuase` → `because`
- "the each district" → "each district"
- "choosin" → "choosing"
- NLSY97 spelled correctly throughout
- Ligature characters (ﬁ, ﬀ) replaced
- Stray backtick in Lab 8 ivregress example removed
- "stata" → "Stata"
- Extra parenthesis removed
- Question cross-references updated for new numbering
- Q3 formatting broken into sub-bullets

---

## Phase 4: Solutions & Scripts — DONE

- [x] `Lab07-solutions.do` — OneDrive solutions folder
- [x] `Lab08-solutions.do` — OneDrive solutions folder
- [x] `ECON3500-Script-Lab07.md` — OneDrive lab scripts folder
- [x] `ECON3500-Script-Lab08.md` — OneDrive lab scripts folder

---

## Phase 5: Rebuild PDFs — TODO

- [ ] Regenerate `07-lab.pdf` from updated `.md`
- [ ] Regenerate `08-lab.pdf` from updated `.md`
- [ ] Spot-check formatting (alert boxes, tables, LaTeX equations)

---

## Phase 6: Final Review — TODO

- [ ] Read through revised Lab 7 start-to-finish as a student would
- [ ] Read through revised Lab 8 start-to-finish as a student would
- [ ] Confirm all variable names consistent throughout
- [ ] Confirm question numbering is sequential
- [ ] Run solution do-files against actual data to verify expected values
- [ ] Check `banks.dta` variable names match variables table (assumed `district`, `year`, `bib`)
- [ ] Check `nsly_marijuana.dta` variable names match variables table (assumed `id`, `year`, `income`, `marijuana`)

---

## File Locations

| File | Path |
|---|---|
| Lab 7 (website) | `/Users/ebeam/Dropbox/Github/econ3500.s26/content/assignment/07-lab.md` |
| Lab 8 (website) | `/Users/ebeam/Dropbox/Github/econ3500.s26/content/assignment/08-lab.md` |
| Lab 7 solutions | `/Users/ebeam/Library/CloudStorage/OneDrive-UniversityofVermont(2)/UVM-Teaching/UVM-EC200/ECON3500-Spring_2026/00_ECON3500_Shared/04_Assignments/01_Stata Labs/01_Solutions/Lab07-solutions.do` |
| Lab 8 solutions | `/Users/ebeam/Library/CloudStorage/OneDrive-UniversityofVermont(2)/UVM-Teaching/UVM-EC200/ECON3500-Spring_2026/00_ECON3500_Shared/04_Assignments/01_Stata Labs/01_Solutions/Lab08-solutions.do` |
| Lab 7 script | `/Users/ebeam/Library/CloudStorage/OneDrive-UniversityofVermont(2)/UVM-Teaching/UVM-EC200/ECON3500-Spring_2026/07_LabScripts/ECON3500-Script-Lab07.md` |
| Lab 8 script | `/Users/ebeam/Library/CloudStorage/OneDrive-UniversityofVermont(2)/UVM-Teaching/UVM-EC200/ECON3500-Spring_2026/07_LabScripts/ECON3500-Script-Lab08.md` |
| This plan | `/Users/ebeam/Dropbox/Github/econ3500.s26/07-08-lab-revision-plan.md` |

---

## Out of scope (flagged)

- **Lab 5** also links to old template — separate task
- **PDF rebuild** — depends on Hugo/LaTeX pipeline (Phase 5)
- **Video links** — Lab 7 has a commented-out video; Lab 8 has none
- **Data verification** — solution do-files have "check actual values" placeholders; need to run against actual data
