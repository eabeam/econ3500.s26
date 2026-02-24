* =============================================================================
* Ch7: Hypothesis Tests in Multiple Regression — STUDENT WORKING VERSION
* ECON3500 — Spring 2026
* Data: GiveDirectly Kenya Cash Transfer Study
* =============================================================================
*
* OVERVIEW:
* In this exercise, you will test three types of hypotheses about the effects
* of cash transfers on household consumption in Kenya.
*
* STUDY DESIGN:
* - Villages were randomly selected to receive ~$1,000 cash transfers
* - Within treatment villages:
*     • ELIGIBLE households (poorer): received transfers
*     • INELIGIBLE households (less poor): did NOT receive transfers
*       but lived in same villages → exposed to spillovers
* - CONTROL villages: no transfers
*
* VARIABLES IN THIS DATASET:
*   hh_id:         Unique household identifier
*   village_id:    Village code (tells you which village the household is in)
*   eligible:      =1 if household is ELIGIBLE (poorer, eligible for transfer)
*   treat:         =1 if household is in a TREATED VILLAGE
*   ineligible:    =1 if NOT eligible (opposite of eligible)
*   consumption:   Household consumption, measured in KES (Kenya shillings)
*   female_head:   =1 if household head is female
*   hh_size:       Number of people in household
*   age_head:      Age of household head (years)
*
* YOUR TASK:
* Run regressions to test whether the cash transfer affected consumption.
* Specifically:
*   (1) Was there a DIRECT effect? (did eligible households benefit?)
*   (2) Did SPILLOVERS occur? (did ineligible households benefit?)
*   (3) Were effects JOINTLY SIGNIFICANT?
*
* =============================================================================

clear all
set more off

* UPDATE THIS PATH to match your computer
global datapath "/Users/ebeam/Dropbox/GitHub/econ3500.s26/slides/ch7/stata"

* Load student dataset
use "$datapath/ge_ch7_student_data.dta", clear

di ""
di "========================================="
di "GiveDirectly Kenya Data — Student Exercise"
di "========================================="
di ""
di "Sample loaded. You have " _N " households."
di ""

* =============================================================================
* PART 1: EXPLORE THE DATA
* =============================================================================

di "PART 1: EXPLORE THE DATA"
di "========================================="
di ""

* Question 1a: How many households are in treatment vs. control villages?
di "(1a) Treatment Status:"
tab treat

di ""
di "(1b) Eligibility Status:"
tab eligible

di ""
di "(1c) Crosstab: Treatment × Eligibility"
tab eligible treat

di ""
di "(1d) Mean consumption by group:"
bysort treat eligible: summarize consumption

di ""

* =============================================================================
* PART 2: TYPE 1 TEST — Direct Effect
* =============================================================================

di ""
di "PART 2: TYPE 1 HYPOTHESIS TEST"
di "========================================="
di ""
di "Research Question:"
di "  Did eligible households benefit from the cash transfer?"
di ""
di "Hypothesis:"
di "  H₀: β_eligible = 0  (no direct effect)"
di "  H_a: β_eligible ≠ 0  (there IS an effect)"
di ""
di "Regression Model:"
di "  consumption = β₀ + β_eligible + u"
di ""

* FILL IN THE BLANK: Write the regression command below
* Hint: regress outcome_var treatment_var, robust
* Replace the ... with the actual command

di "Your task: Run the regression"
di ""

regress consumption eligible, robust

* ANSWER THESE QUESTIONS:
* (Q1) What is the point estimate of β_eligible? _______________
* (Q2) What is the standard error? _________________
* (Q3) What is the t-statistic? (β / SE) _________________
* (Q4) What is the p-value? _________________
* (Q5) Do you reject H₀ at the 5% level? (p < 0.05?) YES / NO

di ""
di "Write your answers above (Q1-Q5)"
di ""

* Now add demographic controls
di ""
di "Now let's control for demographics:"
di ""
di "  consumption = β₀ + β_eligible + β_female + β_hhsize + β_age + u"
di ""

regress consumption eligible female_head hh_size age_head, robust

* (Q6) Did the coefficient on eligible change? ________________
* (Q7) If yes, why might that be? ___________________________

* Store this model for later comparison
est store model_type1

