ECON3500: Econometrics and Applications

# In-Class Activity: Regression Audit

**Chapter 9 — Threats to Internal Validity**

## Setup

A school district superintendent wants to know: **does reducing class size improve student test scores?** She hires an economist to study the question using data from 420 elementary schools across California.

The key variables are:

- **testscr** — district average test score (combined math and reading, scale 600--720)
- **str** — student-teacher ratio (average class size proxy)
- **el_pct** — percent of students who are English learners
- **avginc** — district average household income (in \$1,000s)
- **meal_pct** — percent of students qualifying for free/reduced-price meals (a proxy for poverty)
- **calworks** — percent of students in public assistance programs

The economist estimates three specifications. Review the output below and answer the questions that follow.

---

### Specification (1): Bivariate regression

```
. regress testscr str

      Source |       SS           df       MS      Number of obs   =       420
-------------+----------------------------------   F(1, 418)       =     22.58
       Model |  7794.11004         1  7794.11004   Prob > F        =    0.0000
    Residual |  144315.484       418  345.252354   R-squared       =    0.0512
-------------+----------------------------------   Adj R-squared   =    0.0490
       Total |  152109.594       419  363.029819   Root MSE        =    18.580

------------------------------------------------------------------------------
     testscr |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
         str |  -2.279808   .4798256    -4.75   0.000    -3.223068   -1.336549
       _cons |   698.9330   9.467491    73.83   0.000     680.3231    717.5428
------------------------------------------------------------------------------
```

### Specification (2): Adding demographic controls

```
. regress testscr str el_pct meal_pct

      Source |       SS           df       MS      Number of obs   =       420
-------------+----------------------------------   F(3, 416)       =    361.68
       Model |  124045.959         3  41348.6529   Prob > F        =    0.0000
    Residual |  28063.6355       416  67.4606612   R-squared       =    0.8156
-------------+----------------------------------   Adj R-squared   =    0.8143
       Total |  152109.594       419  363.029819   Root MSE        =    8.2135

------------------------------------------------------------------------------
     testscr |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
         str |  -0.998309   .2704117    -3.69   0.000    -1.530032   -0.466587
      el_pct |  -0.121573   .0332578    -3.66   0.000    -0.186919   -0.056228
    meal_pct |  -0.547235   .0240462   -22.75   0.000    -0.594531   -0.499940
       _cons |   700.3918   5.537407   126.48   0.000     689.5001    711.2835
------------------------------------------------------------------------------
```

### Specification (3): Adding income and income-squared

```
. regress testscr str el_pct meal_pct avginc avginc_sq

      Source |       SS           df       MS      Number of obs   =       420
-------------+----------------------------------   F(5, 414)       =    241.17
       Model |  126306.099         5  25261.2198   Prob > F        =    0.0000
    Residual |  25803.4953       414  62.3272831   R-squared       =    0.8305
-------------+----------------------------------   Adj R-squared   =    0.8284
       Total |  152109.594       419  363.029819   Root MSE        =    7.8948

------------------------------------------------------------------------------
     testscr |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
         str |  -0.734206   .2637618    -2.78   0.006    -1.252840   -0.215571
      el_pct |  -0.176017   .0341101    -5.16   0.000    -0.243040   -0.108993
    meal_pct |  -0.420495   .0295224   -14.24   0.000    -0.478520   -0.362470
      avginc |   3.850891   0.582873     6.61   0.000     2.704831    4.996951
   avginc_sq |  -0.043100   0.009935    -4.34   0.000    -0.062620   -0.023580
       _cons |   663.7046   7.745928    85.69   0.000     648.4748    678.9345
------------------------------------------------------------------------------
```

---

## Questions

**1. Interpret the coefficient on `str` in Specification (1). Is it statistically significant?**

\vspace{3cm}

**2. Compare the coefficient on `str` across the three specifications. What happens to it as controls are added? What does this pattern suggest about the direction of omitted variable bias in Specification (1)?**

\vspace{4cm}

**3. Specification (1) omits `el_pct` and `meal_pct`. Using the omitted variable bias formula, explain why omitting these variables likely biases the coefficient on `str` in Specification (1). Be specific about:**
- **The likely correlation between `str` and the omitted variable**
- **The likely sign of the omitted variable's coefficient**
- **The resulting direction of bias**

\vspace{4cm}

**4. Specification (3) adds `avginc` and `avginc_sq` (income squared). What threat to internal validity does including `avginc_sq` address? Why might the relationship between income and test scores be nonlinear?**

\vspace{3cm}

**5. Even after adding all these controls, what threats to internal validity might remain? Identify at least two specific threats and, for each, explain:**
- **What the specific concern is**
- **What additional data or method could help address it**

\vspace{5cm}

**6. The superintendent wants to use these results to argue that the state legislature should fund smaller class sizes across California. Briefly assess:**
- **(a) Does this study have internal validity for estimating the causal effect of class size on test scores in California? Why or why not?**
- **(b) Would these results have external validity if applied to schools in a developing country? Why or why not?**

\vspace{5cm}

---

\newpage

## INSTRUCTOR NOTES — DO NOT DISTRIBUTE

### Question 1

