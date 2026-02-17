################################################################################
# ECON3500 - Multiple Regression Visualizations (Chapter 6)
# Generates PNG figures for Ch6 Quarto slides.
# Run from slides/ch6/ (e.g. Rscript generate_ch6_figures.R)
# Outputs: slides/ch6/ch6_figures/ch6_*.png
################################################################################

options(repos = c(CRAN = "https://cloud.r-project.org"))

if (!require("ggplot2")) install.packages("ggplot2")
if (!require("gridExtra")) install.packages("gridExtra")
if (!require("grid")) install.packages("grid")
if (!require("scales")) install.packages("scales")
if (!require("dplyr")) install.packages("dplyr")
if (!require("tidyr")) install.packages("tidyr")

library(ggplot2)
library(gridExtra)
library(grid)
library(scales)
library(dplyr)
library(tidyr)

# Set working directory to script directory so paths work when run from anywhere
script_dir <- function() {
  args <- commandArgs(trailingOnly = FALSE)
  f <- "--file="
  path <- sub(f, "", args[grepl(f, args)])
  if (length(path)) dirname(normalizePath(path)) else "."
}
tryCatch(setwd(script_dir()), error = function(e) NULL)

if (!dir.exists("ch6_figures")) dir.create("ch6_figures")
fig_dir <- "ch6_figures"

theme_econometria <- function() {
  theme_minimal() +
    theme(
      plot.title = element_text(hjust = 0.5, size = 14, face = "bold", color = "#19375F"),
      plot.subtitle = element_text(hjust = 0.5, size = 10, color = "#708090"),
      axis.title = element_text(size = 11, color = "#36454F"),
      axis.text = element_text(size = 9, color = "#36454F"),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(color = "gray90", linewidth = 0.3),
      legend.position = "none",
      plot.background = element_rect(fill = "white", color = NA),
      panel.background = element_rect(fill = "white", color = NA)
    )
}

eco_deep_blue <- "#19375F"
eco_teal <- "#008080"
eco_gold <- "#B8860B"
eco_silver <- "#708090"

################################################################################
# FIGURE 1: Omitted Variable Bias
################################################################################
set.seed(12345)
n_ovb <- 200
X1 <- runif(n_ovb, 0, 10)
X2 <- 3 + 0.6*X1 + rnorm(n_ovb, 0, 2)
Y <- 10 + 2*X1 + 3*X2 + rnorm(n_ovb, 0, 5)
model_true <- lm(Y ~ X1 + X2)
beta1_true <- coef(model_true)[2]
model_omit <- lm(Y ~ X1)
beta1_omit <- coef(model_omit)[2]
df_ovb <- data.frame(X1 = X1, X2 = X2, Y = Y)

p1 <- ggplot(df_ovb, aes(x = X1, y = Y)) +
  geom_point(alpha = 0.4, size = 2, color = eco_teal) +
  geom_abline(intercept = coef(model_true)[1] + coef(model_true)[3]*mean(X2),
              slope = beta1_true, color = eco_deep_blue, linewidth = 1.2, linetype = "solid") +
  geom_abline(intercept = coef(model_omit)[1], slope = beta1_omit,
              color = eco_gold, linewidth = 1.2, linetype = "dashed") +
  annotate("text", x = 2, y = 90,
           label = sprintf("True model: β1 = %.2f\n(controlling for X2)", beta1_true),
           hjust = 0, size = 4, color = eco_deep_blue, fontface = "bold") +
  annotate("text", x = 2, y = 70,
           label = sprintf("Omitted model: β̃1 = %.2f\n(omitting X2 → BIASED!)", beta1_omit),
           hjust = 0, size = 4, color = eco_gold, fontface = "bold") +
  labs(title = "Omitted Variable Bias",
       subtitle = sprintf("Bias = %.2f (overstates true effect)", beta1_omit - beta1_true),
       x = "X1 (e.g., education)", y = "Y (e.g., wage)") +
  theme_econometria()
ggsave(file.path(fig_dir, "ch6_omitted_variable_bias.png"), p1, width = 10, height = 6, dpi = 300, bg = "white")

