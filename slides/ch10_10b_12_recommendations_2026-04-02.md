# Recommendations for Chapters 10, 10b, and 12

Reviewed files:

- `ch10/ch10_panel_data.qmd`
- `ch10b/ch10b_did.qmd`
- `ch12/ch12_instrumental_variables.qmd`

Date: 2026-04-02

## Overall assessment

The decks are already strong on:

- intuition-first framing
- repeated use of concrete examples
- explicit assumptions
- connecting methods back to earlier chapters
- practical Stata implementation

The biggest gains now would come from tightening sequencing and reducing cognitive load at a few points where the material becomes more advanced than a first-pass undergraduate lecture needs.

## Highest-priority recommendations

### 1. Separate "time fixed effects" from "DiD" even more sharply in Chapter 10

Right now Chapter 10 starts teaching DiD before the panel-data/FE machinery is fully built, then Chapter 10b returns to DiD in more depth. That is defensible, but for undergraduates it risks blurring:

- time fixed effects
- entity fixed effects
- DiD as a design
- TWFE as an implementation

Recommendation:

- In `ch10/ch10_panel_data.qmd`, trim the DiD section to a short preview only.
- Move the full causal DiD build-up to `ch10b/ch10b_did.qmd`.
- In Chapter 10, make the core payoff:
  - panel data lets us compare units to themselves over time
  - entity FE handles time-invariant unit differences
  - time FE handles shocks common to everyone in a period
  - DiD is one important application that comes next

Why:

- Undergraduates often hear "fixed effects" and "difference-in-differences" as if they are the same method.
- Your current decks are close to drawing the distinction, but the sequencing still encourages conflation.

### 2. Add one slide that explicitly contrasts four comparison strategies

This would help both the DiD and FE material click:

1. cross-sectional comparison
2. before/after comparison
3. within-unit comparison with FE
4. DiD comparison

A single 2x2 or four-box slide could ask:

- what comparison is being made?
- what bias does it remove?
- what bias can still remain?

This would connect:

- `ch10/ch10_panel_data.qmd:97`
- `ch10/ch10_panel_data.qmd:205`
- `ch10b/ch10b_did.qmd:60`
- `ch10b/ch10b_did.qmd:145`

### 3. In Chapter 12, teach IV as Wald logic before covariance algebra

The chapter currently moves fairly quickly from assumptions to the covariance derivation:

- `ch12/ch12_instrumental_variables.qmd:210`
- `ch12/ch12_instrumental_variables.qmd:233`

For undergraduates, I would reverse the emphasis:

- first: binary instrument story
- second: first stage and reduced form
- third: Wald ratio
- fourth: 2SLS as the regression generalization
- last: covariance formula as a compact general statement, possibly optional

Why:

- The covariance derivation is correct, but it is not the most pedagogically sticky entry point.
- Many students can parrot the formula without understanding what variation IV is using.

## Chapter-specific recommendations

## Chapter 10: Panel data and fixed effects

### What is working well

- The cross-section/time-series/panel distinction is clean and accessible.
- The first-difference derivation is well paced.
- The time FE explanation is clear and concrete.
- The clustered-SE discussion is strong and appropriately practical.

### Recommended changes

#### A. Narrow the learning objectives

Current objectives include both DiD and panel estimators:

- `ch10/ch10_panel_data.qmd:15-19`

I would consider changing the emphasis so Chapter 10 is mainly about:

- identifying panel data structures
- first differencing
- entity fixed effects
- time fixed effects
- clustered standard errors

Then Chapter 10b can carry most of the DiD burden.

#### B. Add one explicit slide: "What time fixed effects do"

Your current time-FE slide is good:

- `ch10/ch10_panel_data.qmd:376-394`

But I would add one more visual or toy table showing:

- two or three states
- one national shock in 2008 or 2020
- how year dummies absorb that common jump

Undergraduates often understand the words but do not internalize what is being partialled out.

#### C. Revise the FE intuition example

This slide is memorable:

- `ch10/ch10_panel_data.qmd:284-304`

But "Bob smells funny" is the one line I would replace. It reads as intentionally funny, but it also weakens the tone right before a conceptually difficult section.

A tighter version would use traits like:

- motivation
- social skills
- family background
- baseline productivity

#### D. Soften the "always cluster" language slightly

- `ch10/ch10_panel_data.qmd:503-505`

Substantively the advice is fine for this course, but I would phrase it as:

- "In this class, if you are using panel data, cluster at the entity level unless there is a strong reason not to."

Why:

- "Always" is pedagogically useful, but students eventually encounter settings where the clustering decision is more nuanced.
- A slightly softer phrasing preserves the habit without overstating universality.

#### E. Consider moving the staggered-adoption section out of Chapter 10

- `ch10/ch10_panel_data.qmd:508-520`

This feels more natural in Chapter 10b, where you already explain it more fully and better.

## Chapter 10b: Difference-in-differences

### What is working well

- The "two flawed comparisons" section is excellent.
- The DiD animation is a strong addition.
- The distinction between levels and trends is well handled.
- The checklist at the end is useful and practical.

### Recommended changes

#### A. Add one line saying parallel trends is about untreated trends, not observed post-treatment trends

You already imply this well:

- `ch10b/ch10b_did.qmd:237-256`

I would make it even more explicit on the slide:

> Parallel trends is a statement about what would have happened without treatment.

That exact wording helps.

#### B. Be careful with the claim that Card-Krueger had "pre-trends"

- `ch10b/ch10b_did.qmd:368-373`

For a two-period classroom presentation, students can hear "pre-trends" as stronger evidence than the original design really offers in a simple 2x2 telling.

Recommendation:

- Rephrase to "neighboring states and same industry make parallel trends more plausible"
- If you want to mention pre-treatment evidence, be precise about where it comes from

#### C. Trim the event-study and staggered-adoption sections unless you have extra time

These sections are good, but they are a lot for an undergraduate first pass:

- `ch10b/ch10b_did.qmd:292-337`
- `ch10b/ch10b_did.qmd:393-526`

Default recommendation:

- keep event studies as one intuition slide plus one "what to look for" slide
- keep staggered adoption as a short caution box, not a long worked example, unless students are already very secure on basic DiD

Why:

- the core undergraduate win is understanding the 2x2 design and parallel trends
- the advanced material can crowd out the main conceptual objective

#### D. Change the Stata examples to cluster by default when the design is panel-based

Your simple 2x2 examples use `robust`:

- `ch10b/ch10b_did.qmd:532-549`

That is fine for a stripped-down cross-section representation, but I would annotate:

- for repeated cross-sections, robust may be fine depending on design
- for panel DiD, cluster at the entity level

This will help students avoid thinking `robust` and clustered SEs are interchangeable.

#### E. Add one "when DiD is a bad idea" slide

Suggested bullets:

- treatment starts because outcomes were already changing
- treated and control groups were already on different trajectories
- spillovers from treated to control units
- composition changes or selective migration after announcement

This would fit well after:

- `ch10b/ch10b_did.qmd:270-289`

## Chapter 12: Instrumental variables

### What is working well

- The chapter clearly motivates endogeneity.
- The cigarette-demand example is concrete and coherent.
- The first-stage/weak-instrument material is good.
- The applied examples are strong, especially the video-game instrument.

### Recommended changes

#### A. Move the randomized-roommate video-game example much earlier

Right now the most undergraduate-friendly IV example comes late:

- `ch12/ch12_instrumental_variables.qmd:731-776`

I would consider moving a version of it to the front, right after the endogeneity setup, before butter/cigarettes.

Why:

- students immediately grasp encouragement/random-assignment logic
- relevance and exclusion are easier to discuss in ordinary language
- it provides a simple bridge to Wald and 2SLS

Then butter/cigarettes can become the economics application rather than the first intuition.

#### B. Replace "three key characteristics" with "two core assumptions plus relevance"

