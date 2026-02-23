* =============================================================================
* Ch7: Hypothesis Tests and Confidence Intervals in Multiple Regression
* ECON3500 — Spring 2026
* Data: Egger, Haushofer, Miguel, Niehaus, Walker (2022)
*       "General Equilibrium Effects of Cash Transfers: Experimental Evidence
*        from Kenya" (Econometrica 90(6):2603-2643)
* =============================================================================
*
* OVERVIEW:
* This do-file demonstrates three types of hypothesis tests in multiple
* regression using data from a randomized cash transfer study in Kenya.
*
* The study randomized villages to receive unconditional cash transfers
* (~$1,000 per household). Within treatment villages, some households were
* deemed "eligible" (poorer) and received transfers; others were "ineligible"
* but exposed to spillovers.
*
* We use this natural treatment structure to test:
*   (1) BASE: Overall ITT impact of treatment assignment (treat)
*   (2) DIRECT: Effect among eligible households (eligible == 1)
*   (3) INDIRECT: Effect among ineligible households (ineligible == 1)
*   (4) JOINT: Interaction model test of treatment effects
*
* Outcome: Household consumption (PPP-adjusted)
* Sample: 10,500+ households across 653 villages
*
* =============================================================================

clear all
set more off
set linesize 100
set maxvar 32767

* =============================================================================
* SETUP: Load data and define paths
* =============================================================================

* UPDATE PATH: Point to where data is saved
global datapath "/Users/ebeam/Dropbox/GitHub/econ3500.s26/slides/ch7/stata"

use "$datapath/ge_ch7_analysis_data.dta", clear

di ""
di "========================================="
di "ANALYSIS DATASET LOADED"
di "========================================="
di "Households: " _N
di "Variables: " "`c(k)'"
di ""

* =============================================================================
* DESCRIPTIVE STATISTICS
* =============================================================================

di "========================================="
di "DESCRIPTIVE STATISTICS"
di "========================================="
di ""

summarize consumption eligible ineligible treat female_head hh_size age_head

di ""
di "Treatment Assignment Crosstab:"
di "(Rows: eligible/ineligible | Columns: treat/control)"
tab eligible treat, matcell(mat_ct) matrow(rnames) matcol(cnames)

di ""
di "Mean Consumption by Treatment Group:"
bysort eligible treat: summarize consumption, detail

di ""

* =============================================================================
* DATA PREPARATION FOR ANALYSIS
* =============================================================================

* Create log household size (better scaling in regression)
gen ln_hh_size = ln(hh_size)
label var ln_hh_size "Log household size"

* Create age variable in decades (improves scaling)
gen age_head_decades = age_head / 10
label var age_head_decades "Age of head (decades)"

* =============================================================================
* BASE REGRESSION: OVERALL ITT (TREATMENT ASSIGNMENT)
* =============================================================================
* Question: What is the overall impact of being assigned to a treated village?
* H₀: β_treat = 0
* H_a: β_treat ≠ 0
* =============================================================================

di ""
di "========================================="
di "BASE REGRESSION: Overall ITT (treat)"
di "========================================="
di "H₀: β_treat = 0"
di "H_a: β_treat ≠ 0"
di ""

* Model 1A: Bivariate (no controls)
di "MODEL 1A: Overall ITT Without Controls"
di "Specification: consumption = β₀ + β_treat + u"
di ""
regress consumption treat, robust

est store model_base

