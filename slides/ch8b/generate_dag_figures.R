# Generate DAG figures for Chapter 8b: Causal Diagrams and DAGs
# Output: PNG files in ./ch8b_figures/
# All figures: no titles/subtitles, course color palette, clean for slide embedding

library(ggdag)
library(ggplot2)
library(dagitty)
library(tibble)

fig_dir <- "./ch8b_figures"
if (!dir.exists(fig_dir)) dir.create(fig_dir)

# Course color palette (matches custom-econometria.scss)
eco_navy <- "#19375F"
eco_teal <- "#008080"
eco_gold <- "#B8860B"
eco_silver <- "#708090"

# Standard node styling
node_color <- eco_teal
node_text_color <- "white"
node_sz <- 22
text_sz <- 4
edge_w <- 0.8
fig_bg <- "#D6DEE6"  # medium blue-gray background for slide readability

theme_dag_clean <- function() {
  theme_dag() +
    theme(
      plot.background = element_rect(fill = fig_bg, color = NA),
      panel.background = element_rect(fill = fig_bg, color = NA),
      plot.margin = margin(10, 10, 10, 10)
    )
}

# Add padding around nodes so larger sizes don't get clipped
dag_expand <- function() {
  list(
    scale_x_continuous(expand = expansion(mult = 0.2)),
    scale_y_continuous(expand = expansion(mult = 0.2)),
    coord_cartesian(clip = "off")
  )
}

# ============================================================================
# Figure 1: Simple causal relationship (Class Size -> Test Scores)
# ============================================================================

dag1 <- dagify(
  TestScores ~ ClassSize,
  labels = c("ClassSize" = "Class\nSize", "TestScores" = "Test\nScores"),
  coords = tibble(name = c("ClassSize", "TestScores"),
                  x = c(1, 3), y = c(1, 1))
)

p1 <- ggplot(tidy_dagitty(dag1), aes(x = x, y = y, xend = xend, yend = yend)) +
  geom_dag_edges(edge_width = edge_w) +
  geom_dag_node(color = node_color, size = node_sz) +
  geom_dag_text(aes(label = label), color = node_text_color,
                size = text_sz, lineheight = 0.85) +
  theme_dag_clean() +
  dag_expand()

ggsave(file.path(fig_dir, "ch8b_simple_causal.png"),
       p1, width = 5, height = 2.5, dpi = 300, bg = fig_bg)

# ============================================================================
# Figure 2: Confounding (Class Size example with Wealth)
# ============================================================================

dag2 <- dagify(
  TestScores ~ ClassSize + Wealth,
  ClassSize ~ Wealth,
  labels = c("Wealth" = "Wealth",
             "ClassSize" = "Class\nSize",
             "TestScores" = "Test\nScores"),
  coords = tibble(name = c("Wealth", "ClassSize", "TestScores"),
                  x = c(2, 1, 3), y = c(2, 1, 1))
)

p2 <- ggplot(tidy_dagitty(dag2), aes(x = x, y = y, xend = xend, yend = yend)) +
  geom_dag_edges(edge_width = edge_w) +
  geom_dag_node(color = node_color, size = node_sz) +
  geom_dag_text(aes(label = label), color = node_text_color,
                size = text_sz, lineheight = 0.85) +
  theme_dag_clean() +
  dag_expand()

ggsave(file.path(fig_dir, "ch8b_confounding.png"),
       p2, width = 5, height = 3.5, dpi = 300, bg = fig_bg)

# ============================================================================
# Figure 3: Collider Bias (Talent, Connections -> Job Hiring)
# Gold nodes to signal warning
# ============================================================================

dag3 <- dagify(
  Hiring ~ Talent + Connections,
  labels = c("Talent" = "Talent",
             "Connections" = "Connections",
             "Hiring" = "Job\nHiring"),
  coords = tibble(name = c("Talent", "Connections", "Hiring"),
                  x = c(1, 3, 2), y = c(2, 2, 1))
)

p3 <- ggplot(tidy_dagitty(dag3), aes(x = x, y = y, xend = xend, yend = yend)) +
  geom_dag_edges(edge_width = edge_w) +
  geom_dag_node(color = eco_gold, size = node_sz) +
  geom_dag_text(aes(label = label), color = "white",
                size = text_sz, lineheight = 0.85) +
  theme_dag_clean() +
  dag_expand()

ggsave(file.path(fig_dir, "ch8b_collider.png"),
       p3, width = 5, height = 3.5, dpi = 300, bg = fig_bg)

# ============================================================================
# Figure 4: Unobserved Confounder (Education, Ability, Earnings)
# Ability node in silver (unobserved), others in teal
# ============================================================================

dag4 <- dagify(
  Earnings ~ Education + Ability,
  Education ~ Ability,
  labels = c("Ability" = "Ability",
             "Education" = "Education",
             "Earnings" = "Earnings"),
  coords = tibble(name = c("Ability", "Education", "Earnings"),
                  x = c(2, 1, 3), y = c(2, 1, 1))
)

