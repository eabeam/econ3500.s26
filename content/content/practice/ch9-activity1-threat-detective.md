ECON3500: Econometrics and Applications

# In-Class Activity: Threat Detective

**Chapter 9 — Threats to Internal Validity**

For each scenario below, a researcher estimates a regression and interprets the coefficient on the key independent variable as a causal effect. Your job is to play **threat detective**: identify what could go wrong.

For each scenario:

- (a) Identify which threat(s) to internal validity are most likely present. Choose from:
  1. Omitted variable bias
  2. Wrong functional form
  3. Errors-in-variables bias (measurement error)
  4. Sample selection bias
  5. Simultaneous causality bias
- (b) Explain the likely **direction of bias** on the coefficient of interest (upward or downward). Be specific about your reasoning.
- (c) Propose **one concrete solution** the researcher could implement.

---

## Scenario 1: Education and Earnings

A researcher estimates the following model using data from employed adults aged 25--65:

$$\widehat{earnings}_i = 15{,}200 + 4{,}800 \cdot educ_i$$

where $earnings_i$ is annual earnings in dollars and $educ_i$ is years of schooling. The researcher concludes that each additional year of education causes earnings to increase by \$4,800.

**(a) Threat(s):**

\vspace{2cm}

**(b) Direction of bias and reasoning:**

\vspace{2cm}

**(c) Proposed solution:**

\vspace{2cm}

---

## Scenario 2: Police and Crime

A researcher collects data on 300 U.S. cities and estimates:

$$\widehat{crimerate}_i = 12.4 + 0.83 \cdot policepc_i + controls$$

where $crimerate_i$ is violent crimes per 1,000 residents and $policepc_i$ is police officers per 1,000 residents. The researcher is puzzled: "More police appears to *increase* crime."

**(a) Threat(s):**

\vspace{2cm}

**(b) Direction of bias and reasoning:**

\vspace{2cm}

**(c) Proposed solution:**

\vspace{2cm}

---

## Scenario 3: Job Training and Wages

A large firm offers a voluntary job training program. A researcher compares the wages of workers who enrolled in the program to those who did not:

$$\widehat{wage}_i = 22.50 + 3.10 \cdot training_i$$

where $wage_i$ is the hourly wage one year after the program was offered and $training_i = 1$ if the worker enrolled. The researcher concludes the program raised wages by \$3.10/hour.

**(a) Threat(s):**

\vspace{2cm}

**(b) Direction of bias and reasoning:**

\vspace{2cm}

**(c) Proposed solution:**

\vspace{2cm}

---

## Scenario 4: Health Insurance and Health

A researcher uses survey data in which respondents self-report both their health insurance coverage and their health status on a 1--10 scale. They estimate:

$$\widehat{health}_i = 5.2 + 0.9 \cdot insured_i + controls$$

where $insured_i = 1$ if the respondent reports having health insurance. However, it is known that roughly 10% of respondents misreport their insurance status (some insured people say they are uninsured, and vice versa).

**(a) Threat(s):**

\vspace{2cm}

**(b) Direction of bias and reasoning:**

\vspace{2cm}

**(c) Proposed solution:**

\vspace{2cm}

---

## Scenario 5: Advertising and Sales

A national retail chain estimates the effect of advertising spending on store revenue using quarterly data from its 150 stores:

$$\widehat{revenue}_i = 320{,}000 + 5.2 \cdot adspend_i$$

where $revenue_i$ is quarterly store revenue in dollars and $adspend_i$ is quarterly advertising spending in dollars. The company allocates more advertising budget to stores that had strong sales the previous quarter.

**(a) Threat(s):**

\vspace{2cm}

**(b) Direction of bias and reasoning:**

\vspace{2cm}

**(c) Proposed solution:**

\vspace{2cm}

---

\newpage

## INSTRUCTOR NOTES — DO NOT DISTRIBUTE

### Scenario 1: Education and Earnings

**(a) Threats:**
- **Omitted variable bias** is the primary threat. Ability, family background, and motivation are correlated with both education and earnings but are omitted from the regression.
- **Sample selection bias** is also present: the sample is restricted to employed adults. People with very low education may be disproportionately unemployed and excluded from the sample, which could bias the estimated return to education.

**(b) Direction of bias:**
- OVB: Upward bias. Ability is positively correlated with education (higher-ability people get more schooling) and positively correlated with earnings (higher-ability people earn more). Since both correlations are positive, the omitted variable bias formula gives a positive bias, so 4,800 likely overstates the true causal effect.
- Sample selection: Also likely upward. Among people with low education, only those with favorable unobserved characteristics (e.g., motivation, connections) remain employed, which compresses the apparent earnings gap between low- and high-education groups less than it should — but the net effect is ambiguous.

