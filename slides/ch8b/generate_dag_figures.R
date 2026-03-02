# Generate DAG figures for Chapter 8b: Causal Diagrams and DAGs
# Output: PNG files in ./ch8b_figures/

library(ggdag)
library(ggplot2)
library(dagitty)
library(tibble)

# Set output directory
fig_dir <- "./ch8b_figures"
if (!dir.exists(fig_dir)) dir.create(fig_dir)

# ============================================================================
# Figure 1: Simple causal relationship (Class Size → Test Scores)
# ============================================================================

dag1 <- dagify(
  TestScores ~ ClassSize,
  coords = tibble(name = c("ClassSize", "TestScores"),
                  x = c(1, 2),
                  y = c(1, 1))
)

p1 <- dag1 %>%
  ggplot(aes(x = x, y = y, xend = xend, yend = yend)) +
  geom_dag_edges() +
  geom_dag_node(color = "lightblue", size = 8) +
  geom_dag_text(color = "black", size = 4) +
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

p2 <- dag2 %>%
  ggplot(aes(x = x, y = y, xend = xend, yend = yend)) +
  geom_dag_edges() +
  geom_dag_node(color = "lightblue", size = 8) +
  geom_dag_text(color = "black", size = 4) +
  theme_dag() +
  labs(title = "Confounding via Common Cause",
       subtitle = "Wealth confounds the Class Size → Test Scores relationship")

ggsave(file.path(fig_dir, "ch8b_confounding.png"),
       p2, width = 6, height = 4, dpi = 300)

# ============================================================================
# Figure 3: Collider Bias Example
# ============================================================================

dag3 <- dagify(
  JobHiring ~ Talent + Connections,
  coords = tibble(name = c("Talent", "Connections", "JobHiring"),
                  x = c(1, 2, 1.5),
                  y = c(1, 1, 0))
)

p3 <- dag3 %>%
  ggplot(aes(x = x, y = y, xend = xend, yend = yend)) +
  geom_dag_edges() +
  geom_dag_node(color = "lightcoral", size = 8) +
  geom_dag_text(color = "black", size = 4) +
  theme_dag() +
  labs(title = "Collider Bias",
       subtitle = "Controlling for Job Hiring creates a spurious relationship\nbetween Talent and Connections")

ggsave(file.path(fig_dir, "ch8b_collider.png"),
       p3, width = 6, height = 4, dpi = 300)

# ============================================================================
# Figure 4: Education, Ability, and Earnings (Unobserved Confounder)
# ============================================================================

dag4 <- dagify(
  Earnings ~ Education + Ability,
  Education ~ Ability,
  Ability ~ NA,  # Mark Ability as exogenous
  coords = tibble(name = c("Ability", "Education", "Earnings"),
                  x = c(1, 1.5, 2),
                  y = c(2, 1, 1))
)

p4 <- dag4 %>%
  ggplot(aes(x = x, y = y, xend = xend, yend = yend)) +
  geom_dag_edges() +
  geom_dag_node(aes(fill = ifelse(name == "Ability", "Unobserved", "Observed")),
                size = 8, color = "black") +
  geom_dag_text(color = "white", size = 4, fontface = "bold") +
  scale_fill_manual(values = c("Observed" = "lightblue", "Unobserved" = "lightgray")) +
  theme_dag() +
  theme(legend.position = "none") +
  labs(title = "Unobserved Confounding",
       subtitle = "Ability confounds the Education → Earnings relationship\n(and we can't directly control for it)")

ggsave(file.path(fig_dir, "ch8b_unobserved_confounder.png"),
       p4, width = 6, height = 4, dpi = 300)

# ============================================================================
# Figure 5: Randomized Experiment (RCT breaks confounding)
# ============================================================================

dag5 <- dagify(
  Outcome ~ Treatment + Motivation,
  Motivation ~ NA,  # Exogenous (random assignment breaks the link)
  coords = tibble(name = c("Treatment", "Motivation", "Outcome"),
                  x = c(1, 2, 1.5),
                  y = c(1, 1, 0))
)

