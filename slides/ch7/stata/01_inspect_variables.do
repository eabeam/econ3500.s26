* =============================================================================
* INSPECT VARIABLES IN GE_HHLevel_ECMA.dta
* Create a log file summarizing all available variables
* =============================================================================

clear all
cap log close
global replication_data "/Users/ebeam/Downloads/replication_materials/analysisdata"
log using "$replication_data/log_ecma.log",replace
use "$replication_data/GE_HHLevel_ECMA.dta", clear

di ""
di "========================================="
di "DATASET INSPECTION"
di "========================================="
di ""
di "File: GE_HHLevel_ECMA.dta"
di "Observations: " _N
di "Variables: " c(k)
di ""

di "========================================="
di "VARIABLE LIST WITH DETAILS"
di "========================================="
di ""

describe, simple

di ""
di "========================================="
di "DETAILED VARIABLE INFORMATION"
di "========================================="
di ""

describe

di ""
di "========================================="
di "KEY VARIABLES FOR ANALYSIS"
di "========================================="
di ""

* Look for treatment variables
di "SEARCHING FOR TREATMENT VARIABLES:"
describe eligible treat, detail

* Look for outcome variables
di ""
di "SEARCHING FOR CONSUMPTION/OUTCOME VARIABLES:"
ds *consumption* *income* *expenditure*, has(type numeric)

* Look for demographic variables
di ""
di "SEARCHING FOR DEMOGRAPHIC VARIABLES:"
ds *female*  *size* *age*, has(type numeric)

* Look for identifiers
di ""
di "SEARCHING FOR IDENTIFIERS:"
ds *id *code*, has(type numeric)

di ""
di "========================================="
di "SUMMARY STATISTICS FOR KEY VARIABLES"
di "========================================="
di ""

capture summarize eligible
capture summarize treat
capture summarize p2_consumption_wins_PPP
capture summarize hh_size
capture summarize hh_head_female
capture summarize age_head
