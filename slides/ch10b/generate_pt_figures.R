# Generate Parallel Trends figures for ch10b slides
# Run from: slides/ch10b/

library(ggplot2)

# Color palette matching Econometria theme
eco_navy <- "#19375F"
eco_teal <- "#008080"
eco_gold <- "#B8860B"
eco_alert <- "#D32F2F"

theme_econometria <- theme_minimal(base_size = 16) +
  theme(
    plot.title = element_text(color = eco_navy, face = "bold", size = 18),
    plot.subtitle = element_text(color = "#708090", size = 13),
    axis.title = element_text(color = eco_navy, face = "bold"),
    axis.text = element_text(color = "#333333"),
    legend.position = "bottom",
    legend.title = element_blank(),
    legend.text = element_text(size = 13),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(color = "#E0E0E0"),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA)
  )

# ── Figure 1: Parallel trends HOLDS ──────────────────────────

# Pre-treatment: both groups follow parallel paths
# Post-treatment: treatment group diverges
pre_t <- 1:5
post_t <- 6:8

df_holds <- data.frame(
  time = rep(1:8, 3),
  outcome = c(
    # Control group: steady upward trend
    10, 12, 14, 16, 18, 20, 22, 24,
    # Treatment group: parallel before, diverges after
    6, 8, 10, 12, 14, 18, 22, 26,
    # Counterfactual: what treatment would have been
    6, 8, 10, 12, 14, 16, 18, 20
  ),
  group = rep(c("Control", "Treatment", "Counterfactual"), each = 8)
)

# Treatment effect annotation
te_y_actual <- c(18, 22, 26)
te_y_cf <- c(16, 18, 20)

p1 <- ggplot() +
  # Counterfactual (dashed) - only post-treatment
  geom_line(data = subset(df_holds, group == "Counterfactual" & time >= 5),
            aes(x = time, y = outcome), linetype = "dashed",
            color = eco_teal, linewidth = 1, alpha = 0.6) +
  # Control group
  geom_line(data = subset(df_holds, group == "Control"),
            aes(x = time, y = outcome, color = "Control"), linewidth = 1.3) +
  geom_point(data = subset(df_holds, group == "Control"),
             aes(x = time, y = outcome, color = "Control"), size = 3) +
  # Treatment group
  geom_line(data = subset(df_holds, group == "Treatment"),
            aes(x = time, y = outcome, color = "Treatment"), linewidth = 1.3) +
  geom_point(data = subset(df_holds, group == "Treatment"),
             aes(x = time, y = outcome, color = "Treatment"), size = 3) +
  # Treatment effect arrows
  annotate("segment", x = 7, xend = 7, y = te_y_cf[2], yend = te_y_actual[2],
           arrow = arrow(length = unit(0.15, "inches"), ends = "both"),
           color = eco_alert, linewidth = 1) +
  annotate("text", x = 7.4, y = mean(c(te_y_cf[2], te_y_actual[2])),
           label = "Treatment\neffect", color = eco_alert, fontface = "bold",
           size = 4, hjust = 0) +
  # Treatment timing line
  geom_vline(xintercept = 5.5, linetype = "dotted", color = "#708090", linewidth = 0.8) +
  annotate("text", x = 5.5, y = 27, label = "Treatment", color = "#708090",
           size = 3.5, hjust = -0.1) +
  # Styling
  scale_color_manual(values = c("Control" = eco_navy, "Treatment" = eco_teal)) +
  scale_x_continuous(breaks = 1:8, labels = paste0("t", 1:8)) +
  labs(title = "Parallel Trends Holds",
       subtitle = "Groups follow same trajectory before treatment",
       x = "Time", y = "Outcome") +
  theme_econometria +
  coord_cartesian(ylim = c(4, 28))

ggsave("ch10b_figures/ch10b_parallel_holds.png", p1,
       width = 7, height = 5, dpi = 200, bg = "white")


# ── Figure 2: Parallel trends VIOLATED ───────────────────────

df_violated <- data.frame(
  time = rep(1:8, 3),
  outcome = c(
    # Control group: steady upward trend
    10, 12, 14, 16, 18, 20, 22, 24,
    # Treatment group: converging before, appears to diverge after
    2, 5, 8, 11, 14, 18, 22, 26,
    # False counterfactual (what researcher assumes - parallel)
    2, 5, 8, 11, 14, 16, 18, 20
  ),
  group = rep(c("Control", "Treatment", "False counterfactual"), each = 8)
)

# True counterfactual (continuing convergence trend)
df_true_cf <- data.frame(
  time = 5:8,
  outcome = c(14, 17, 20, 23)  # convergence continues
)

p2 <- ggplot() +
  # False counterfactual (dashed, what parallel trends would predict)
  geom_line(data = subset(df_violated, group == "False counterfactual" & time >= 5),
            aes(x = time, y = outcome), linetype = "dashed",
            color = eco_teal, linewidth = 1, alpha = 0.4) +
  # True counterfactual (dotted)
  geom_line(data = df_true_cf, aes(x = time, y = outcome),
            linetype = "dotted", color = eco_gold, linewidth = 1.2) +
  # Control group
  geom_line(data = subset(df_violated, group == "Control"),
            aes(x = time, y = outcome, color = "Control"), linewidth = 1.3) +
  geom_point(data = subset(df_violated, group == "Control"),
             aes(x = time, y = outcome, color = "Control"), size = 3) +
  # Treatment group
  geom_line(data = subset(df_violated, group == "Treatment"),
            aes(x = time, y = outcome, color = "Treatment"), linewidth = 1.3) +
  geom_point(data = subset(df_violated, group == "Treatment"),
             aes(x = time, y = outcome, color = "Treatment"), size = 3) +
  # Overstated effect bracket
  annotate("segment", x = 7, xend = 7, y = 18, yend = 22,
           arrow = arrow(length = unit(0.15, "inches"), ends = "both"),
           color = eco_alert, linewidth = 1) +
  annotate("text", x = 7.4, y = 20,
           label = "Overstated\n\"effect\"", color = eco_alert, fontface = "bold",
           size = 4, hjust = 0) +
  # True (smaller) effect
  annotate("segment", x = 6.5, xend = 6.5, y = 17, yend = 18,
           arrow = arrow(length = unit(0.1, "inches"), ends = "both"),
           color = eco_gold, linewidth = 0.8) +
  annotate("text", x = 5.7, y = 17.5,
           label = "True\neffect", color = eco_gold, fontface = "bold",
           size = 3.5, hjust = 1) +
  # Treatment timing line
  geom_vline(xintercept = 5.5, linetype = "dotted", color = "#708090", linewidth = 0.8) +
  annotate("text", x = 5.5, y = 27, label = "Treatment", color = "#708090",
           size = 3.5, hjust = -0.1) +
  # Convergence annotation
  annotate("text", x = 3, y = 20, label = "Groups were\nalready converging",
           color = "#708090", fontface = "italic", size = 3.5) +
  # Styling
  scale_color_manual(values = c("Control" = eco_navy, "Treatment" = eco_teal)) +
  scale_x_continuous(breaks = 1:8, labels = paste0("t", 1:8)) +
  labs(title = "Parallel Trends Violated",
       subtitle = "Groups were converging before treatment — DiD overstates the effect",
       x = "Time", y = "Outcome") +
  theme_econometria +
  coord_cartesian(ylim = c(0, 28))

ggsave("ch10b_figures/ch10b_parallel_violated.png", p2,
       width = 7, height = 5, dpi = 200, bg = "white")

cat("Figures saved to ch10b_figures/\n")
