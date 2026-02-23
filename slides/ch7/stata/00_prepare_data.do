* =============================================================================
* ECON3500 Ch7: Data Preparation for GiveDirectly Kenya Analysis
* Prepares full analysis dataset and student working dataset
* =============================================================================
*
* This do-file:
*   1. Loads GE_HHLevel_ECMA.dta from replication materials
*   2. Checks key variables exist and are properly coded
*   3. Creates full analysis dataset (all households with complete data)
*   4. Creates student working dataset (random sample, simplified)
*
* Outputs:
*   - ge_ch7_analysis_data.dta (10,500+ households)
*   - ge_ch7_student_data.dta (1,000-1,500 households, 8 variables)
*
* =============================================================================

clear all
set more off
set seed 12345  // For reproducible student data sampling

* =============================================================================
* SETUP: Define paths
* =============================================================================

global replication_data "/Users/ebeam/Downloads/replication_materials/analysisdata"
global output_data "/Users/ebeam/Dropbox/GitHub/econ3500.s26/slides/ch7/stata"

di "Loading data from: $replication_data"
di "Output location: $output_data"

* =============================================================================
* LOAD SOURCE DATA
* =============================================================================

use "$replication_data/GE_HHLevel_ECMA.dta", clear
di "Loaded GE_HHLevel_ECMA.dta"
di "Sample size: " _N " households"

* =============================================================================
* VERIFY KEY VARIABLES EXIST
* =============================================================================

di ""
di "========================================="
di "VARIABLE VERIFICATION"
di "========================================="

* Check treatment variables
capture confirm variable eligible
if _rc == 0 {
	di "✓ eligible variable exists"
	summarize eligible
} 
else {
	di "✗ ERROR: eligible variable not found"
	exit 1
}

capture confirm variable treat
if _rc == 0 {
	di "✓ treat variable exists"
	summarize treat
} 
else {
	di "✗ ERROR: treat variable not found"
	exit 1
}

* Check main outcome
capture confirm variable p2_consumption_wins_PPP
if _rc == 0 {
	di "✓ p2_consumption_wins_PPP variable exists"
	summarize p2_consumption_wins_PPP
} 
else {
	di "✗ ERROR: consumption variable not found"
	exit 1
}

* Check demographic variables
foreach var in hhsize1_BL female_BL age_BL {
	capture confirm variable `var'
	if _rc == 0 {
		di "✓ `var' exists"
	} 
	else {
		di "✗ ERROR: `var' not found"
		exit 1
	}
}

* =============================================================================
* CREATE FULL ANALYSIS DATASET
* =============================================================================

di ""
di "========================================="
di "CREATING FULL ANALYSIS DATASET"
di "========================================="

* Keep only households with consumption data
keep if !missing(p2_consumption_wins_PPP)
di "After dropping missing consumption: " _N " households"

* Create ineligible indicator
gen ineligible = 1 - eligible
label var ineligible "Ineligible (opposite of eligible)"

* Rename/standardize outcome variable
gen consumption = p2_consumption_wins_PPP
label var consumption "Household consumption (PPP-adjusted, KES/month)"

* Rename demographic variables to standardized names
rename hhsize1_BL hh_size
rename female_BL female_head
rename age_BL age_head

* Rename identifiers
rename hhid_key household_id
rename village_code village_id

label var household_id "Household identifier"
label var village_id "Village identifier"

* Select and label key variables for analysis dataset
keep household_id village_id eligible ineligible treat consumption ///
     female_head hh_size age_head

label var eligible "=1 if eligible for direct transfer"
label var treat "=1 if village assigned to treatment"
label var female_head "=1 if household head is female"
label var hh_size "Household size (number of members)"
label var age_head "Age of household head (years)"

di "Full analysis dataset ready: " _N " households, " "`c(k)'" " variables"

* Summary statistics
di ""
di "Summary Statistics (Full Dataset):"
summarize consumption eligible ineligible treat female_head hh_size age_head

* Treatment balance check
di ""
di "Treatment Status Crosstab:"
tab eligible treat

* Save full analysis dataset
save "$output_data/ge_ch7_analysis_data.dta", replace
di "✓ Saved: ge_ch7_analysis_data.dta"

* =============================================================================
* CREATE STUDENT WORKING DATASET
* =============================================================================

di ""
di "========================================="
di "CREATING STUDENT WORKING DATASET"
di "========================================="

* Take stratified random sample (stratified by treatment status)
* Target: 1,200-1,500 observations (about 12-15% of full data)
gen stratum = eligible * 2 + treat  /* creates 4 groups: 0,1,2,3 */

* Sample ~350-375 from each stratum (4 strata × 350 ≈ 1,400)
bysort stratum: sample 13, count

local n_student = _N
di "Student sample size: `n_student' households"

* Rename for student clarity
gen hh_id = household_id
label var hh_id "Household ID"

* Keep only variables students need (8 core variables)
keep hh_id village_id eligible treat ineligible consumption female_head hh_size age_head

* Order for readability
order hh_id village_id eligible treat ineligible consumption female_head hh_size age_head

* Provide clear, simple labels
label var village_id "Village ID"
label var treat "Village treated (=1 if village receives cash)"
label var eligible "Eligible (=1 if household eligible for direct transfer)"
label var ineligible "Ineligible (=1 if not eligible, but in treated village)"
label var consumption "Consumption (KES, monthly estimate)"
label var female_head "Female head (=1 if head is female)"
label var hh_size "Household size"
label var age_head "Age of head (years)"

di ""
di "Summary Statistics (Student Dataset):"
summarize

* Save student dataset
save "$output_data/ge_ch7_student_data.dta", replace
di "✓ Saved: ge_ch7_student_data.dta"

* Final confirmation
di ""
di "========================================="
di "DATA PREPARATION COMPLETE"
di "========================================="
di "Full dataset: ge_ch7_analysis_data.dta (`_N' households)"
di "Student dataset: ge_ch7_student_data.dta (see above for N)"
di ""
di "Both files ready for analysis!"
di "========================================="
