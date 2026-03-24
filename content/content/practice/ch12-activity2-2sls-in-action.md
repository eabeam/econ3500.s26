ECON3500 Econometrics and Applications \
Spring 2026

# In-Class Activity: 2SLS in Action

**Chapter 12 — Instrumental Variables Regression**

A labor economist wants to estimate the **causal effect of years of education on log hourly wages**. She uses data on 3,010 U.S. men born between 1930 and 1939 from the 1980 Census. She is worried that OLS estimates are biased because **ability** is unobserved: more able individuals get more education *and* earn higher wages, even holding education constant.

Her proposed instrument: **quarter of birth**. The idea is that compulsory schooling laws require students to stay in school until age 16. Students born earlier in the year reach age 16 earlier in the school year, so they can legally drop out with less total education. Quarter of birth thus affects years of education completed but should not directly affect wages.

*(Based on Angrist and Krueger, 1991)*

---

## Regression Output

### Table 1: OLS Regression

Dependent variable: Log hourly wage

| Variable | Coefficient | Std. Error | t-statistic |
|---|---|---|---|
| Years of education | 0.0700 | 0.0035 | 20.00 |
| Black | -0.236 | 0.018 | -13.11 |
| Married | 0.121 | 0.016 | 7.56 |
| Region (South) | -0.098 | 0.015 | -6.53 |
| Constant | 5.02 | 0.052 | 96.54 |

$R^2 = 0.132$, $n = 3{,}010$

---

### Table 2: First-Stage Regression

Dependent variable: Years of education

| Variable | Coefficient | Std. Error | t-statistic |
|---|---|---|---|
| Born Q1 (Jan–Mar) | -0.152 | 0.067 | -2.27 |
| Black | -1.47 | 0.12 | -12.25 |
| Married | 0.38 | 0.11 | 3.45 |
| Region (South) | -0.54 | 0.10 | -5.40 |
| Constant | 12.84 | 0.078 | 164.62 |

$R^2 = 0.087$, $n = 3{,}010$

**First-stage F-statistic on excluded instrument (Born Q1):** $F = 5.15$

---

### Table 3: IV/2SLS Regression

Dependent variable: Log hourly wage \
Endogenous variable: Years of education \
Instrument: Born Q1 (= 1 if born January–March)

| Variable | Coefficient | Std. Error | t-statistic |
|---|---|---|---|
| Years of education | 0.142 | 0.061 | 2.33 |
| Black | -0.133 | 0.075 | -1.77 |
| Married | 0.075 | 0.043 | 1.74 |
| Region (South) | -0.060 | 0.038 | -1.58 |
| Constant | 4.11 | 0.78 | 5.27 |

$n = 3{,}010$

---

## Questions

### Question 1: OLS Interpretation

(a) Interpret the OLS coefficient on years of education. Be precise about units and magnitude.

\vspace{2cm}

(b) Why might this coefficient be a *biased* estimate of the causal effect of education on wages? What is the likely direction of the bias? Explain using the omitted variable bias formula.

\vspace{3cm}

---

### Question 2: First Stage

(a) Interpret the coefficient on "Born Q1" in the first-stage regression. What does it tell us about the relationship between quarter of birth and years of education?

\vspace{2cm}

(b) The first-stage F-statistic on the excluded instrument is $F = 5.15$. What does this tell us? Should we be concerned? Why or why not?

\vspace{2cm}

---

### Question 3: IV/2SLS Interpretation

(a) Interpret the 2SLS coefficient on years of education. How does it compare to the OLS estimate?

\vspace{2cm}

(b) Using the simple IV formula $\hat{\beta}_1^{IV} = \frac{Cov(\text{log wage}, \text{Born Q1})}{Cov(\text{educ}, \text{Born Q1})}$, explain intuitively why the IV estimate is larger than the OLS estimate.

\vspace{3cm}

---

### Question 4: Bias Direction

Given that the OLS estimate (0.070) is *smaller* than the 2SLS estimate (0.142), what does this imply about the direction of bias in OLS? Is this surprising? Why or why not?

*Hint: Think about what you would expect if ability bias drives OLS upward. What else could be going on?*

\vspace{3cm}

---

### Question 5: LATE and Validity

(a) The IV estimate is a **Local Average Treatment Effect (LATE)**. In this context, who are the *compliers* — the group whose behavior is actually affected by the instrument?

\vspace{2cm}

(b) Name one threat to the validity of quarter of birth as an instrument for education. That is, provide a reason why the exogeneity or exclusion restriction might fail.

\vspace{2cm}

---

\newpage

## INSTRUCTOR NOTES — DO NOT DISTRIBUTE

### Question 1: OLS Interpretation

**(a)** One additional year of education is associated with approximately 7.0% higher hourly wages, controlling for race, marital status, and region. (Technically: a one-year increase in education is associated with a 0.070 increase in log wages, or about 7.0% higher wages.)