################################################################################
# FIGURE 2: Ceteris Paribus
################################################################################
df_ovb$X2_group <- cut(df_ovb$X2, breaks = 3, labels = c("X2 Low", "X2 Medium", "X2 High"))
p2 <- ggplot(df_ovb, aes(x = X1, y = Y, color = X2_group)) +
  geom_point(alpha = 0.6, size = 2) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 1) +
  scale_color_manual(values = c(eco_gold, eco_teal, eco_deep_blue)) +
  labs(title = "Ceteris Paribus: Holding Other Factors Constant",
       subtitle = "Within each X2 group, the slope shows effect of X1 holding X2 fixed",
       x = "X1", y = "Y") +
  theme_econometria() +
  theme(legend.position = c(0.15, 0.85), legend.title = element_blank(),
        legend.background = element_rect(fill = "white", color = eco_silver))
ggsave(file.path(fig_dir, "ch6_ceteris_paribus.png"), p2, width = 10, height = 6, dpi = 300, bg = "white")

################################################################################
# FIGURE 3: R² vs Adjusted R²
################################################################################
set.seed(678)
n_r2 <- 150
X_matrix <- matrix(rnorm(n_r2 * 10), ncol = 10)
Y_r2 <- 10 + 2*X_matrix[,1] + 3*X_matrix[,2] + 1.5*X_matrix[,3] + rnorm(n_r2, 0, 5)
r2_values <- numeric(10)
r2_adj_values <- numeric(10)
for (k in 1:10) {
  model <- lm(Y_r2 ~ X_matrix[, 1:k])
  r2_values[k] <- summary(model)$r.squared
  r2_adj_values[k] <- summary(model)$adj.r.squared
}
df_r2 <- data.frame(k = 1:10, R2 = r2_values, R2_adj = r2_adj_values)
df_r2_long <- pivot_longer(df_r2, cols = c(R2, R2_adj), names_to = "Measure", values_to = "Value")
p3 <- ggplot(df_r2_long, aes(x = k, y = Value, color = Measure, linetype = Measure)) +
  geom_line(linewidth = 1.2) + geom_point(size = 3) +
  scale_color_manual(values = c("R2" = eco_teal, "R2_adj" = eco_gold), labels = c("R²", "Adjusted R²")) +
  scale_linetype_manual(values = c("R2" = "solid", "R2_adj" = "dashed"), labels = c("R²", "Adjusted R²")) +
  geom_vline(xintercept = 3, linetype = "dotted", color = eco_deep_blue, linewidth = 0.8) +
  annotate("text", x = 3, y = 0.15, label = "True model\nhas 3 regressors", hjust = -0.1, size = 3.5, color = eco_deep_blue) +
  labs(title = "R² Always Increases, Adjusted R² Can Decrease",
       subtitle = "Adding irrelevant variables inflates R² but decreases adjusted R²",
       x = "Number of Regressors (k)", y = "Goodness of Fit") +
  scale_y_continuous(labels = percent_format()) +
  theme_econometria() +
  theme(legend.position = c(0.85, 0.3), legend.title = element_blank(),
        legend.background = element_rect(fill = "white", color = eco_silver))
ggsave(file.path(fig_dir, "ch6_r2_vs_adj_r2.png"), p3, width = 10, height = 6, dpi = 300, bg = "white")

################################################################################
# FIGURE 4: Perfect Multicollinearity
################################################################################
set.seed(91011)
n_mc <- 100
X1_mc <- rnorm(n_mc, mean = 5, sd = 2)
X2_mc <- 2*X1_mc + 3
df_mc_perfect <- data.frame(X1 = X1_mc, X2 = X2_mc)
p4 <- ggplot(df_mc_perfect, aes(x = X1, y = X2)) +
  geom_point(color = eco_teal, size = 2, alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, color = eco_deep_blue, linewidth = 1.2) +
  annotate("text", x = 3, y = 16, label = "X2 = 2×X1 + 3\nPerfect linear relationship\nCorrelation = 1.00",
           hjust = 0, size = 4.5, color = eco_deep_blue, fontface = "bold") +
  labs(title = "Perfect Multicollinearity",
       subtitle = "X2 is an exact linear function of X1 → OLS cannot separately identify effects",
       x = "X1", y = "X2") +
  theme_econometria()
ggsave(file.path(fig_dir, "ch6_perfect_multicollinearity.png"), p4, width = 9, height = 6, dpi = 300, bg = "white")

