ECON 3500 Econometrics and Applications\
Spring 2026

# In-Class Activity: Fixed Effects Showdown

**Chapter 10 — Panel Data and Fixed Effects**\
Time: ~15-20 minutes

---

## Setup

A researcher wants to estimate the effect of beer taxes on traffic fatality rates. She has a balanced panel dataset of all 48 contiguous U.S. states observed annually from 2000 to 2009 (T = 10, N = 48, so 480 observations total).

The dependent variable is the **traffic fatality rate** (deaths per 10,000 people). The key independent variable is the **real beer tax** (dollars per case, adjusted for inflation). She also observes **per capita income** (in thousands of dollars).

She estimates four specifications. Study the output below carefully.

---

### Regression Output

| | **(1) Pooled OLS** | **(2) Entity FE** | **(3) Entity + Time FE** | **(4) First Difference** |
|---|---|---|---|---|
| **Beer Tax** | -0.655*** | -0.640** | -0.485* | -0.072 |
| | (0.188) | (0.254) | (0.261) | (0.117) |
| **Income** | 0.062*** | -0.063* | -0.071** | -0.018 |
| | (0.015) | (0.032) | (0.031) | (0.022) |
| State FE | No | Yes | Yes | -- |
| Year FE | No | No | Yes | -- |
| Differenced | No | No | No | Yes |
| SE type | Robust | Clustered (state) | Clustered (state) | Clustered (state) |
| N | 480 | 480 | 480 | 432 |
| R-squared | 0.091 | 0.905 | 0.918 | 0.003 |

Significance: \*\*\* p<0.01, \*\* p<0.05, \* p<0.1

---

## Questions

**1.** For each specification, briefly state what types of omitted variables it controls for and what it does *not* control for.

- **(1) Pooled OLS:**

\vspace{1.5cm}

- **(2) Entity FE:**

\vspace{1.5cm}

- **(3) Entity + Time FE:**

\vspace{1.5cm}

- **(4) First Difference:**

\vspace{1.5cm}

**2.** Look at the coefficient on **Income**. It flips sign between specification (1) and specification (2). Explain why this happens. What does this tell us about the pooled OLS estimate?

\vspace{3cm}

**3.** The coefficient on **Beer Tax** shrinks substantially from specification (1) to specification (4). Does this mean beer taxes have no effect on fatality rates? What should we conclude?

\vspace{3cm}

**4.** Why does specification (2) use clustered standard errors (clustered by state) rather than the heteroskedasticity-robust standard errors used in specification (1)? Give two reasons why clustering is appropriate for panel data.

\vspace{3cm}

**5.** Even with two-way fixed effects (specification 3), what threats to a causal interpretation remain? Identify at least two specific concerns.

\vspace{3cm}

---

\pagebreak

## INSTRUCTOR NOTES — DO NOT DISTRIBUTE

### Answers

**1.** What each specification controls for:

- **(1) Pooled OLS:** Controls for nothing beyond the included regressors (beer tax, income). Does not account for any unobserved differences across states or over time. Treats all 480 observations as independent cross-sectional data.

- **(2) Entity FE:** Controls for all time-invariant state characteristics (drinking culture, geography, road infrastructure, population density, state-level attitudes toward drunk driving, etc.). Does NOT control for factors that change over time and affect all states (national trends in vehicle safety, federal highway policy, changes in social norms around drunk driving).

- **(3) Entity + Time FE:** Controls for both time-invariant state characteristics AND common time trends that affect all states equally (national economic cycles, improvements in vehicle safety technology, federal policies, nationwide public health campaigns). Does NOT control for time-varying, state-specific factors (state-level policy changes other than beer tax, state-specific economic shocks).

- **(4) First Difference:** Like entity FE, removes time-invariant state characteristics by looking at year-over-year changes within each state. Conceptually similar to entity FE for T=2; for longer panels, FD and FE can differ. Does NOT control for common time trends (no year effects in this specification). Note N = 432 because first-differencing loses one year of data per state (48 states x 1 lost obs = 48 fewer observations: 480 - 48 = 432).

