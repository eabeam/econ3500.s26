# Worksheet: Does Wine Improve Heart Health?

**ECON3500: Econometrics and Applications** | DAGs and Causal Identification

---

## Your Task: Build the DAG

**Research question:** Does wine consumption improve heart health?

- **Treatment (X):** Wine Consumption
- **Outcome (Y):** Heart Health

### Step 1: List all relevant variables

What other variables might cause wine consumption? What might cause heart health? What might affect both?

Write your list here:

|   | Variable | Causes Wine? | Causes Heart Health? |
|---|----------|:---:|:---:|
| 1 | | | |
| 2 | | | |
| 3 | | | |
| 4 | | | |
| 5 | | | |

### Step 2: Draw arrows

For each pair of variables in your list (including Wine and Heart Health), ask: **does one cause the other?** If yes, draw an arrow from cause to effect.

Draw your DAG here:

&nbsp;

&nbsp;

&nbsp;

&nbsp;

&nbsp;

&nbsp;

&nbsp;

### Step 3: Simplify

Are any variables in your DAG *not* on any path between Wine and Heart Health? If so, remove them.

### Step 4: List all paths from Wine to Heart Health

| # | Path | Type (Causal / Backdoor) | Open or Closed? |
|---|------|:---:|:---:|
| 1 | | | |
| 2 | | | |
| 3 | | | |
| 4 | | | |
| 5 | | | |

### Step 5: Determine what to control for

What is the **minimum set of variables** you need to control for to close all backdoor paths?

**Controls:** _______________________________________________

Does controlling for any of these variables open a collider path? _______________

---

## Discussion Questions

1. The original Lancet (1979) study compared wine consumption and heart disease **across countries**. What additional confounders might exist at the country level that wouldn't apply to individual-level data?

2. The article excerpt mentions that many "non-drinkers" were actually **ex-drinkers who quit for health reasons**. In DAG terms, what kind of bias does this create? (Hint: think about what "being a non-drinker" is caused by.)

3. The Biddinger et al. (2022) study uses **Mendelian randomization** — genetic variants that affect alcohol metabolism as instruments. Why is this a stronger identification strategy than controlling for income and education in a regression?

4. Based on everything in this worksheet: is the wine-heart health correlation **causal**? What would you need to believe for it to be causal?