* Extract key statistics for manual demonstration
local beta_base = _b[treat]
local se_base = _se[treat]
local t_base = _b[treat] / _se[treat]
local p_base = 2 * (1 - normal(abs(`t_base')))

di ""
di "MANUAL CALCULATION:"
di "  β̂_treat = " %7.2f `beta_base'
di "  SE(β̂_treat) = " %7.2f `se_base'
di "  t-statistic = β̂ / SE = " %7.3f `beta_base' " / " %7.3f `se_base' " = " %7.3f `t_base'
di "  p-value (two-sided) = 2×P(|t| > " %7.3f `t_base' ") = " %7.4f `p_base'
di ""

* 95% Confidence Interval
local ci_lower_base = `beta_base' - 1.96 * `se_base'
local ci_upper_base = `beta_base' + 1.96 * `se_base'

di "95% CONFIDENCE INTERVAL:"
di "  β̂_treat ± 1.96 × SE"
di "  [" %7.2f `ci_lower_base' ", " %7.2f `ci_upper_base' "]"
di ""

* Model 1B: With demographic controls
di ""
di "MODEL 1B: Overall ITT WITH Controls"
di "Specification: consumption = β₀ + β_treat + demographics + u"
di ""
regress consumption treat female_head ln_hh_size age_head_decades, robust

est store model_base_c

local beta_base_c = _b[treat]
local se_base_c = _se[treat]

di ""
di "Comparison: Effect of treat"
di "  Model 1A (no controls): " %7.2f `beta_base' " (SE: " %7.2f `se_base' ")"
di "  Model 1B (with controls): " %7.2f `beta_base_c' " (SE: " %7.2f `se_base_c' ")"
di ""
di "→ Did controlling for demographics change the effect?"
di "→ Why or why not?"
di ""

* =============================================================================
* DIRECT EFFECT: ELIGIBLE HOUSEHOLDS ONLY
* =============================================================================
* Question: Among eligible households, what is the effect of assignment to treat?
* H₀: β_treat|eligible = 0
* =============================================================================

di ""
di "========================================="
di "DIRECT EFFECT: Eligible Households Only"
di "========================================="
di "H₀: β_treat|eligible = 0"
di ""

regress consumption treat female_head ln_hh_size age_head_decades ///
        if eligible == 1, robust

est store model_direct

local beta_direct = _b[treat]
local se_direct = _se[treat]

di ""
di "POINT ESTIMATE (eligible only):"
di "  β̂_treat = " %7.2f `beta_direct' " (SE: " %7.2f `se_direct' ")"
di ""

* =============================================================================
* INDIRECT EFFECT: INELIGIBLE HOUSEHOLDS ONLY
* =============================================================================
* Question: Among ineligible households, what is the spillover effect?
* H₀: β_treat|ineligible = 0
* =============================================================================

di ""
di "========================================="
di "INDIRECT EFFECT: Ineligible Households Only"
di "========================================="
di "H₀: β_treat|ineligible = 0"
di ""

regress consumption treat female_head ln_hh_size age_head_decades ///
        if ineligible == 1, robust

est store model_indirect

local beta_indirect = _b[treat]
local se_indirect = _se[treat]

di ""
di "POINT ESTIMATE (ineligible only):"
di "  β̂_treat = " %7.2f `beta_indirect' " (SE: " %7.2f `se_indirect' ")"
di ""

* =============================================================================
* JOINT TEST VIA INTERACTION MODEL
* =============================================================================
* We model direct vs. indirect effects with an interaction:
*   consumption = β0 + β1*treat + β2*eligible + β3*(treat×eligible) + controls + u
* - Spillover (ineligible) effect = β1
* - Direct (eligible) effect = β1 + β3
* - Difference (direct - indirect) = β3
* =============================================================================

di ""
di "========================================="
di "JOINT TEST: Interaction Model"
di "========================================="
di ""

cap drop treatXeligible
gen treatXeligible = treat * eligible
label var treatXeligible "Treat × Eligible"

regress consumption treat eligible treatXeligible ///
        female_head ln_hh_size age_head_decades, robust

est store model_joint

local beta_treat = _b[treat]
local beta_inter = _b[treatXeligible]

di ""
di "INTERACTION MODEL EFFECTS:"
di "  Spillover (ineligible) effect = β̂_treat = " %7.2f `beta_treat'
di "  Direct (eligible) effect = β̂_treat + β̂_interaction"
lincom treat + treatXeligible
di ""

di "TEST 1: Direct = Indirect? (H₀: β_interaction = 0)"
test treatXeligible = 0
local p_diff = r(p)
di "  p-value: " %7.4f `p_diff'
di ""

di "TEST 2: Any treatment effect? (H₀: β_treat = β_interaction = 0)"
test treat treatXeligible
local p_joint = r(p)
di "  p-value: " %7.4f `p_joint'
di ""

* =============================================================================
* COMPARISON: OVERALL F-TEST vs. RESTRICTED JOINT TEST
* =============================================================================

di ""
di "========================================="
di "NOTE: Overall F-test"
di "========================================="
di ""
di "Every Stata regression output shows an 'F-test of overall significance'"
di "at the top. This tests: H₀: β_all = 0 (all regressors = 0)"
di ""
di "For the unrestricted model above, this tests whether ALL variables"
di "(both treatment and controls) matter. That is different from our"
di "JOINT test, which targets the treatment assignment effect(s)."
di ""
di "Our test (test treat treatXeligible) is more targeted."
di ""

* =============================================================================
* ROBUSTNESS: HOMOSKEDASTIC vs. ROBUST STANDARD ERRORS
* =============================================================================

di ""
di "========================================="
di "ROBUSTNESS: Homoskedastic vs. Robust SEs"
di "========================================="
di ""
di "All tests above use ROBUST standard errors (heteroskedasticity-robust)."
di "This is safest in practice. Here we compare to homoskedastic for illustration."
di ""

di ""
di "JOINT TEST: Homoskedastic (assume constant variance)"
di ""
qui regress consumption treat eligible treatXeligible female_head ln_hh_size ///
        age_head_decades

test treat = 0
test treatXeligible = 0
test treat treatXeligible

di ""
di "Notice: Homoskedastic F-statistic often differs from robust version."
di "When in doubt, use robust! (regress ..., robust)"
di ""

* =============================================================================
* SUMMARY TABLE: COEFFICIENT COMPARISON
* =============================================================================

di ""
di "========================================="
di "SUMMARY: Coefficient Estimates Across Models"
di "========================================="
di ""

est table model_base model_base_c model_direct model_indirect model_joint, ///
    b(%9.2f) se(%9.2f) ///
    title("Comparison of Models") ///
    keep(treat eligible treatXeligible)

di ""
di "Notes:"
di "  - Model 1A: Overall ITT (no controls)"
di "  - Model 1B: Overall ITT (with controls)"
di "  - Model 2: Direct effect (eligible only)"
di "  - Model 3: Indirect effect (ineligible only)"
di "  - Model 4: Interaction model (joint test)"
di ""

* =============================================================================
* INTERPRETATION & DISCUSSION
* =============================================================================

di ""
di "========================================="
di "INTERPRETATION & KEY INSIGHTS"
di "========================================="
di ""

di "1. OVERALL ITT (treat):"
if abs(`beta_base') > 100 {
	di "   Cash transfers had a substantial positive effect on consumption."
}
else {
	di "   Cash transfer effects on consumption are modest in magnitude."
}
di ""

di "2. DIRECT vs. INDIRECT:"
if abs(`beta_direct' - `beta_indirect') < 200 {
	di "   Eligible and ineligible households benefited similarly."
	di "   This suggests important spillover effects."
}
else {
	di "   Direct recipients benefited more than non-recipients."
	di "   Spillover effects are smaller than direct effects."
}
di ""

di "3. JOINT TEST OF TREATMENT EFFECTS:"
if `p_joint' < 0.05 {
	di "   Treatment effects are statistically significant."
	di "   The cash transfer program mattered for household consumption."
}
else {
	di "   Treatment effects are not statistically significant."
	di "   We cannot conclude the program changed consumption."
}
di ""

di "========================================="
di "END OF ANALYSIS"
di "========================================="
