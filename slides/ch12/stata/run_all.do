* =============================================================================
* Ch12: Instrumental Variables
* ECON3500 — Spring 2026
* =============================================================================

* Update path to your local data location
* Data: cigarette sales panel (48 states, 1985 & 1995)
* use "cig_ch12.dta", clear

set linesize 80

* =============================================================================
* Cross-Sectional IV: Cigarette Demand (1995 only)
* =============================================================================

* --- OLS (biased by simultaneous causality) ---
regress packpc avgprs, robust

* --- Simple 2SLS: instrument price with sales tax ---
ivregress 2sls packpc (avgprs=tax), robust

* --- Show first stage ---
ivregress 2sls packpc (avgprs=tax), robust first

* --- Manual two-stage (for illustration only) ---
* Stage 1: regress X on Z
regress avgprs tax, robust
predict avgprs_predict

* Stage 2: regress Y on predicted X
regress packpc avgprs_predict, robust
* NOTE: Point estimates match ivregress, but SEs are WRONG
* Always use ivregress in practice

* =============================================================================
* 2SLS with Exogenous Controls
* =============================================================================

* Add income per person as exogenous control
ivregress 2sls packpc (avgprs=tax) incomepop, robust first

* =============================================================================
* Panel Data: Fixed Effects + IV
* =============================================================================

* --- Set up panel structure ---
egen stateID = group(state)
xtset stateID year, yearly

* --- Step 1: State FE only (no instruments) ---
xtreg packpc avgprs incomepop, vce(cluster state) fe

* --- Step 2: State + Year FE (no instruments) ---
xtreg packpc avgprs incomepop i.year, vce(cluster state) fe

* --- Step 3: State + Year FE with IV ---
* Instrument price with cigarette-specific sales tax
xtivreg packpc (avgprs = taxs) incomepop y1995, vce(cluster state) fe first

* =============================================================================
* Logarithmic Specification (Elasticities)
* =============================================================================

* Generate log variables (if not already in data)
* gen lpackpc = log(packpc)
* gen lavgprs = log(avgprs)
* gen lincomepop = log(incomepop)
* gen ltaxs = log(taxs)

xtivreg lpackpc (lavgprs = ltaxs) lincomepop y1995, vce(cluster state) fe