- `ch12/ch12_instrumental_variables.qmd:13-17`
- `ch12/ch12_instrumental_variables.qmd:210-231`

Your current language is fine, but students often struggle to distinguish:

- exogeneity
- exclusion

I would explicitly teach:

- relevance: does Z move X?
- exclusion / validity: can Z affect Y in any way besides X?

You can then note that many texts split validity into exogeneity plus exclusion.

This usually reduces confusion.

#### C. Add a one-slide Wald estimator

There is currently no prominent Wald slide before 2SLS. That is the biggest pedagogical gap in the deck.

Suggested slide:

- instrument is binary
- first stage = treatment take-up difference by instrument
- reduced form = outcome difference by instrument
- Wald = reduced form / first stage

Suggested wording:

> The reduced form tells us how the instrument changes the outcome.  
> The first stage tells us how the instrument changes treatment.  
> Their ratio tells us the effect of treatment induced by the instrument.

That slide would fit naturally between:

- `ch12/ch12_instrumental_variables.qmd:283-303`
- `ch12/ch12_instrumental_variables.qmd:305-357`

#### D. Consider making the covariance derivation optional or backup

- `ch12/ch12_instrumental_variables.qmd:233-259`

I would keep it available, but possibly label it:

- "Optional derivation"
- "For intuition, the important point is the source of variation"

That lets stronger students see the algebra without making it the conceptual anchor.

#### E. Soften the cigarette-tax exogeneity claim

- `ch12/ch12_instrumental_variables.qmd:416-419`

I would revise "No obvious reason" to something like:

- "Plausible, but contestable: states with stronger anti-smoking preferences may both set higher taxes and have lower cigarette demand"

You do raise this concern later:

- `ch12/ch12_instrumental_variables.qmd:571-574`

But surfacing the challenge earlier would model better IV reasoning.

#### F. Clarify the weak-instrument rule of thumb

- `ch12/ch12_instrumental_variables.qmd:528-553`

I would keep `F > 10` as the classroom rule, but phrase it as:

- "A common rule of thumb is F greater than 10"

rather than a hard threshold. That is more accurate and still simple.

#### G. Tighten the LATE section

The LATE section is useful:

- `ch12/ch12_instrumental_variables.qmd:360-399`

But I would simplify it to:

- IV identifies the effect for compliers
- compliers are the people whose treatment status is changed by the instrument
- this may differ from the average effect for everyone

If you keep the current wording, I would add the word "compliers" explicitly. Students often retain the label.

#### H. Fix the logarithms explanation

- `ch12/ch12_instrumental_variables.qmd:694`

"Logarithms correct for inflation" is too strong as written. Logs do not themselves correct for inflation; deflation or fixed effects do that. Logs help with percentage interpretation and often stabilize scale.

I would revise to:

- "Using logs lets us interpret coefficients as elasticities, and with year fixed effects it also helps compare proportional changes over time."

## Nice add-on resources

### Best additions for Chapter 10b / DiD

- Nick Huntington-Klein DiD animation:
  - https://nickchk.com/anim/Animation%20of%20DID.gif
- Nick Huntington-Klein causal graphs/animations:
  - https://nickchk.com/causalgraphs.html
- Scott Cunningham Mixtape teaching tools:
  - https://mixtape.scunning.com/teaching_tools

### Best additions for Chapter 12 / IV

- Nick Huntington-Klein IV animation/videos:
  - https://nickchk.com/theeffectvideos.html
- DAGitty for showing exclusion violations:
  - https://dagitty.net/

## Suggested minimal edits if you only have time for a few changes

1. In Chapter 12, add a Wald-estimator slide and move the video-game example earlier.
2. In Chapter 10, reduce the full DiD treatment and reserve most of it for Chapter 10b.
3. In Chapter 10b, trim the staggered-adoption section to a short caution unless you have extra lecture time.
4. In Chapter 10, add one explicit visual slide for time fixed effects.
5. In Chapter 12, revise the logs/inflation wording and soften the cigarette-tax exogeneity claim.