**(c) Solutions:**
- Add control variables for ability (e.g., test scores), family background (parental education, income).
- Use an instrumental variable (e.g., proximity to a college, compulsory schooling laws, quarter of birth).
- Include the full adult population (employed and unemployed) to address selection.

---

### Scenario 2: Police and Crime

**(a) Threats:**
- **Simultaneous causality bias** is the primary threat. Crime rates affect police hiring decisions (cities with more crime hire more police), and police presence may also affect crime rates. Causality runs in both directions.

**(b) Direction of bias:**
- Upward bias on the police coefficient. High crime causes cities to hire more police, creating a positive correlation between police and crime that is not the causal effect of police on crime. The true causal effect of police on crime is likely negative (more police reduces crime), but simultaneous causality pushes the estimated coefficient upward — potentially making it positive, as we see here.

**(c) Solutions:**
- Use an instrumental variable that affects police staffing but does not directly affect crime (e.g., electoral cycles, firefighter staffing as in Levitt 1997, or federal grants for police hiring).
- Exploit natural experiments (e.g., terror alert levels that exogenously increase police presence, as in Klick and Tabarrok 2005).

---

### Scenario 3: Job Training and Wages

**(a) Threats:**
- **Sample selection bias** (self-selection into treatment). Workers who voluntarily enroll in training are likely systematically different from those who do not — they may be more motivated, more career-oriented, or already on an upward trajectory.
- **Omitted variable bias** — motivation and ambition are omitted and correlated with both training enrollment and wages.
- Note: Students may identify either or both. Accept OVB as an answer, but emphasize that when the selection is into the treatment itself, "sample selection bias" is the more precise label per Stock & Watson Ch. 9.

**(b) Direction of bias:**
- Upward bias. Workers who self-select into training are likely more motivated and ambitious, traits that independently lead to higher wages. The coefficient of 3.10 likely overstates the true causal effect of the program.

**(c) Solutions:**
- Randomize access to the training program (RCT).
- Use the initial offer of training as an instrument (intent-to-treat / IV approach) if the program was offered to a random subset.
- Compare wages before and after training for participants vs. non-participants (difference-in-differences), though this still requires a parallel trends assumption.

---

### Scenario 4: Health Insurance and Health

**(a) Threats:**
- **Errors-in-variables bias (measurement error)** in the independent variable. If 10% of respondents misreport their insurance status, $insured_i$ is measured with classical measurement error.
- Students may also identify **simultaneous causality** (healthier people may be more likely to have jobs that provide insurance, and insurance may improve health) and **omitted variable bias** (income, education, and health behaviors are correlated with both insurance and health outcomes).
- All three are defensible, but the scenario is written to highlight measurement error.

**(b) Direction of bias:**
- Measurement error in a binary independent variable causes **attenuation bias** — the coefficient is biased toward zero. The true effect of insurance on health is likely larger in magnitude than 0.9.
- Key point for students: Classical measurement error in X always biases the coefficient toward zero, regardless of the sign of the true effect.

**(c) Solutions:**
- Use administrative records on insurance coverage (e.g., insurer enrollment data) instead of self-reports to eliminate measurement error.
- Use an instrumental variable (e.g., Medicaid eligibility cutoffs, employer mandate thresholds).
- Reference for discussion: The Oregon Health Insurance Experiment randomly assigned Medicaid access.

---

### Scenario 5: Advertising and Sales

**(a) Threats:**
- **Simultaneous causality bias** is the primary threat. The company explicitly allocates more advertising to stores with strong prior sales. Revenue drives advertising spending, not just the reverse.
- **Omitted variable bias** may also be present: store location quality, local economic conditions, and management quality affect both revenue and the advertising budget allocated.

**(b) Direction of bias:**
- Upward bias. Stores with high revenue receive more advertising budget, creating a positive feedback loop. The coefficient of 5.2 overstates the true causal return to an additional dollar of advertising.

**(c) Solutions:**
- Randomly assign advertising budgets across stores (an A/B test or field experiment).
- Use an instrumental variable for advertising spending that is unrelated to store performance (e.g., random variation in local media costs).
- Use lagged advertising spending (from two or more quarters ago) as the independent variable to break the contemporaneous simultaneity, though this does not fully resolve the problem if the allocation rule is persistent.