p4 <- ggplot(tidy_dagitty(dag4), aes(x = x, y = y, xend = xend, yend = yend)) +
  geom_dag_edges(edge_width = edge_w) +
  geom_dag_node(aes(colour = name), size = node_sz) +
  scale_colour_manual(values = c("Ability" = eco_silver,
                                 "Education" = node_color,
                                 "Earnings" = node_color)) +
  geom_dag_text(aes(label = label), color = node_text_color,
                size = text_sz, lineheight = 0.85, fontface = "bold") +
  theme_dag_clean() +
  theme(legend.position = "none") +
  # Extra padding for this figure — nodes clip at default expansion
  scale_x_continuous(expand = expansion(mult = 0.4)) +
  scale_y_continuous(expand = expansion(mult = 0.3)) +
  coord_cartesian(clip = "off")

ggsave(file.path(fig_dir, "ch8b_unobserved_confounder.png"),
       p4, width = 6, height = 4, dpi = 300, bg = fig_bg)

# ============================================================================
# Figure 5: RCT — Job Training Example
# After randomization: no arrow from Motivation to Training
# ============================================================================

dag5 <- dagify(
  Employment ~ Training + Motivation,
  labels = c("Training" = "Job\nTraining",
             "Motivation" = "Motivation",
             "Employment" = "Employ."),
  coords = tibble(name = c("Training", "Motivation", "Employment"),
                  x = c(1, 3, 2), y = c(1, 1, 0))
)

p5 <- ggplot(tidy_dagitty(dag5), aes(x = x, y = y, xend = xend, yend = yend)) +
  geom_dag_edges(edge_width = edge_w) +
  geom_dag_node(color = "#2E8B57", size = node_sz) +
  geom_dag_text(aes(label = label), color = "white",
                size = text_sz, lineheight = 0.85) +
  theme_dag_clean() +
  dag_expand()

ggsave(file.path(fig_dir, "ch8b_rct.png"),
       p5, width = 5, height = 3, dpi = 300, bg = fig_bg)

# ============================================================================
# Figure 6: Health Insurance / Income / Health (Knowledge Check 1)
# No title, clean labels with spaces
# ============================================================================

dag6 <- dagify(
  Health ~ Insurance + Income,
  Insurance ~ Income,
  labels = c("Income" = "Income",
             "Insurance" = "Health\nInsurance",
             "Health" = "Health"),
  coords = tibble(name = c("Income", "Insurance", "Health"),
                  x = c(2, 1, 3), y = c(2, 1, 1))
)

p6 <- ggplot(tidy_dagitty(dag6), aes(x = x, y = y, xend = xend, yend = yend)) +
  geom_dag_edges(edge_width = edge_w) +
  geom_dag_node(color = node_color, size = node_sz) +
  geom_dag_text(aes(label = label), color = node_text_color,
                size = text_sz, lineheight = 0.85) +
  theme_dag_clean() +
  dag_expand()

ggsave(file.path(fig_dir, "ch8b_knowledge_check_1.png"),
       p6, width = 5, height = 3.5, dpi = 300, bg = fig_bg)

# ============================================================================
# Figure 7: Complex DAG (SES, Education, Family Connections, Earnings)
# ============================================================================

dag7 <- dagify(
  Earnings ~ SES + Education + FamConn,
  Education ~ SES,
  FamConn ~ SES,
  labels = c("SES" = "SES",
             "Education" = "Education",
             "FamConn" = "Family\nConnections",
             "Earnings" = "Earnings"),
  coords = tibble(name = c("SES", "Education", "FamConn", "Earnings"),
                  x = c(1, 1.5, 1.5, 3),
                  y = c(1.5, 2, 1, 1.5))
)

p7 <- ggplot(tidy_dagitty(dag7), aes(x = x, y = y, xend = xend, yend = yend)) +
  geom_dag_edges(edge_width = edge_w) +
  geom_dag_node(color = node_color, size = node_sz) +
  geom_dag_text(aes(label = label), color = node_text_color,
                size = 3.2, lineheight = 0.85) +
  theme_dag_clean() +
  dag_expand()

ggsave(file.path(fig_dir, "ch8b_complex_dag.png"),
       p7, width = 6, height = 4, dpi = 300, bg = fig_bg)

# ============================================================================
# Figure 8: Generic Backdoor Path (X <- Z -> Y)
# ============================================================================

dag8 <- dagify(
  Y ~ X + Z,
  X ~ Z,
  coords = tibble(name = c("Z", "X", "Y"),
                  x = c(2, 1, 3), y = c(2, 1, 1))
)

p8 <- ggplot(tidy_dagitty(dag8), aes(x = x, y = y, xend = xend, yend = yend)) +
  geom_dag_edges(edge_width = edge_w) +
  geom_dag_node(color = node_color, size = node_sz) +
  geom_dag_text(color = node_text_color, size = text_sz + 1) +
  theme_dag_clean() +
  dag_expand()

ggsave(file.path(fig_dir, "ch8b_backdoor_path.png"),
       p8, width = 5, height = 3.5, dpi = 300, bg = fig_bg)

# ============================================================================
# Figure 9: Reverse Causation (Police and Crime)
# Two competing arrows shown via two separate panels
# ============================================================================

