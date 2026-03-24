ECON3500 Econometrics and Applications \
Spring 2026

# In-Class Activity: Is This a Good Instrument?

**Chapter 12 — Instrumental Variables Regression**

For each scenario below, a researcher wants to estimate the causal effect of $X$ on $Y$ and proposes using $Z$ as an instrumental variable. Your job: evaluate whether $Z$ is a valid instrument.

For each scenario, assess:

- **Relevance**: Is $Z$ correlated with $X$? Why or why not?
- **Exogeneity**: Is $Z$ uncorrelated with the error term $u$? What could go wrong?
- **Exclusion**: Does $Z$ affect $Y$ *only* through $X$? What are the threats?
- **Overall verdict**: Good instrument, bad instrument, or "it depends"?

---

## Scenario 1: Returns to Education

A researcher wants to estimate the effect of **years of education** on **log weekly earnings**. She is worried that ability is unobserved and correlated with both education and earnings (classic OVB). She proposes using **distance from the student's childhood home to the nearest four-year college** as an instrument for years of education.

*(Based on Card, 1993)*

| | Your assessment |
|---|---|
| Relevance | |
| Exogeneity | |
| Exclusion | |
| Verdict | |

---

## Scenario 2: Police and Crime

A city government wants to know whether **hiring more police officers** reduces **violent crime**. The problem: cities that experience crime waves hire more police, creating simultaneous causality. A researcher proposes using **the number of firefighters hired in the same year** as an instrument for police hiring.

| | Your assessment |
|---|---|
| Relevance | |
| Exogeneity | |
| Exclusion | |
| Verdict | |

---

## Scenario 3: Class Size and Test Scores

