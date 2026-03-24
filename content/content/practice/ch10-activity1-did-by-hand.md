ECON 3500 Econometrics and Applications\
Spring 2026

# In-Class Activity: DiD by Hand

**Chapter 10 — Difference-in-Differences**\
Time: ~15-20 minutes

---

## Setup

In January 2020, New Jersey increased its state minimum wage from $10.00 to $12.00 per hour. Neighboring Pennsylvania kept its minimum wage at $7.25. A researcher collected data on average employment at fast-food restaurants (measured as full-time equivalent workers per restaurant) in both states, before and after the policy change.

|                    | **Before** (Nov 2019) | **After** (Mar 2020) |
|--------------------|-----------------------|----------------------|
| **New Jersey** (treatment)  | 20.4                  | 21.0                 |
| **Pennsylvania** (control) | 23.3                  | 21.2                 |

---

## Questions

**1.** Calculate the simple before-and-after change in employment for New Jersey (the treatment group).

\vspace{1.5cm}

**2.** A state legislator sees your answer to Question 1 and says, "See! Raising the minimum wage *increased* employment!" Explain why the simple before-after comparison is not a valid estimate of the causal effect of the minimum wage increase.

\vspace{2.5cm}

**3.** Calculate the difference-in-differences (DiD) estimate of the effect of the minimum wage increase on fast-food employment.

*Show your work. You can calculate this either as (a) the difference in before-after changes between the two groups, or (b) the difference in cross-state gaps between the two time periods.*

\vspace{3cm}

**4.** Interpret your DiD estimate from Question 3 in a complete sentence. Be specific about units and direction.

\vspace{2cm}

**5.** State the parallel trends assumption in the context of this study. Be precise — what, specifically, must be true for the DiD estimate to be valid?

\vspace{2.5cm}

**6.** Evaluate whether parallel trends is plausible here. Identify at least one reason it might hold and one reason it might fail.

\vspace{2.5cm}

**7. (Bonus)** Write the regression equation that would produce the DiD estimate from Question 3. Define your variables clearly and identify which coefficient gives the DiD estimate.

\vspace{3cm}

---

\pagebreak

## INSTRUCTOR NOTES — DO NOT DISTRIBUTE

### Answers

**1.** Simple before-after change for NJ:

$$\Delta_{NJ} = 21.0 - 20.4 = +0.6 \text{ FTE workers}$$

**2.** The before-after comparison confounds the effect of the minimum wage increase with any other changes happening over the same time period that affect fast-food employment in NJ (macroeconomic trends, seasonal effects, changes in consumer demand, etc.). If employment was going to decline anyway due to broader trends, the +0.6 overstates the true effect; if employment was trending up for other reasons, it could understate or overstate it. This is a classic omitted variable / confounding problem — time-varying factors are not controlled for.

**3.** DiD estimate (either approach):

*Approach (a): Difference in before-after changes*

$$\text{DiD} = \Delta_{NJ} - \Delta_{PA} = (21.0 - 20.4) - (21.2 - 23.3) = 0.6 - (-2.1) = +2.7$$

*Approach (b): Difference in cross-state gaps*

$$\text{DiD} = (21.0 - 21.2) - (20.4 - 23.3) = (-0.2) - (-2.9) = +2.7$$

Both give DiD = **+2.7 FTE workers per restaurant**.

**4.** "The minimum wage increase in New Jersey is estimated to have increased average fast-food restaurant employment by 2.7 full-time equivalent workers per restaurant, relative to what would have occurred absent the policy change."

**5.** The parallel trends assumption requires that, *in the absence of the minimum wage increase*, average fast-food employment in New Jersey would have changed by the same amount as in Pennsylvania between November 2019 and March 2020. In other words, any time trends affecting fast-food employment would have been the same in both states had New Jersey not raised its minimum wage.

**6.**

*Reasons it might hold:*

- NJ and PA are neighboring states with similar economies, labor markets, and demographics
- Fast-food chains operate similarly across state lines (same companies, similar consumer bases)
- Pre-treatment trends in fast-food employment might be similar (could verify with additional pre-period data)

*Reasons it might fail:*

- March 2020 is the start of the COVID-19 pandemic — differential pandemic impacts across states could violate parallel trends
- NJ and PA may have different industry compositions or population growth rates
- Other state-level policies may have changed at the same time
- Anticipation effects: NJ employers might have adjusted employment before the formal implementation

**7.** Regression equation:

$$Employment_{st} = \beta_0 + \beta_1 \cdot NJ_s + \beta_2 \cdot After_t + \beta_3 \cdot (NJ_s \times After_t) + u_{st}$$

Where:

- $NJ_s = 1$ if New Jersey, 0 if Pennsylvania
- $After_t = 1$ if March 2020 (post-treatment), 0 if November 2019 (pre-treatment)
- $\beta_3$ is the DiD estimate (= 2.7)

Interpretation of all coefficients:

- $\beta_0 = 23.3$ (PA employment, before)
- $\beta_1 = 20.4 - 23.3 = -2.9$ (NJ-PA gap, before)
- $\beta_2 = 21.2 - 23.3 = -2.1$ (PA change over time)
- $\beta_3 = 2.7$ (DiD: the additional change in NJ beyond the PA trend)

### Teaching Notes

- This activity is inspired by Card and Krueger (1994), "Minimum Wages and Employment: A Case Study of the Fast-Food Industry in New Jersey and Pennsylvania," *AER*. The numbers here are illustrative and close to (but not identical to) the original study.
- The COVID timing issue in Q6 is intentional — it creates a natural discussion point about threats to identification and how real-world events can compromise research designs.
- For the bonus question, emphasize that the interaction term is the key — students often struggle to see how a 2x2 table maps to a regression with an interaction.
- Common student error: confusing "parallel trends" with "equal levels." Stress that the assumption is about *changes* (trends), not *levels*.