di ""
di "When you're ready, move to PART 3"
di ""

* =============================================================================
* PART 3: TYPE 2 TEST — Equality of Effects
* =============================================================================

di ""
di "PART 3: TYPE 2 HYPOTHESIS TEST"
di "========================================="
di ""
di "Research Question:"
di "  Do ineligible households benefit as much as eligible ones?"
di "  (i.e., are spillovers as large as direct effects?)"
di ""
di "Hypothesis:"
di "  H₀: β_eligible = β_ineligible  (effects are equal)"
di "  H_a: β_eligible ≠ β_ineligible  (effects differ)"
di ""

* First, create the ineligible dummy
di "Creating the ineligible variable..."
gen ineligible = 1 - eligible
label var ineligible "Ineligible"

* Check it worked
tab ineligible eligible

di ""
di "Now estimate BOTH effects in one regression:"
di "  consumption = β₀ + β_eligible + β_ineligible + demographics + u"
di ""

regress consumption eligible ineligible female_head hh_size age_head, robust

* (Q8) What is β̂_eligible? _______________
* (Q9) What is β̂_ineligible? _______________
* (Q10) Which is bigger? _______________

* Now test if they are EQUAL
di ""
di "Testing if β_eligible = β_ineligible..."
di ""

test eligible = ineligible

* (Q11) What is the F-statistic? _____________
* (Q12) What is the p-value? _____________
* (Q13) Do you reject H₀ at the 5% level? YES / NO

di ""
di "Interpretation:"
di "If you REJECTED H₀:"
di "  → Direct effects ≠ Spillover effects"
di "  → One group benefited more than the other"
di ""
di "If you FAILED TO REJECT H₀:"
di "  → No evidence of different effects"
di "  → Direct effects ≈ Spillover effects"
di ""

est store model_type2

di "When you're ready, move to PART 4"
di ""

* =============================================================================
* PART 4: TYPE 3 TEST — Joint Significance F-test
* =============================================================================

di ""
di "PART 4: TYPE 3 HYPOTHESIS TEST (F-TEST)"
di "========================================="
di ""
di "Research Question:"
di "  Overall, did the treatment program matter at all?"
di ""
di "Hypothesis:"
di "  H₀: β_eligible = β_ineligible = β_treat = 0"
di "      (ALL treatment effects are zero)"
di "  H_a: At least one treatment effect ≠ 0"
di ""

di "Model: consumption = β₀ + β_eligible + β_ineligible + β_treat +"
di "                     demographics + u"
di ""

regress consumption eligible ineligible treat female_head hh_size age_head, robust

* (Q14) Scan the output. Which variables have p < 0.05? _______________

di ""
di "Now test JOINT significance (all three treatment effects together):"
di ""

testparm eligible ineligible treat

* (Q15) What is the F-statistic? _____________
* (Q16) What is the p-value? _____________
* (Q17) Do you reject H₀ at the 5% level? YES / NO

di ""
di "Interpretation:"
di "If you REJECTED H₀:"
di "  → At least one treatment effect matters"
di "  → The cash transfer program HAD EFFECTS"
di ""
di "If you FAILED TO REJECT H₀:"
di "  → No evidence that treatment matters"
di "  → The cash transfer program had NO detectable effect"
di ""

est store model_type3

* =============================================================================
* BONUS: COMPARE MODELS
* =============================================================================

di ""
di "BONUS: Comparison of All Models"
di "========================================="
di ""
di "How did the coefficient on 'eligible' change across models?"
di ""

est table model_type1 model_type2 model_type3, ///
    b(%9.2f) se(%9.2f) ///
    keep(eligible)

di ""
di "(Q18) Did the effect of eligible grow, shrink, or stay similar?"
di "      ___________________________________________________"
di ""

di ""
di "========================================="
di "CONGRATULATIONS! You've completed the exercise."
di "========================================="
di ""
di "Key Takeaways:"
di "  ✓ Type 1: Test single coefficient (t-test)"
di "  ✓ Type 2: Test equality of two coefficients (t-test or F-test)"
di "  ✓ Type 3: Test joint significance of multiple restrictions (F-test)"
di ""
di "Next: Compare your answers to the ANSWER KEY"
di "(ge_ch7_analysis.do has the full analysis)"
di ""
