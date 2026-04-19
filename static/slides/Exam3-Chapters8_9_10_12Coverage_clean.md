# Exam 3: Chapters 8, 9, 10, 12 Coverage

**Question: What are the things we need to prove/know/memorize/etc?**

*Remember, you can create and bring a one-page double sided formula sheet!*

## Calculations and derivations

You should be able to calculate or derive the following. Also, interpret what they mean and do not mean!

**General notes** (across all our chapters) 

- Interpret coefficients correctly and precisely with units
- Use subscripts appropriately and properly write population models and estimated equations

**Nonlinear regression (Ch 8)**

- Compute the marginal effect of $X$ in a quadratic model, find the turning point of a quadratic
- Apply the log interpretation table to correctly interpret $\beta_1$ in level-level, log-level, level-log, and log-log specifications
- Compute the marginal effect of $X_1$ in a model with an interaction term:
  - Binary $\times$ binary
  - Binary $\times$ continuous
  - Continuous $\times$ continuous

**Difference-in-differences (Ch 10)**

- Calculate a DiD estimate from a 2x2 table (treatment/control $\times$ before/after) by hand
- Set up and interpret a basic DiD regression
  - Identify which coefficient is the DiD estimate and interpret it
  - Calculate group means from the coefficients (for example, the treatment group in the after period)

**Fixed effects / First differencing (Ch 10)**

- Show how first-differencing eliminates the entity fixed effect $\alpha_i$

**Instrumental variables (Ch 12)**

- Set up and interpret the two stages of 2SLS:
- Evaluate the first-stage F-statistic against the $F > 10$ rule of thumb
- Know the reduced-form / Wald relationship with a binary instrument

## Empirical interpretation

You could see any of the following and be asked to interpret key elements:

- Regression output with nonlinear terms (polynomial, log transformations, interaction terms)
- A regression with entity and/or time fixed effects
- 2SLS/IV output (first stage and second stage)
- A DiD setup (2x2 table or regression output)

You could be asked to:

- Interpret coefficients correctly — compute marginal effects at specific values for polynomials and interactions; apply the log table for log specifications
- Given a research scenario...
  - Identify which threat(s) to internal validity apply (and do not apply!) and propose solutions
  - Identify and evaluate threats to external validity

- Discuss the direction of bias from omitted variables or from measurement error (attenuation bias — toward zero)
- Evaluate whether a proposed instrument satisfies the two conditions (relevance, exogeneity) — and distinguish which conditions are testable vs. which require argumentation (*Note that you may think of them as three conditions: relevance, exogeneity, and exclusion, if you prefer*)
- Interpret what the IV estimate actually measures (LATE for compliers, not the ATE for the full population)
- Discuss internal vs. external validity of a study
- Reflect on economic vs. statistical significance

## Theoretical interpretation

**Five threats to internal validity (Ch 9)**

- You should be able to name, define, and identify in context each of the five threats to internal validity 
- Know at least one solution for each threat:
- Know the direction of bias for measurement error when applicable (classical) and when you can't know the direction
- Be able to identify which threat applies to a given research scenario

**Causal diagrams / DAGs (Ch 9b)**

- Draw and interpet (relatively simple) DAGs
- Distinguish causal (front-door) paths from backdoor paths and their implications
- Confounding = OVB = open backdoor path
- Understand what "controlling for" a variable does — and what not to control for (mediators, colliders)
- Explain in theory and through examples

**Panel data and fixed effects (Ch 10)**

- Distinguish panel data from cross-sectional, time-series, and pooled cross-sections
- Explain what entity fixed effects control for (all time-invariant unobserved characteristics) and what they *cannot* control for (time-varying omitted variables)
- State and interpret the parallel trends assumption and explain why it matters for DiD
  - Know what happens if parallel trends is violated
  - Know how to assess it
- Understand how to adjust standard errors when working with panel data

**Instrumental variables (Ch 12)**

- The two conditions for a valid instrument (in words and equations), which are testable (and how) and which are not testable
- The weak instruments problem

**Cross-chapter connections**

- When faced with different sorts of internal validity problems, which methods help (and why) and which do not