The coefficient on `str` in Specification (1) is -2.28. Interpretation: A one-unit increase in the student-teacher ratio (i.e., one more student per teacher) is associated with a 2.28-point decrease in district average test scores, holding nothing else constant.

It is statistically significant at the 1% level: t = -4.75, p < 0.001. The 95% confidence interval [-3.22, -1.34] does not include zero.

### Question 2

The coefficient on `str` changes across specifications:
- Spec (1): -2.28
- Spec (2): -1.00
- Spec (3): -0.73

The coefficient shrinks in magnitude (toward zero) as controls are added. This pattern suggests that **Specification (1) overstates the negative effect** — i.e., the omitted variable bias in Spec (1) is **negative** (biasing the coefficient away from zero, making it more negative than the true causal effect).

This makes sense: districts with high student-teacher ratios tend to be poorer districts that also have worse test scores for other reasons. Once we control for those other reasons (poverty, English learners, income), the remaining effect attributable to class size is smaller.

### Question 3

Using the OVB formula: $bias = \delta_1 \times \gamma_{omitted}$

**For `meal_pct` (poverty):**
- Correlation between `str` and `meal_pct`: Likely **positive**. Poorer districts have less funding and therefore larger class sizes (higher student-teacher ratios).
- Coefficient on `meal_pct` in the regression: **Negative** (-0.55). Poverty is associated with lower test scores.
- Direction of bias: positive $\times$ negative = **negative bias**. Omitting poverty makes the coefficient on `str` more negative than its true value. This is consistent with what we observe.

**For `el_pct` (English learners):**
- Correlation between `str` and `el_pct`: Likely **positive**. Districts with more English learners tend to be urban or under-resourced and may have higher student-teacher ratios.
- Coefficient on `el_pct`: **Negative** (-0.12). More English learners is associated with lower average test scores.
- Direction of bias: positive $\times$ negative = **negative bias**. Same direction.

Both omitted variables bias the `str` coefficient in the same direction (more negative), which is why the coefficient shrinks when they are added.

### Question 4

Including `avginc_sq` addresses the threat of **wrong functional form**. The relationship between income and test scores is likely nonlinear — specifically, concave (diminishing returns). An additional $1,000 in average income probably improves test scores more in poor districts than in wealthy districts.

Evidence: The coefficient on `avginc_sq` is negative (-0.043) and statistically significant (t = -4.34), confirming the concave relationship. Including the squared term improves R-squared from 0.8156 to 0.8305.

If we only included `avginc` linearly, we would be imposing a constant marginal effect of income across all income levels, which is a misspecification.

### Question 5

Remaining threats (students should identify at least two):

1. **Omitted variable bias**: Even with these controls, there may be unobserved factors correlated with both `str` and test scores. Examples:
   - Teacher quality: Districts that can afford smaller classes may also attract better teachers. We cannot separate the class-size effect from the teacher-quality effect.
   - Parental involvement: Wealthier districts may have more engaged parents, which improves test scores independent of class size.
   - School resources (beyond class size): Libraries, technology, facilities.
   - *Solution*: Add controls for teacher qualifications, school spending per pupil, or parental education. Alternatively, use an instrumental variable or a natural experiment (e.g., class size rules that create discontinuities, as in Angrist and Lavy 1999).

2. **Simultaneous causality**: Districts that observe low test scores may respond by reducing class sizes (hiring more teachers). If so, low test scores cause small class sizes, creating reverse causality.
   - *Solution*: Use an instrument for class size, or exploit policy rules that exogenously assign class sizes (e.g., maximum class size rules that create sharp cutoffs).

3. **Errors-in-variables bias**: The student-teacher ratio is a proxy for class size, not actual class size. Districts may have non-teaching staff counted in the ratio, or some teachers may serve as specialists rather than classroom instructors. This measurement error would attenuate the coefficient toward zero.
   - *Solution*: Use actual class size data rather than student-teacher ratios.

4. **Sample selection bias**: The sample includes only California districts. If certain types of districts are systematically excluded (e.g., very small rural districts, charter schools), results may not reflect the true relationship even within California.
   - *Solution*: Verify sample coverage and compare included vs. excluded districts on observables.

### Question 6

**(a) Internal validity:**
The study has **limited internal validity**. While the addition of controls substantially reduces omitted variable bias (as evidenced by the coefficient changing from -2.28 to -0.73), the remaining threats identified in Question 5 — particularly unobserved teacher quality, simultaneous causality, and measurement error — mean we cannot be confident the estimate of -0.73 represents the true causal effect. The study is observational, not experimental, so there is no way to fully rule out confounding.

That said, the study does a reasonable job of addressing the most obvious sources of bias, and the consistent negative sign across specifications is suggestive. The coefficient is "better" than the naive estimate but still potentially biased.

**(b) External validity:**
External validity to a developing country is **weak**. Several factors differ:
- The relationship between class size and learning may differ due to different pedagogical approaches, curriculum, teacher training, and student background.
- Class sizes in developing countries are often much larger (40--80 students), well outside the range observed in California (~15--25). Extrapolating beyond the data range is unreliable.
- School infrastructure, teacher quality, and resource constraints differ fundamentally.
- The outcome measure (standardized test scores) may not be comparable.

The results may generalize to other U.S. states with similar demographics and school systems, but even that requires caution about institutional differences.
