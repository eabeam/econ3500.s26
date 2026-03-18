* =============================================================================
* twfe_verify.do
* Staggered-adoption DiD example — ECON3500 Chapter 10 slides
*
* Purpose: Verify that TWFE gives β = -10 in the ch10 slide example,
*          even though all true treatment effects are positive.
*
* Setup:
*   State E (early adopter): treated starting 2019
*   State L (late adopter):  treated starting 2020
*   No never-treated group
*   Baseline (counterfactual) trend: +5/year for both states
*   True treatment effects: +10 in year 1, +50 in year 2 post-adoption
* =============================================================================

clear

* ------------------------------------------------------------------------------
* 1. Build the dataset
* ------------------------------------------------------------------------------

input str1 state int year int y int d
"E" 2018 100 0   // E, pre-treatment
"E" 2019 115 1   // E, year 1 post: baseline=105, effect=+10 → 115
"E" 2020 160 1   // E, year 2 post: baseline=110, effect=+50 → 160
"L" 2018 100 0   // L, pre-treatment
"L" 2019 105 0   // L, pre-treatment (baseline trend only)
"L" 2020 120 1   // L, year 1 post: baseline=110, effect=+10 → 120
end

encode state, gen(sid)
label variable d "Treatment indicator"
label variable y "Outcome"

xtset sid year

* ------------------------------------------------------------------------------
* 2. Manual 2x2 DiD comparisons (following Goodman-Bacon 2021)
* ------------------------------------------------------------------------------

di as txt _n "{hline 65}"
di as txt "MANUAL 2x2 DiD COMPARISONS"
di as txt "{hline 65}"

di as txt _n "Comparison 1 (VALID): E treated vs. L as untreated control"
di as txt "  Window: 2018 → 2019"
di as txt "  (Y_E,2019 - Y_E,2018) - (Y_L,2019 - Y_L,2018)"
di as res "  = (115 - 100) - (105 - 100) = 15 - 5 = " %3.0f (115-100)-(105-100)

di as txt _n "Comparison 2 (CONTAMINATED): L treated vs. E already-treated as 'control'"
di as txt "  Window: 2019 → 2020"
di as txt "  (Y_L,2020 - Y_L,2019) - (Y_E,2020 - Y_E,2019)"
di as res "  = (120 - 105) - (160 - 115) = 15 - 45 = " %3.0f (120-105)-(160-115)

di as txt _n "TWFE = weighted avg (equal weights with 1 unit per group):"
di as res "  0.5 * (+10) + 0.5 * (-30) = " %3.0f 0.5*10 + 0.5*(-30)

* ------------------------------------------------------------------------------
* 3. Full TWFE regression (entity + year FE)
* ------------------------------------------------------------------------------

di as txt _n "{hline 65}"
di as txt "TWFE REGRESSION (xtreg, fe with year dummies)"
di as txt "{hline 65}"

xtreg y d i.year, fe

di as txt _n "=> Coefficient on d = -10"
di as txt "   All true treatment effects are POSITIVE (+10 or +50)."
di as txt "   TWFE gives the WRONG sign."

* ------------------------------------------------------------------------------
* 4. Verify via manual within-estimation (optional)
* ------------------------------------------------------------------------------
* The within estimator time-demeans both Y and D:
*   beta = sum(D_tilde * Y_tilde) / sum(D_tilde^2)
*
* Entity means: Y_E = 125, Y_L = 108.33; D_E = 2/3, D_L = 1/3
* Time means:   Y_2018=100, Y_2019=110, Y_2020=140; D_2018=0, D_2019=0.5, D_2020=1
* Grand means:  Y = 116.67, D = 0.5
*
* D̃ values:
*   E,2018: 0 - 2/3 - 0   + 1/2 = -1/6
*   E,2019: 1 - 2/3 - 1/2 + 1/2 = +1/3
*   E,2020: 1 - 2/3 - 1   + 1/2 = -1/6
*   L,2018: 0 - 1/3 - 0   + 1/2 = +1/6
*   L,2019: 0 - 1/3 - 1/2 + 1/2 = -1/3
*   L,2020: 1 - 1/3 - 1   + 1/2 = +1/6
*
* Numerator = (-1/6)(-25/3) + (1/3)(-10/3) + (-1/6)(35/3)
*           + (1/6)(25/3)  + (-1/3)(10/3)  + (1/6)(-35/3)
*           = 25/18 - 10/9 - 35/18 + 25/18 - 10/9 - 35/18
*           = -10/9
* Denominator = 4*(1/36) + 2*(1/9) = 4/36 + 8/36 = 1/3
*
* beta = (-10/9) / (1/3) = -10/3 * 3/1 ...
*
* Exact: numerator = sum of D̃·Ỹ
*   = (-1/6)(-8.333) + (1/3)(-3.333) + (-1/6)(11.667)
*   + (1/6)(8.333)   + (-1/3)(3.333) + (1/6)(-11.667)
*   = 1.389 - 1.111 - 1.944 + 1.389 - 1.111 - 1.944
*   = -3.333  (= -10/3)
* Denominator = 1/3
* beta = (-10/3) / (1/3) = -10  ✓
