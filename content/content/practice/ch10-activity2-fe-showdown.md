ECON 3500 Econometrics and Applications\
Spring 2026

# In-Class Activity: Fixed Effects Showdown

**Chapter 10 — Panel Data and Fixed Effects**\
Time: ~20-25 minutes

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

**1b.** What is one specific example of a *time shock* in this context — something that would affect all states' fatality rates in a given year equally? How does adding year fixed effects in specification (3) address it?

\vspace{2.5cm}

**2.** Look at the coefficient on **Income**. It flips sign between specification (1) and specification (2). Explain why this happens. What does this tell us about the pooled OLS estimate?

\vspace{3cm}

**3.** The coefficient on **Beer Tax** shrinks substantially from specification (1) to specification (4). Does this mean beer taxes have no effect on fatality rates? What should we conclude?

\vspace{3cm}

**4.** Why does specification (2) use clustered standard errors (clustered by state) rather than the heteroskedasticity-robust standard errors used in specification (1)?

(a) Which panel data least squares assumption is being addressed by clustering?

\vspace{1.5cm}

(b) What goes wrong with standard (unclustered) SEs when that assumption is violated?

\vspace{1.5cm}

**5.** Even with two-way fixed effects (specification 3), what threats to a causal interpretation remain? Identify at least two specific concerns.

\vspace{3cm}

**6. (Optional/Discussion)** Suppose states adopted beer tax increases at different times — some in 2002, some in 2005, some in 2008. A researcher uses the two-way FE approach from specification (3) with a single indicator $treated_{it} = 1$ after the state's tax increase. Why might this estimate be misleading, even if two-way FE was appropriate in specification (3)?

\vspace{3cm}

---

\pagebreak

## INSTRUCTOR NOTES — DO NOT DISTRIBUTE

### Answers

**1.** What each specification controls for:

- **(1) Pooled OLS:** Controls for nothing beyond the included regressors (beer tax, income). Does not account for any unobserved differences across states or over time. Treats all 480 observations as independent cross-sectional data.

- **(2) Entity FE:** Controls for all time-invariant state characteristics (drinking culture, geography, road infrastructure, population density, state-level attitudes toward drunk driving). Does NOT control for factors that change over time and affect all states (national trends in vehicle safety, federal highway policy, changes in social norms around drunk driving).

- **(3) Entity + Time FE:** Controls for both time-invariant state characteristics AND common time trends that affect all states equally (national economic cycles, improvements in vehicle safety technology, federal policies, nationwide public health campaigns). Does NOT control for time-varying, state-specific factors (state-level policy changes other than beer tax, state-specific economic shocks).

- **(4) First Difference:** Like entity FE, removes time-invariant state characteristics by looking at year-over-year changes within each state. Does NOT control for common time trends. Note N = 432 because first-differencing loses one year per state (480 − 48 = 432).

**1b.** Example: the 2008 financial crisis reduced driving, which could lower fatality rates in every state. Or: improvements in airbag/safety technology affecting all cars nationally in a given year. Year fixed effects address this by giving each year its own intercept — the common level in year $t$ is partialled out for all states, leaving only within-year, across-state variation in fatalities and beer taxes. Without year FEs, a national decline in fatalities would be partially attributed to beer taxes if beer taxes happened to be higher in that period.

**2.** The sign flip on Income:

In pooled OLS, Income has a *positive* coefficient (+0.062): richer states appear to have higher fatality rates. This is driven by omitted variable bias — states with higher income may also be larger, more rural, have more driving, etc. These time-invariant state characteristics are confounded with income in pooled regression.

Once we add entity FE, we are looking at changes in income *within* a state over time. Within a given state, when income rises, fatality rates fall slightly (−0.063). Higher within-state income may lead to better vehicles, more safety investment, or less risky behavior.

The sign flip is strong evidence that pooled OLS suffers from OVB due to unobserved state characteristics.

**3.** The shrinking Beer Tax coefficient:

The decline from −0.655 to −0.072 does not mean beer taxes have no effect. It means:

- Much of the pooled OLS association was driven by cross-state differences correlated with both beer taxes and fatality rates (time-invariant OVB)
- After controlling for state and year FE, the remaining within-state, within-year variation in beer taxes may be too small to precisely estimate the effect
- The FD estimate is small and imprecisely estimated, suggesting year-to-year changes in beer taxes are not strongly associated with year-to-year changes in fatality rates
- Possible interpretations: (a) the true causal effect is small, (b) not enough within-state variation in beer taxes to detect it, or (c) effects may materialize with a lag

**Key teaching point:** The shrinking coefficient is the *point* of fixed effects — we strip away confounding variation to isolate the causal estimate, which may be smaller than the biased OLS estimate.

**4.** Why clustered standard errors:

(a) **Assumption 2** requires observations to be i.i.d. draws *across entities*. The assumption only requires independence across entities, not within. However, standard OLS/robust SEs assume errors are independent across *all* observations. Within a state, fatality rates in year $t$ are correlated with year $t-1$ (serial correlation). Clustering at the state level allows arbitrary within-state, within-cluster correlation — correcting for this autocorrelation in the error term.

(b) With positive serial correlation (typical in panel data), unclustered SEs are usually **too small**. This means confidence intervals are too narrow and $t$-statistics are too large → we over-reject the null (false positives). The point estimates are still consistent — only inference is wrong. Note: in some designs with negative within-cluster correlation, clustered SEs can be larger than unclustered, but this is less common.

**5.** Remaining threats even with two-way FE:

1. **Time-varying, state-specific confounders:** Other state policies changing at the same time as beer taxes (DUI enforcement, speed limits, seatbelt laws). Two-way FE only handles fixed state traits and common time shocks — not policies varying across both states and time.

2. **Reverse causality:** States with rising fatality rates might respond by raising beer taxes. The policy change may be endogenous to the outcome.

3. **Measurement error:** Beer taxes are a poor proxy for the actual price of alcohol (substitution to untaxed beverages, cross-border purchases).

4. **Spillovers:** A tax increase in one state may push drinking across state lines (SUTVA violation).

5. **Lagged effects:** Tax changes may not affect behavior immediately; contemporaneous comparison may miss the effect.

**6.** With staggered adoption, TWFE implicitly uses *already-treated* states as "controls" for later-adopting states. If treatment effects change over time (dynamic effects), the already-treated state's continuing effect looks like a "trend" — contaminating the comparison. TWFE is a weighted average of all possible 2×2 DiD comparisons, and when treatment effects are heterogeneous, some comparisons receive *negative* weights, potentially flipping the sign of the aggregate estimate even when all individual true effects are positive. Modern estimators (Callaway-Sant'Anna, Sun-Abraham) avoid this by only using not-yet-treated or never-treated units as controls.

### Teaching Notes

- This scenario is adapted from the Stock & Watson textbook's running example of U.S. traffic fatalities (originally from Ruhm, 1996). Numbers are constructed for pedagogical clarity.
- The R² jump from 0.091 (pooled) to 0.905 (entity FE) is a great discussion point — most variation in fatality rates is *between* states, not *within* states over time.
- The income sign-flip is one of the most memorable examples of OVB in panel data — exactly what FE is designed to fix.
- For Q4, connect explicitly to the "Problem of Serial Correlation" slide: stress that coefficients are still consistent, but inference (SEs, CIs, p-values) is wrong without clustering.
- Q6 is optional — use if students are comfortable with basic DiD. It connects to the staggered adoption section of Tuesday's slides.
