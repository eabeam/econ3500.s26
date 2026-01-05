Version: Spring 2018\
EC200 Econometrics and Applications

**Problem Set 7**\

1.  In 1985, neither Florida nor Georgia had laws banning open alcohol
    containers in vehicle passenger compartments. By 1990, Florida had
    passed such a law, but Georgia had not.

    1.  Suppose you collect random samples of the driving-age population
        in both states, for 1985 and 1990. Let $arrest$ be a binary
        variable equal to one if a person was arrested for drunk driving
        during the year. Without controlling for any other factors,
        write down a linear probability model that allows you to test
        whether the open container law reduced the probability of being
        arrested for drunk driving. Which coefficient measures the
        effect of the law?

    2.  Why might you want to control for other factors in the model?
        What might some of these factors be?

    3.  Now, suppose that you can only collect data for 1985 and for
        1990 at the county level for the two states. The dependent
        variable would be the fraction of licensed drivers arrested for
        drunk driving during the year. How does this data structure
        differ from the individual-level data described in part (a)?
        What econometric method would you use?

2.  For this exercise, use `JTRAIN.dta` to determine the effect of a job
    training grant on hours of job training per employee. The basic
    model for the three years is the following: $$\begin{split} 
    hrsemp_{it} &= \beta_0 + \delta_1 d88_t + \delta_2 d89_t +\\
    &  \beta_1 grant_{it} + \beta_2 grant_{i,t-1} + \beta_3 log(employ_{it}) + a_i + u_{it}
    \end{split}$$

    1.  Estimate the equation using first differencing. How many firms
        are used in the estimation? How many total observations would be
        used if each firm had data on all variables (in particular,
        $hrsemp$) for all three time periods?

    2.  Interpret the coefficient on $grant$, and comment on its
        significance.

    3.  Is it surprising that $grant_{-1}$ is insignificant? Explain.

    4.  Do larger firms train their employees more or less, on average?
        How big are the differences in training?

3.  Use `CRIME4.dta` for this exercise, and see scanned upload for
    example 13.9.

    1.  Replicate the results in Example 13.9.

    2.  Re-estimate the unobserved effects model for crime in Example
        13.9, but use fixed effects rather than differencing. Are there
        any notable sign or magnitude changes in the coefficients? What
        about statistical significance?

    3.  Add the logs of each wage variable in the data set and estimate
        the model by fixed effects. How does including these variables
        affect the coefficient on the criminal justic variables in part
        (b)?

    4.  Do the wage variables in part (c) have the expected sign? Are
        they jointly significant?

4.  Finish and submit Lab 6.
