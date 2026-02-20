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
*   (1) TYPE 1: Is there a direct effect? H₀: β_eligible = 0
*   (2) TYPE 2: Do spillovers equal direct effects? H₀: β_eligible = β_ineligible
*   (3) TYPE 3: Are all effects jointly zero? H₀: β_eligible = β_ineligible = β_treat = 0
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
* TYPE 1 HYPOTHESIS TEST
* =============================================================================
* Question: Is there a direct effect of eligibility on consumption?
* H₀: β_eligible = 0
* H_a: β_eligible ≠ 0
* =============================================================================

di ""
di "========================================="
di "TYPE 1 TEST: Direct Effect of Eligibility"
di "========================================="
di "H₀: β_eligible = 0"
di "H_a: β_eligible ≠ 0"
di ""

* Model 1A: Bivariate (no controls)
di "MODEL 1A: Direct Effect Without Controls"
di "Specification: consumption = β₀ + β_eligible + u"
di ""
regress consumption eligible, robust

est store model1a

* Extract key statistics for manual demonstration
local beta_1a = _b[eligible]
local se_1a = _se[eligible]
local t_1a = _b[eligible] / _se[eligible]
local p_1a = 2 * (1 - normal(abs(`t_1a')))

di ""
di "MANUAL CALCULATION:"
di "  β̂_eligible = " %7.2f `beta_1a'
di "  SE(β̂_eligible) = " %7.2f `se_1a'
di "  t-statistic = β̂ / SE = " %7.3f `beta_1a' " / " %7.3f `se_1a' " = " %7.3f `t_1a'
di "  p-value (two-sided) = 2×P(|t| > " %7.3f `t_1a' ") = " %7.4f `p_1a'
di ""

* 95% Confidence Interval
local ci_lower_1a = `beta_1a' - 1.96 * `se_1a'
local ci_upper_1a = `beta_1a' + 1.96 * `se_1a'

di "95% CONFIDENCE INTERVAL:"
di "  β̂_eligible ± 1.96 × SE"
di "  [" %7.2f `ci_lower_1a' ", " %7.2f `ci_upper_1a' "]"
di ""

* Model 1B: With demographic controls
di ""
di "MODEL 1B: Direct Effect WITH Controls"
di "Specification: consumption = β₀ + β_eligible + demographics + u"
di ""
regress consumption eligible female_head ln_hh_size age_head_decades, robust

est store model1b

local beta_1b = _b[eligible]
local se_1b = _se[eligible]

di ""
di "Comparison: Effect of eligible"
di "  Model 1A (no controls): " %7.2f `beta_1a' " (SE: " %7.2f `se_1a' ")"
di "  Model 1B (with controls): " %7.2f `beta_1b' " (SE: " %7.2f `se_1b' ")"
di ""
di "→ Did controlling for demographics change the effect?"
di "→ Why or why not?"
di ""

* =============================================================================
* TYPE 2 HYPOTHESIS TEST
* =============================================================================
* Question: Do spillovers equal direct effects?
* i.e., Do ineligible households benefit as much as eligible ones?
* H₀: β_eligible = β_ineligible
* =============================================================================

di ""
di "========================================="
di "TYPE 2 TEST: Equality of Direct & Spillover Effects"
di "========================================="
di "H₀: β_eligible = β_ineligible"
di "H_a: β_eligible ≠ β_ineligible"
di ""
di "Interpretation: Do ineligible households (in treated villages) benefit"
di "               as much as eligible households from the cash transfer?"
di ""

* Estimate both effects
di "MODEL 2: Estimate Both Effects"
di "Specification: consumption = β₀ + β_eligible + β_ineligible + demographics + u"
di ""
regress consumption eligible ineligible female_head ln_hh_size age_head_decades, robust

est store model2

local beta_elig = _b[eligible]
local se_elig = _se[eligible]
local beta_inelig = _b[ineligible]
local se_inelig = _se[ineligible]

di ""
di "POINT ESTIMATES:"
di "  β̂_eligible = " %7.2f `beta_elig' " (SE: " %7.2f `se_elig' ")"
di "  β̂_ineligible = " %7.2f `beta_inelig' " (SE: " %7.2f `se_inelig' ")"
di ""
di "Difference: " %7.2f (`beta_elig' - `beta_inelig')
di ""

* Test equality using Stata's test command
di ""
di "TYPE 2 TEST: Are they equal?"
di "Testing: H₀: eligible = ineligible"
di ""
test eligible = ineligible

local F_stat_t2 = r(F)
local p_val_t2 = r(p)

di ""
di "RESULT:"
di "  F-statistic: " %7.3f `F_stat_t2'
di "  p-value: " %7.4f `p_val_t2'
di ""

if `p_val_t2' < 0.05 {
	di "CONCLUSION: Reject H₀ at 5% level."
	di "  → Direct and spillover effects ARE significantly different"
}
else {
	di "CONCLUSION: Fail to reject H₀ at 5% level."
	di "  → No significant evidence that direct and spillover effects differ"
}
di ""

est store model2_test

* =============================================================================
* TYPE 3 HYPOTHESIS TEST: JOINT F-TEST
* =============================================================================
* Question: Are all treatment effects jointly zero?
* H₀: β_eligible = β_ineligible = β_treat = 0
* =============================================================================

di ""
di "========================================="
di "TYPE 3 TEST: Joint Significance F-test"
di "========================================="
di "H₀: β_eligible = β_ineligible = β_treat = 0"
di "H_a: At least one treatment effect ≠ 0"
di ""
di "Interpretation: Can we exclude all treatment variables from the model?"
di ""

* UNRESTRICTED MODEL (all treatment variables)
di "UNRESTRICTED MODEL: All treatment variables included"
di "Specification: consumption = β₀ + β_eligible + β_ineligible + β_treat +"
di "                            demographics + u"
di ""
regress consumption eligible ineligible treat female_head ln_hh_size ///
        age_head_decades, robust

est store model3_unres

* Capture statistics for manual calculation
qui regress consumption eligible ineligible treat female_head ln_hh_size ///
        age_head_decades, robust
local r2_unres = e(r2)
local N = e(N)
local K_unres = e(df_m)
local df_denom = e(df_r)

* RESTRICTED MODEL (treatment variables = 0, i.e., omitted)
di ""
di "RESTRICTED MODEL: Treatment variables omitted (set = 0)"
di "Specification: consumption = β₀ + demographics + u"
di ""
regress consumption female_head ln_hh_size age_head_decades, robust

est store model3_res

qui regress consumption female_head ln_hh_size age_head_decades, robust
local r2_res = e(r2)

* Manual F-test using R² formula
* F = [(R²_u - R²_r) / q] / [(1 - R²_u) / (N - k_u - 1)]
local q = 3  /* number of restrictions (eligible, ineligible, treat) */
local F_calc = ((`r2_unres' - `r2_res') / `q') / ((1 - `r2_unres') / (`N' - `K_unres' - 1))

di ""
di "MANUAL F-TEST CALCULATION (using R² formula):"
di "  R²_unrestricted = " %6.4f `r2_unres'
di "  R²_restricted = " %6.4f `r2_res'
di "  q (# restrictions) = " `q'
di "  N (sample size) = " `N'
di "  k_u (# regressors in unrestricted) = " `K_unres'
di ""
di "  F = [(R²_u - R²_r) / q] / [(1 - R²_u) / (N - k_u - 1)]"
di "    = [(" %6.4f `r2_unres' " - " %6.4f `r2_res' ") / " `q' "] / "
di "      [(1 - " %6.4f `r2_unres' ") / (" `N' " - " `K_unres' " - 1)]"
di "    = [" %6.4f (`r2_unres' - `r2_res')/`q' "] / [" %6.4f (1-`r2_unres')/`df_denom' "]"
di "    = " %7.3f `F_calc'
di ""

* Test jointly using testparm
di ""
di "STATA'S testparm COMMAND: Test joint significance"
qui regress consumption eligible ineligible treat female_head ln_hh_size ///
        age_head_decades, robust
testparm eligible ineligible treat

local F_stata = r(F)
local p_F = r(p)

di ""
di "RESULT:"
di "  F-statistic: " %7.3f `F_stata' " (manual calc: " %7.3f `F_calc' ")"
di "  p-value: " %7.4f `p_F'
di "  df1 = " r(df1) ", df2 = " r(df2)
di ""

if `p_F' < 0.05 {
	di "CONCLUSION: Reject H₀ at 5% level."
	di "  → At least one treatment effect is significantly different from zero"
	di "  → We CANNOT exclude all treatment variables"
}
else {
	di "CONCLUSION: Fail to reject H₀ at 5% level."
	di "  → No evidence that any treatment effect differs from zero"
	di "  → We COULD exclude all treatment variables"
}
di ""

est store model3_test

* =============================================================================
* COMPARISON: OVERALL F-TEST vs. RESTRICTED TYPE 3 TEST
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
di "TYPE 3 test, which tests ONLY the treatment variables."
di ""
di "Our test (testparm eligible ineligible treat) is more targeted."
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
di "TYPE 3 TEST: Homoskedastic (assume constant variance)"
di ""
qui regress consumption eligible ineligible treat female_head ln_hh_size ///
        age_head_decades

test eligible = ineligible = treat = 0

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

est table model1a model1b model2 model3_unres, ///
    b(%9.2f) se(%9.2f) ///
    title("Comparison of Models") ///
    keep(eligible ineligible treat)

di ""
di "Notes:"
di "  - Model 1A: Bivariate (no controls)"
di "  - Model 1B: With demographic controls"
di "  - Model 2: Both eligible and ineligible effects"
di "  - Model 3U: Unrestricted (all treatment variables)"
di ""

* =============================================================================
* INTERPRETATION & DISCUSSION
* =============================================================================

di ""
di "========================================="
di "INTERPRETATION & KEY INSIGHTS"
di "========================================="
di ""

di "1. DIRECT EFFECT (Type 1 test):"
if abs(`beta_1a') > 100 {
	di "   Cash transfers had a substantial positive effect on consumption."
}
else {
	di "   Cash transfer effects on consumption are modest in magnitude."
}
di ""

di "2. SPILLOVERS vs. DIRECT (Type 2 test):"
if abs(`beta_elig' - `beta_inelig') < 200 {
	di "   Eligible and ineligible households benefited similarly."
	di "   This suggests important general equilibrium (spillover) effects."
}
else {
	di "   Direct recipients benefited more than non-recipients."
	di "   Spillover effects are smaller than direct effects."
}
di ""

di "3. OVERALL SIGNIFICANCE (Type 3 test):"
if `p_F' < 0.05 {
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
