# PS3 Clarification: BLUE Assumptions (Q6f)

A few of you have asked about Question 6f, which asks: "Under what assumptions is the OLS estimator BLUE?"

We covered the Gauss-Markov theorem and BLUE in Chapter 5 (for simple regression), then introduced additional assumptions for multiple regression in Chapter 6. Question 6f asks you to put these together.

**For OLS to be BLUE in multiple regression, you need all five of the following:**

1. **Zero conditional mean:** $E[u_i \mid X_{1i}, \ldots, X_{ki}] = 0$
2. **i.i.d. sampling:** observations are independently and identically distributed
3. **No large outliers:** $X$s and $Y$ have finite fourth moments
4. **No perfect multicollinearity:** no regressor is an exact linear function of the others
5. **Homoskedasticity:** $\text{Var}(u_i \mid X_{1i}, \ldots, X_{ki})$ is constant

Assumptions 1-4 give you unbiasedness. Adding assumption 5 gives you efficiency — the "Best" in BLUE (smallest variance among all linear unbiased estimators).

For the second part of the question, think about the cross-country growth regression specifically. For each assumption, ask: is this plausible in this setting? One short sentence per assumption is enough.