dag9a <- dagify(
  Crime ~ Police,
  labels = c("Police" = "Police", "Crime" = "Crime"),
  coords = tibble(name = c("Police", "Crime"),
                  x = c(1, 3), y = c(1, 1))
)

dag9b <- dagify(
  Police ~ Crime,
  labels = c("Police" = "Police", "Crime" = "Crime"),
  coords = tibble(name = c("Police", "Crime"),
                  x = c(1, 3), y = c(1, 1))
)

p9a <- ggplot(tidy_dagitty(dag9a), aes(x = x, y = y, xend = xend, yend = yend)) +
  geom_dag_edges(edge_width = edge_w) +
  geom_dag_node(color = node_color, size = node_sz) +
  geom_dag_text(aes(label = label), color = node_text_color, size = text_sz) +
  theme_dag_clean() +
  ggtitle("Hypothesis: Police reduce crime")

p9b <- ggplot(tidy_dagitty(dag9b), aes(x = x, y = y, xend = xend, yend = yend)) +
  geom_dag_edges(edge_width = edge_w) +
  geom_dag_node(color = eco_gold, size = node_sz) +
  geom_dag_text(aes(label = label), color = "white", size = text_sz) +
  theme_dag_clean() +
  ggtitle("Reverse causation: Crime causes hiring")

library(cowplot)
p9 <- plot_grid(p9a, p9b, ncol = 2)

ggsave(file.path(fig_dir, "ch8b_reverse_causation.png"),
       p9, width = 8, height = 3, dpi = 300, bg = fig_bg)

# ============================================================================
# Figure 10: Measurement Error
# True Ability (unobserved) vs Test Score (proxy, observed)
# ============================================================================

dag10 <- dagify(
  Earnings ~ Education + Ability,
  Education ~ Ability,
  TestScore ~ Ability,
  labels = c("Ability" = "Ability\n(true)",
             "Education" = "Education",
             "Earnings" = "Earnings",
             "TestScore" = "Test Score\n(proxy)"),
  coords = tibble(name = c("Ability", "Education", "Earnings", "TestScore"),
                  x = c(2, 1, 3, 2), y = c(2.2, 1, 1, 0.5))
)

p10 <- ggplot(tidy_dagitty(dag10), aes(x = x, y = y, xend = xend, yend = yend)) +
  geom_dag_edges(edge_width = edge_w) +
  geom_dag_node(aes(colour = name), size = node_sz) +
  scale_colour_manual(values = c("Ability" = eco_silver,
                                 "Education" = node_color,
                                 "Earnings" = node_color,
                                 "TestScore" = node_color)) +
  geom_dag_text(aes(label = label), color = node_text_color,
                size = 3, lineheight = 0.85, fontface = "bold") +
  theme_dag_clean() +
  theme(legend.position = "none")

ggsave(file.path(fig_dir, "ch8b_measurement_error.png"),
       p10, width = 5, height = 4, dpi = 300, bg = fig_bg)

# ============================================================================
# Figure 11: Wine and Heart Health (Worksheet)
# Multiple confounders: Income, Diet, Social Activity
# ============================================================================

dag11 <- dagify(
  HeartHealth ~ Wine + Income + Diet + SocialAct,
  Wine ~ Income + SocialAct,
  Diet ~ Income,
  labels = c("Wine" = "Wine",
             "HeartHealth" = "Heart\nHealth",
             "Income" = "Income",
             "Diet" = "Diet",
             "SocialAct" = "Social\nActivity"),
  coords = tibble(name = c("Wine", "HeartHealth", "Income", "Diet", "SocialAct"),
                  x = c(1, 4, 2.5, 3.5, 1),
                  y = c(1, 1, 2.2, 2.2, 2.2))
)

p11 <- ggplot(tidy_dagitty(dag11), aes(x = x, y = y, xend = xend, yend = yend)) +
  geom_dag_edges(edge_width = edge_w) +
  geom_dag_node(color = node_color, size = node_sz) +
  geom_dag_text(aes(label = label), color = node_text_color,
                size = 3.2, lineheight = 0.85) +
  theme_dag_clean() +
  dag_expand()

ggsave(file.path(fig_dir, "ch8b_wine_health.png"),
       p11, width = 7, height = 4, dpi = 300, bg = fig_bg)

# ============================================================================
# Summary
# ============================================================================

cat("\n Done. DAG figures saved to", fig_dir, "\n")
cat("  Figures created:\n")
cat("  1. ch8b_simple_causal.png\n")
cat("  2. ch8b_confounding.png\n")
cat("  3. ch8b_collider.png\n")
cat("  4. ch8b_unobserved_confounder.png\n")
cat("  5. ch8b_rct.png\n")
cat("  6. ch8b_knowledge_check_1.png\n")
cat("  7. ch8b_complex_dag.png\n")
cat("  8. ch8b_backdoor_path.png\n")
cat("  9. ch8b_reverse_causation.png\n")
cat(" 10. ch8b_measurement_error.png\n")
cat(" 11. ch8b_wine_health.png\n")