p5 <- dag5 %>%
  ggplot(aes(x = x, y = y, xend = xend, yend = yend)) +
  geom_dag_edges() +
  geom_dag_node(color = "lightgreen", size = 8) +
  geom_dag_text(color = "black", size = 4) +
  theme_dag() +
  labs(title = "Randomized Experiment",
       subtitle = "Random assignment of Treatment breaks confounding\n(Treatment is no longer caused by Motivation)")

ggsave(file.path(fig_dir, "ch8b_rct.png"),
       p5, width = 6, height = 4, dpi = 300)

# ============================================================================
# Figure 6: Health Insurance Example
# ============================================================================

dag6 <- dagify(
  Health ~ HealthInsurance + Income,
  HealthInsurance ~ Income,
  coords = tibble(name = c("Income", "HealthInsurance", "Health"),
                  x = c(1, 1.5, 2),
                  y = c(2, 1, 1))
)

p6 <- dag6 %>%
  ggplot(aes(x = x, y = y, xend = xend, yend = yend)) +
  geom_dag_edges() +
  geom_dag_node(color = "lightyellow", size = 8) +
  geom_dag_text(color = "black", size = 4) +
  theme_dag() +
  labs(title = "Knowledge Check: Health Insurance",
       subtitle = "Does Income confound the relationship?")

ggsave(file.path(fig_dir, "ch8b_knowledge_check_1.png"),
       p6, width = 6, height = 4, dpi = 300)

# ============================================================================
# Figure 7: Complex DAG (SES, Education, Connections, Earnings)
# ============================================================================

dag7 <- dagify(
  Earnings ~ SES + Education + FamilyConnections,
  Education ~ SES,
  FamilyConnections ~ SES,
  coords = tibble(name = c("SES", "Education", "FamilyConnections", "Earnings"),
                  x = c(1, 1.5, 1.5, 2.5),
                  y = c(2, 1.5, 0.5, 1))
)

p7 <- dag7 %>%
  ggplot(aes(x = x, y = y, xend = xend, yend = yend)) +
  geom_dag_edges() +
  geom_dag_node(color = "plum", size = 8) +
  geom_dag_text(color = "black", size = 3.5) +
  theme_dag() +
  labs(title = "Complex DAG: SES and Earnings",
       subtitle = "Multiple paths, confounding, and mediation")

ggsave(file.path(fig_dir, "ch8b_complex_dag.png"),
       p7, width = 7, height = 5, dpi = 300)

# ============================================================================
# Figure 8: Backdoor vs Causal Path
# ============================================================================

dag8 <- dagify(
  Y ~ X + Z,
  X ~ Z,
  coords = tibble(name = c("Z", "X", "Y"),
                  x = c(0.5, 1.5, 2.5),
                  y = c(1.5, 1, 0.5))
)

p8 <- dag8 %>%
  ggplot(aes(x = x, y = y, xend = xend, yend = yend)) +
  geom_dag_edges(edge_width = 1) +
  geom_dag_node(color = "lightsteelblue", size = 8) +
  geom_dag_text(color = "black", size = 4) +
  theme_dag() +
  labs(title = "Backdoor Path",
       subtitle = "Z creates a backdoor path: X ← Z → Y")

ggsave(file.path(fig_dir, "ch8b_backdoor_path.png"),
       p8, width = 6, height = 4, dpi = 300)

# ============================================================================
# Summary
# ============================================================================

cat("\n✓ DAG figures generated and saved to", fig_dir, "\n")
cat("  Figures created:\n")
cat("  1. ch8b_simple_causal.png\n")
cat("  2. ch8b_confounding.png\n")
cat("  3. ch8b_collider.png\n")
cat("  4. ch8b_unobserved_confounder.png\n")
cat("  5. ch8b_rct.png\n")
cat("  6. ch8b_knowledge_check_1.png\n")
cat("  7. ch8b_complex_dag.png\n")
cat("  8. ch8b_backdoor_path.png\n")
cat("\n✓ Ready to render slides!\n")