A school district wants to estimate the effect of **class size** on **standardized test scores**. Parents with more resources may sort into schools with smaller classes (selection bias). A researcher proposes using **random fluctuations in cohort size due to enrollment cutoffs** (e.g., Maimonides' Rule: when enrollment crosses a multiple of 40, an additional class section is created) as an instrument for class size.

*(Based on Angrist and Lavy, 1999)*

| | Your assessment |
|---|---|
| Relevance | |
| Exogeneity | |
| Exclusion | |
| Verdict | |

---

## Scenario 4: Smoking and Health

A health economist wants to estimate the effect of **cigarette consumption** (packs per day) on **infant birth weight**. Smoking behavior is likely correlated with other health behaviors, income, and stress, all of which also affect birth weight. She proposes using **state cigarette excise taxes** as an instrument for cigarette consumption.

| | Your assessment |
|---|---|
| Relevance | |
| Exogeneity | |
| Exclusion | |
| Verdict | |

---

## Scenario 5: Income and Health

A researcher wants to estimate the causal effect of **income** on **self-reported health status**. Income is endogenous because health affects the ability to work (reverse causality) and unobserved factors like motivation affect both. He proposes using **lottery winnings** (among people who play the lottery) as an instrument for income.

*(Based on Lindahl, 2005)*

| | Your assessment |
|---|---|
| Relevance | |
| Exogeneity | |
| Exclusion | |
| Verdict | |

---

\newpage

## INSTRUCTOR NOTES — DO NOT DISTRIBUTE

### Scenario 1: Distance to College → Education → Earnings

- **Relevance**: Yes. Students who grow up closer to a college face lower costs of attending (commuting, living at home) and are more likely to attend. Empirically strong first stage.
- **Exogeneity**: Potential concern. Families who live near colleges may differ systematically — they may live in more urban areas, have higher-income parents, or have better access to other amenities. If these factors also affect earnings directly, exogeneity fails. Card (1993) argues that after controlling for region, urban/rural status, and family background, proximity is plausibly exogenous.
- **Exclusion**: The worry is that proximity to a college captures something about the local labor market or community characteristics that directly affect earnings. If living near a college means living near a city with better job opportunities, the exclusion restriction is violated. Controls help, but the assumption is not testable.
- **Verdict**: Reasonable but imperfect. The key question is whether controls adequately capture the ways proximity might directly affect earnings. This is a classic "plausible but debatable" instrument — good for discussion.

### Scenario 2: Firefighters → Police → Crime

- **Relevance**: Moderate. Cities that expand public safety budgets may hire both more police and more firefighters. Budget shocks could move both.
- **Exogeneity**: Problematic. The same budget pressures, political dynamics, or public safety concerns that drive firefighter hiring could also directly affect crime or crime reporting. A crime wave could trigger expanded hiring across all public safety departments.
- **Exclusion**: Very dubious. Firefighter hiring likely reflects the same municipal budget and public safety environment that directly affects crime through many channels (social services, economic conditions, etc.).
- **Verdict**: Bad instrument. The conditions that drive firefighter hiring are likely correlated with unobserved determinants of crime. This violates both exogeneity and exclusion. (Compare with Levitt's (1997) use of electoral cycles as an instrument, which is more plausible.)

### Scenario 3: Enrollment Cutoffs → Class Size → Test Scores

- **Relevance**: Yes. Maimonides' Rule mechanically determines class size. When enrollment crosses a multiple of 40, an additional section is created, producing a sharp drop in average class size. This generates strong variation.
- **Exogeneity**: Strong. The enrollment cutoffs are determined by administrative rules and population fluctuations that are plausibly unrelated to the characteristics of individual students. Parents would need to precisely manipulate enrollment counts to game the system, which is difficult.
- **Exclusion**: Mostly satisfied. The enrollment cutoff affects students primarily through class size. One concern: crossing a threshold could also affect other school resources (need for additional classrooms, teacher quality of marginal hires). Angrist and Lavy argue these channels are minor.
- **Verdict**: Good instrument — one of the textbook examples of a well-designed IV strategy. The mechanical rule creates quasi-random variation in class size.

### Scenario 4: Cigarette Taxes → Smoking → Birth Weight

- **Relevance**: Yes. Higher taxes raise the price of cigarettes, which reduces consumption (basic demand theory). Empirically well-documented.
- **Exogeneity**: Moderate concern. State tax rates could be correlated with state-level characteristics that also affect birth weight — for example, states with higher cigarette taxes may also have better public health infrastructure, higher incomes, or different demographics. Including state-level controls helps.
- **Exclusion**: The main worry: cigarette taxes generate state revenue that could fund health programs, or high-tax states may have other anti-smoking policies (clean air laws, health education) that affect birth weight through channels other than the mother's smoking. If taxes proxy for a broader public health environment, exclusion is violated.
- **Verdict**: Decent but requires careful controls. The instrument is relevant and widely used (Evans and Ringel, 1999), but exclusion requires that tax variation is not simply proxying for a state's overall health policy environment. Cross-state and over-time variation in tax changes can help.

### Scenario 5: Lottery Winnings → Income → Health

- **Relevance**: Yes. Lottery winnings directly increase income. The magnitude depends on the size of winnings — small prizes may not generate enough variation (potential weak instrument concern for small winners).
- **Exogeneity**: Strong, conditional on playing the lottery. Among lottery players, the amount won is random. The key conditioning assumption is that the *decision to play* is not itself endogenous — the sample is restricted to lottery players, so we need exogeneity within that group, not in the general population.
- **Exclusion**: Mostly satisfied. The main channel from lottery winnings to health is through increased income/wealth. Possible concerns: large winnings could cause stress, lifestyle changes, or social disruption that affect health independent of the "income" channel. But for moderate winnings, income is the dominant pathway.
- **Verdict**: Good instrument (within the lottery-playing population). The randomization of winnings is a powerful source of exogenous variation. The main limitation is **external validity**: the LATE applies to lottery players, who may not be representative of the general population. Also, the LATE captures the effect of *windfall* income, which may differ from the effect of *earned* income.

### General Teaching Notes

- Emphasize that **exogeneity and exclusion are not testable** — they require economic reasoning and domain knowledge.
- Relevance *is* testable via the first-stage F-statistic ($F > 10$ rule of thumb).
- Use these scenarios to highlight that most IV debates are about exclusion and exogeneity, not relevance.
- Scenario 2 (firefighters) is intentionally a clear "bad instrument" — students should feel confident rejecting it. Scenarios 1 and 4 are "good but debatable," which models the real-world messiness of IV.
- Connect to **LATE**: In each scenario, ask students *who are the compliers?* For example, in Scenario 1, compliers are students whose education decision is actually affected by distance to college — not those who would attend regardless or never attend regardless.
