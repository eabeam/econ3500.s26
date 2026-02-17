* =============================================================================
* Ch7: Hypothesis Tests and Confidence Intervals in Multiple Regression
* ECON3500 — Spring 2026
* Data: STAR experiment (Angrist, Lang, and Oreopoulos 2009)
* =============================================================================

* --- Setup -------------------------------------------------------------------
* Update the path below to match your local data location
use "STARdatapost/STAR_public_use.dta", clear

* Keep only students who showed up
keep if noshow == 0

* Restrict to sample with Year 1 GPA
replace GPA_year1 = . if grade_20059_fall == .
replace grade_20059_fall = . if GPA_year1 == .

* --- Generate variables ------------------------------------------------------
assert sex != ""
assert mtongue != ""
assert hsgroup != .

gen female = (sex == "Female")
gen mt_english = (mtongue == "English")
gen mt_french  = (mtongue == "French")
gen mt_other   = (mtongue == "Other")
gen hs_q2 = (hsgroup == 2)
gen hs_q3 = (hsgroup == 3)

set linesize 80

* =============================================================================
* 1. Base regression (homoskedastic, English excluded)
* =============================================================================
regress GPA_year1 female mt_french mt_other hs_q2 hs_q3

* =============================================================================
* 2. Alternative excluded group (Other excluded)
* =============================================================================
regress GPA_year1 female mt_english mt_french hs_q2 hs_q3

* =============================================================================
* 3. Type 2 test: equality of two coefficients
*    H0: beta_french = beta_other
* =============================================================================
quietly regress GPA_year1 female mt_french mt_other hs_q2 hs_q3
test mt_french = mt_other

* =============================================================================
* 4. Type 3 test: joint significance (homoskedastic)
*    H0: beta_french = beta_other = 0
* =============================================================================
* Unrestricted model
quietly regress GPA_year1 female mt_french mt_other hs_q2 hs_q3
test mt_french = mt_other = 0
testparm mt_french mt_other

* Restricted model (for comparison of SSR)
regress GPA_year1 female hs_q2 hs_q3

* =============================================================================
* 5. Overall significance test
*    H0: all betas = 0
* =============================================================================
quietly regress GPA_year1 female mt_french mt_other hs_q2 hs_q3
testparm *

* =============================================================================
* 6. Robust standard errors versions
* =============================================================================
regress GPA_year1 female mt_french mt_other hs_q2 hs_q3, robust
test mt_french = mt_other = 0
testparm mt_french mt_other
