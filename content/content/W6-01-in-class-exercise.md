Version: Fall 2020\
EC200 Econometrics and Applications

**In-Class Exercise - Multiple Linear Regression** \

Consider a dataset on earnings in the United States. We are interested
in the returns to education - how much an extra year of schooling "buys"
you in terms of weekly wages (\...as of 1980). You're also worried about
whether one's education suffers from omitted variable bias.

1.  You estimate two equations: $$\begin{aligned}
    \widehat{wage} &= 146.95 + 60.21educ\\
    \widehat{educ} & = 5.84 + 0.075IQ\end{aligned}$$

    Based on these results, is 60.21 an overestimate or underestimate of
    the returns to education? How do you know?

2.  You estimate another equation:
    $\widehat{education} = -128.89 +42.06 educ + 5.14 IQ$

    What is the interpretation of the coefficient on $educ$? What is the
    interpretation of the constant?

3.  Now, you control for experience and age and estimate the following
    population regression model:

    $$wage_i = \beta_0 + \beta_1 educ_i + \beta_2 IQ_i + \beta_3 exper_i + \beta_4 age_i + \beta_5 age_i^2 + u_i$$

    A one-year increase in age is associated with what change in wages?
    (mind the squared term)

4.  Finally, because you are worried about omitted variable bias, you
    include father's and mother's education.

    1.  Why might parent's education might directly affect wage?

    2.  Which other independent variables do you think parent's
        education might affect? Explain.

    3.  How did controlling for parent's education affect the returns to
        education? The returns to IQ?
