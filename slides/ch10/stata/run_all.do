* =============================================================================
* Ch10: Regression with Panel Data
* ECON3500 — Spring 2026
* =============================================================================

* =============================================================================
* Example 1: Difference-in-Differences — Housing Prices and Incinerator
* Data: Kiel and McClain (1995) housing price data
* =============================================================================

* If using KIELMC.dta, adjust path as needed:
* use "KIELMC.dta", clear

* --- After incinerator was built (1981) ---
* regress rprice nearinc if year == 1981

* --- Before incinerator was built (1978) ---
* regress rprice nearinc if year == 1978

* --- DiD regression ---
* gen after = (year == 1981)
* gen afterXnearinc = after * nearinc
* regress rprice after nearinc afterXnearinc, robust

* =============================================================================
* Example 2: Fixed Effects — Training Grants and Scrap Rates
* Data: JTRAIN.DTA (Holzer, Block, Cheatham, and Knott 1993)
* =============================================================================

* Update path to your local data location
use "JTRAIN.DTA", clear

keep if !missing(scrap)

set linesize 80

* --- Summarize key variables ---
summarize d88 d89 scrap grant sales

* =============================================================================
* Option 1: OLS with explicit dummy variables
* =============================================================================

* Pooled OLS (no fixed effects)
regress scrap grant, robust

* Add time dummies
regress scrap grant d88 d89, robust

* Add firm fixed effects as dummies
regress scrap grant d88 d89 i.fcode, robust

* =============================================================================
* Option 2: areg (absorb one set of fixed effects)
* =============================================================================

* With robust SEs
areg scrap grant d88 d89, robust absorb(fcode)

* With clustered SEs (preferred for panel data)
areg scrap grant d88 d89, cluster(fcode) absorb(fcode)

* =============================================================================
* Option 3: xtreg (recommended panel estimator)
* =============================================================================

* Declare panel structure
xtset fcode year

* Entity FE with robust SEs
xtreg scrap grant d88 d89, fe vce(robust)

* Entity FE with clustered SEs (preferred)
xtreg scrap grant d88 d89, fe vce(cluster fcode)