**(b)** If ability is omitted:
- $\text{Bias} = \beta_{\text{ability}} \times \frac{Cov(\text{educ}, \text{ability})}{Var(\text{educ})}$
- $\beta_{\text{ability}} > 0$ (ability raises wages)
- $Cov(\text{educ}, \text{ability}) > 0$ (more able people get more education)
- Therefore bias is **positive**: OLS *overestimates* the causal effect of education.
- This is the standard prediction. We expect OLS > true causal effect if ability bias dominates.

### Question 2: First Stage

**(a)** Being born in Q1 (January–March) is associated with **0.152 fewer years of education** compared to being born in Q2–Q4, controlling for race, marital status, and region. This is consistent with compulsory schooling laws: Q1 students reach the legal dropout age earlier in the school year and can exit with less total schooling.

**(b)** The F-statistic of 5.15 is **below the conventional threshold of 10** for strong instruments. This is a **weak instrument** concern.

Consequences of weak instruments:
- 2SLS estimates are biased toward OLS in finite samples
- Standard errors are unreliable (confidence intervals have incorrect coverage)
- The 2SLS estimate may not be trustworthy

This is a well-known limitation of the Angrist-Krueger design with a single quarter-of-birth indicator. The original paper used multiple QOB indicators interacted with year of birth to generate more variation — but even then, weak instrument concerns have been raised (Bound, Jaeger, and Baker, 1995).

### Question 3: IV/2SLS Interpretation

**(a)** The 2SLS estimate implies that an additional year of education *causes* approximately a 14.2% increase in hourly wages. This is **twice as large** as the OLS estimate of 7.0%.

The standard errors are also much larger (0.061 vs. 0.0035), which is typical of IV — we are using less variation (only the part driven by the instrument), so estimates are noisier.

**(b)** Intuition for the IV formula: The numerator captures how much wages differ by quarter of birth. The denominator captures how much education differs by quarter of birth. Since the education difference (denominator) is small (only 0.15 years), even a modest wage difference gets "scaled up" substantially when we divide. This is partly why the IV estimate is large — and why weak instruments are dangerous (a small, noisy denominator amplifies noise).

### Question 4: Bias Direction

The fact that OLS (0.070) < IV (0.142) is **surprising** if we believe ability bias is the main problem, because ability bias should push OLS *up*, not down.

Possible explanations:
1. **Measurement error in education**: If education is measured with error (self-reported years of schooling), OLS is attenuated toward zero. IV corrects for measurement error because the instrument is correlated with *true* education, not the measurement error. This attenuation could be larger than the upward ability bias.
2. **LATE vs. ATE**: The IV estimate applies to *compliers* — people whose education was affected by compulsory schooling laws. These are individuals at the margin of dropping out, who likely have lower baseline education. The return to education may be *higher* for this group than for the average person in the sample (heterogeneous treatment effects). So IV > OLS could reflect a higher return for compliers, not necessarily that OLS is biased downward for the whole population.
3. **Weak instrument bias**: With $F = 5.15$, the IV estimate is biased toward OLS, meaning the true IV (if we had a strong instrument) might be even larger — or the current estimate could be unreliable.

The measurement error explanation is particularly compelling and is emphasized in the literature.

### Question 5: LATE and Validity

**(a)** The **compliers** are individuals whose total years of education were affected by compulsory schooling laws — specifically, those who would have dropped out of school earlier if they could have (i.e., if they had reached age 16 before the end of the school year). These are people on the margin of the dropout decision.

The IV estimate does *not* apply to:
- **Always-takers**: People who would have stayed in school regardless of when they turned 16 (e.g., college-bound students)
- **Never-takers**: People who dropped out before age 16 regardless

**(b)** Threats to validity:

- **Season-of-birth and family background**: If families with different characteristics have children at different times of year (e.g., higher-SES families are more likely to have spring babies), then quarter of birth is correlated with ability/background, violating exogeneity. There is some evidence of this (Buckles and Hungerman, 2013).
- **Age-at-test effects**: Students born earlier in the year are older when they take any given test or enter the labor market at a given calendar date. If age itself affects productivity, quarter of birth has a direct effect on wages (violating exclusion).
- **School entry age effects**: Quarter of birth affects the age at which a child starts school. If starting school younger/older affects learning or development, this is a channel from Z to Y that does not operate through *total years* of education.

### General Teaching Notes

- Use this activity to reinforce that **IV estimates are noisy** — much larger standard errors than OLS.
- The weak instrument finding ($F = 5.15$) is a great discussion point. Ask students: "If you were the referee, would you trust this estimate?"
- The "wrong sign" on bias direction (OLS < IV) is one of the most important findings in the returns-to-education literature. It highlights that multiple sources of bias can operate simultaneously (ability bias up, measurement error down), and that LATE may differ from ATE.
- Time permitting, discuss how Angrist and Krueger's original paper used 3 quarter-of-birth dummies interacted with 10 year-of-birth dummies (30 instruments!) — which created its own problems (many weak instruments, overfitting in the first stage).