**2.** The sign flip on Income:

In pooled OLS, Income has a *positive* coefficient (+0.062): richer states appear to have higher fatality rates. But this is driven by omitted variable bias — states with higher income may also be larger, more rural, have more driving, etc. These time-invariant state characteristics are confounded with income in the pooled regression.

Once we add entity FE, we are looking at changes in income *within* a state over time. Within a given state, when income rises, fatality rates actually fall slightly (-0.063). This makes more sense: higher income within a state may lead to better vehicles, more safety investment, or less risky behavior.

The sign flip is strong evidence that pooled OLS suffers from omitted variable bias due to unobserved state characteristics.

**3.** The shrinking Beer Tax coefficient:

The decline from -0.655 to -0.072 does not automatically mean beer taxes have no effect. It means:

- Much of the pooled OLS association was driven by cross-state differences correlated with both beer taxes and fatality rates (OVB from time-invariant state characteristics)
- After controlling for state and year FE, the remaining within-state, within-year variation in beer taxes may be too small to precisely estimate the effect (note the standard errors relative to the point estimates)
- The first-difference estimate (-0.072) is small and imprecisely estimated, suggesting that year-to-year changes in beer taxes within a state are not strongly associated with year-to-year changes in fatality rates
- Possible interpretations: (a) the true causal effect is small, (b) there is not enough within-state variation in beer taxes to detect the effect, or (c) beer taxes change slowly and their effects may take more than one year to materialize

Students should recognize: the shrinking coefficient is actually the *point* of fixed effects — we are stripping away confounding variation to isolate the causal effect, which may be smaller than the biased OLS estimate.

**4.** Why clustered standard errors:

1. **Serial correlation (autocorrelation):** Within a state, fatality rates in year $t$ are likely correlated with fatality rates in year $t-1$. Observations within a state are not independent over time. Standard robust SEs assume independence across observations, which is violated.

2. **Within-cluster correlation of regressors:** Beer taxes are set at the state level and change infrequently. This means the treatment variable is highly correlated within clusters (states), creating a Moulton problem. Standard errors that ignore clustering will be artificially small, leading to over-rejection of the null.

Additional points to discuss: The clustering should be at the level of treatment variation (state). With N=48 clusters, we are in a reasonable range for cluster-robust inference, though small-cluster corrections (e.g., wild bootstrap) might be warranted.

**5.** Remaining threats even with two-way FE:

1. **Time-varying, state-specific confounders:** Other state policies that change at the same time as beer taxes (e.g., DUI enforcement, speed limits, seatbelt laws, Medicaid expansion affecting trauma care). Two-way FE only handles fixed state traits and common time shocks, not policies that vary across both states and time.

2. **Reverse causality:** States with rising fatality rates might respond by raising beer taxes. The policy change may be endogenous to the outcome.

3. **Measurement error:** Beer taxes may be a poor proxy for the actual price of alcohol (substitution to untaxed beverages, cross-border purchases, imprecise inflation adjustment).

4. **Spillovers / SUTVA violations:** A tax increase in one state may push drinking/driving to neighboring states (cross-border effects).

5. **Lagged effects:** Tax changes may not affect behavior immediately, but FE compares contemporaneous tax and fatality changes.

### Teaching Notes

- This scenario is adapted from the Stock & Watson textbook's running example of U.S. traffic fatalities (originally from Ruhm, 1996). Numbers are constructed for pedagogical clarity but reflect the realistic patterns.
- The R-squared jump from 0.091 (pooled) to 0.905 (entity FE) is a great discussion point — most of the variation in fatality rates is across states, not within states over time.
- The comparison of FE and FD estimates is worth highlighting: with T=10, FE is generally more efficient than FD (FE uses all within-state variation, FD only uses year-to-year changes), so the FD estimate is less precise.
- The income sign-flip is one of the most memorable examples of OVB in panel data — emphasize that this is *exactly* what FE is designed to fix.