################################################################################
# FIGURE 5: Imperfect Multicollinearity
################################################################################
X1_imp <- rnorm(n_mc, mean = 5, sd = 2)
X2_imp <- 2*X1_imp + 3 + rnorm(n_mc, 0, 1.5)
cor_value <- cor(X1_imp, X2_imp)
df_mc_imperfect <- data.frame(X1 = X1_imp, X2 = X2_imp)
p5 <- ggplot(df_mc_imperfect, aes(x = X1, y = X2)) +
  geom_point(color = eco_gold, size = 2, alpha = 0.6) +
  geom_smooth(method = "lm", se = TRUE, color = eco_deep_blue, fill = eco_teal, alpha = 0.2, linewidth = 1.2) +
  annotate("text", x = 2, y = 16, label = sprintf("Correlation = %.3f\nVery high, but not perfect\n→ Large standard errors", cor_value),
           hjust = 0, size = 4.5, color = eco_deep_blue, fontface = "bold") +
  labs(title = "Imperfect Multicollinearity",
       subtitle = "High correlation → little independent variation → imprecise estimates",
       x = "X1", y = "X2") +
  theme_econometria()
ggsave(file.path(fig_dir, "ch6_imperfect_multicollinearity.png"), p5, width = 9, height = 6, dpi = 300, bg = "white")

################################################################################
# FIGURE 6: Partial Regression Plot
################################################################################
set.seed(121314)
n_partial <- 100
X1_p <- rnorm(n_partial, 5, 2)
X2_p <- rnorm(n_partial, 10, 3)
Y_p <- 5 + 2*X1_p + 3*X2_p + rnorm(n_partial, 0, 4)
model_y_on_x2 <- lm(Y_p ~ X2_p)
e_y <- residuals(model_y_on_x2)
model_x1_on_x2 <- lm(X1_p ~ X2_p)
e_x1 <- residuals(model_x1_on_x2)
df_partial <- data.frame(e_X1 = e_x1, e_Y = e_y)
model_partial <- lm(e_y ~ e_x1)
beta1_partial <- coef(model_partial)[2]
p6 <- ggplot(df_partial, aes(x = e_X1, y = e_Y)) +
  geom_point(color = eco_teal, size = 2, alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, color = eco_deep_blue, linewidth = 1.2) +
  annotate("text", x = -4, y = 15, label = sprintf("Slope = %.3f\n= β1 from full model\n(effect of X1 holding X2 fixed)", beta1_partial),
           hjust = 0, size = 4, color = eco_deep_blue, fontface = "bold") +
  labs(title = "Partial Regression Plot",
       subtitle = "Residuals of Y on X2 vs. residuals of X1 on X2 → isolates X1's effect",
       x = "X1 (residualized against X2)", y = "Y (residualized against X2)") +
  theme_econometria()
ggsave(file.path(fig_dir, "ch6_partial_regression.png"), p6, width = 9, height = 6, dpi = 300, bg = "white")

################################################################################
# FIGURE 7: OVB Sign
################################################################################
bias_scenarios <- data.frame(
  beta2 = c("+", "+", "-", "-"), corr_x1_x2 = c("+", "-", "+", "-"),
  bias = c("Positive\nBias ↑", "Negative\nBias ↓", "Negative\nBias ↓", "Positive\nBias ↑"),
  x = c(1, 2, 1, 2), y = c(2, 2, 1, 1), color = c("up", "down", "down", "up")
)
p7 <- ggplot(bias_scenarios, aes(x = x, y = y, fill = color)) +
  geom_tile(color = "white", linewidth = 2, alpha = 0.7) +
  geom_text(aes(label = bias), size = 6, fontface = "bold", color = eco_deep_blue) +
  scale_fill_manual(values = c("up" = eco_gold, "down" = eco_teal)) +
  scale_x_continuous(breaks = c(1, 2), labels = c("Corr(X1,X2) > 0", "Corr(X1,X2) < 0"), position = "top") +
  scale_y_continuous(breaks = c(1, 2), labels = c("β2 < 0", "β2 > 0")) +
  labs(title = "Signing the Direction of Omitted Variable Bias",
       subtitle = "Bias = β2 × δ1, where δ1 has sign of Corr(X1, X2)") +
  theme_econometria() +
  theme(axis.title = element_blank(),
        axis.text.x = element_text(size = 11, color = eco_deep_blue, face = "bold"),
        axis.text.y = element_text(size = 11, color = eco_deep_blue, face = "bold"),
        panel.grid = element_blank())
ggsave(file.path(fig_dir, "ch6_ovb_sign.png"), p7, width = 10, height = 7, dpi = 300, bg = "white")

cat("Ch6 figures saved to", fig_dir, "\n")
