# Generate DAG figures for Chapter 8b: Causal Diagrams and DAGs
# Output: PNG files in ./ch8b_figures/

library(ggdag)
library(ggplot2)
library(dagitty)

# Set output directory
fig_dir <- "./ch8b_figures"
if (!dir.exists(fig_dir)) dir.create(fig_dir)

# Theme for clean, readable DAGs
theme_dag <- function() {
  theme_dag_blank() +
    theme(
      plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
      plot.subtitle = element_text(size = 11, hjust = 0.5)
    )
}

# ============================================================================
# Figure 1: Simple causal relationship (Class Size → Test Scores)
# ============================================================================

dag1 <- dagify(
  TestScores ~ ClassSize,
  coords = tibble(name = c("ClassSize", "TestScores"),
                  x = c(1, 2),
                  y = c(1, 1))
)

p1 <- ggdag(dag1, layout = "custom", use_labels = "label") +
  theme_dag() +
  labs(title = "Simple Causal Effect",
       subtitle = "Class Size → Test Scores")

ggsave(file.path(fig_dir, "ch8b_simple_causal.png"),
       p1, width = 6, height = 4, dpi = 300)

# ============================================================================
# Figure 2: Confounding (Class Size example)
# ============================================================================

dag2 <- dagify(
  TestScores ~ ClassSize + Wealth,
  ClassSize ~ Wealth,
  coords = tibble(name = c("Wealth", "ClassSize", "TestScores"),
                  x = c(1, 1.5, 2),
                  y = c(2, 1, 1))
)

p2 <- ggdag(dag2, layout = "custom", use_labels = "label") +
  theme_dag() +
  labs(title = "Confounding via Common Cause",
       subtitle = "Wealth confounds the Class Size → Test Scores relationship")

ggsave(file.path(fig_dir, "ch8b_confounding.png"),
       p2, width = 6, height = 4, dpi = 300)

# ============================================================================
# Figure 3: Blocking the backdoor path (controlling for Wealth)
# ============================================================================

dag3 <- dagify(
  TestScores ~ ClassSize + Wealth,
  ClassSize ~ Wealth,
  coords = tibble(name = c("Wealth", "ClassSize", "TestScores"),
                  x = c(1, 1.5, 2),
                  y = c(2, 1, 1))
)

p3 <- ggdag_paths(dag3, from = "ClassSize", to = "TestScores",
                  layout = "custom", use_labels = "label") +
  theme_dag() +
  labs(title = "Blocking the Backdoor Path",
       subtitle = "Control for Wealth to isolate the causal effect of Class Size")

ggsave(file.path(fig_dir, "ch8b_blocking_backdoor.png"),
       p3, width = 6, height = 4, dpi = 300)

# ============================================================================
# Figure 4: Education, Ability, and Earnings (Unobserved Confounder)
# ============================================================================

dag4 <- dagify(
  Earnings ~ Education + Ability,
  Education ~ Ability,
  Ability ~ NA,  # Mark Ability as unobserved
  coords = tibble(name = c("Ability", "Education", "Earnings"),
                  x = c(1, 1.5, 2),
                  y = c(2, 1, 1))
)

p4 <- ggdag(dag4, layout = "custom", use_labels = "label") +
  theme_dag() +
  labs(title = "Unobserved Confounding",
       subtitle = "Ability confounds the Education → Earnings relationship\n(and we can't directly control for it)")

ggsave(file.path(fig_dir, "ch8b_unobserved_confounder.png"),
       p4, width = 6, height = 4, dpi = 300)

# ============================================================================
# Figure 5: Collider Bias Example
# ============================================================================

dag5 <- dagify(
  JobHiring ~ Talent + Connections,
  coords = tibble(name = c("Talent", "Connections", "JobHiring"),
                  x = c(1, 2, 1.5),
                  y = c(1, 1, 0))
)

p5 <- ggdag(dag5, layout = "custom", use_labels = "label") +
  theme_dag() +
  labs(title = "Collider Bias",
       subtitle = "Controlling for JobHiring creates a spurious relationship\nbetween Talent and Connections")

ggsave(file.path(fig_dir, "ch8b_collider.png"),
       p5, width = 6, height = 4, dpi = 300)

# ============================================================================
# Figure 6: Randomized Experiment (RCT breaks confounding)
# ============================================================================

dag6 <- dagify(
  Outcome ~ Treatment + Motivation,
  Motivation ~ NA,  # Exogenous
  coords = tibble(name = c("Treatment", "Motivation", "Outcome"),
                  x = c(1, 2, 1.5),
                  y = c(1, 1, 0))
)

p6 <- ggdag(dag6, layout = "custom", use_labels = "label") +
  theme_dag() +
  labs(title = "Randomized Experiment",
       subtitle = "Random assignment of Treatment breaks confounding\n(Treatment is no longer caused by Motivation)")

ggsave(file.path(fig_dir, "ch8b_rct.png"),
       p6, width = 6, height = 4, dpi = 300)

# ============================================================================
# Figure 7: Knowledge Check Example (Health Insurance)
# ============================================================================

dag7 <- dagify(
  Health ~ HealthInsurance + Income,
  HealthInsurance ~ Income,
  coords = tibble(name = c("Income", "HealthInsurance", "Health"),
                  x = c(1, 1.5, 2),
                  y = c(2, 1, 1))
)

p7 <- ggdag(dag7, layout = "custom", use_labels = "label") +
  theme_dag() +
  labs(title = "Knowledge Check: Health Insurance",
       subtitle = "Does Income confound the relationship?")

ggsave(file.path(fig_dir, "ch8b_knowledge_check_1.png"),
       p7, width = 6, height = 4, dpi = 300)

# ============================================================================
# Figure 8: Complex DAG (SES, Education, Connections, Earnings)
# ============================================================================

dag8 <- dagify(
  Earnings ~ SES + Education + FamilyConnections,
  Education ~ SES,
  FamilyConnections ~ SES,
  coords = tibble(name = c("SES", "Education", "FamilyConnections", "Earnings"),
                  x = c(1, 1.5, 1.5, 2.5),
                  y = c(2, 1.5, 0.5, 1))
)

p8 <- ggdag(dag8, layout = "custom", use_labels = "label") +
  theme_dag() +
  labs(title = "Complex DAG: SES and Earnings",
       subtitle = "Multiple paths, confounding, and mediation")

ggsave(file.path(fig_dir, "ch8b_complex_dag.png"),
       p8, width = 7, height = 5, dpi = 300)

# ============================================================================
# Summary
# ============================================================================

cat("\n✓ DAG figures generated and saved to", fig_dir, "\n")
cat("  Figures:\n")
cat("  - ch8b_simple_causal.png\n")
cat("  - ch8b_confounding.png\n")
cat("  - ch8b_blocking_backdoor.png\n")
cat("  - ch8b_unobserved_confounder.png\n")
cat("  - ch8b_collider.png\n")
cat("  - ch8b_rct.png\n")
cat("  - ch8b_knowledge_check_1.png\n")
cat("  - ch8b_complex_dag.png\n")
