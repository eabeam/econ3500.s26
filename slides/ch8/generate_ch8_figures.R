################################################################################
# ECON3500: Chapter 8 - Nonlinear Relationships
# Figure Generation Script for Quarto slides.
# Run from slides/ch8/ (e.g. Rscript generate_ch8_figures.R)
# Outputs: slides/ch8/ch8_figures/ch8_*.png
################################################################################

options(repos = c(CRAN = "https://cloud.r-project.org"))

library(ggplot2)
library(dplyr)
library(gridExtra)

script_dir <- function() {
  args <- commandArgs(trailingOnly = FALSE)
  f <- "--file="
  path <- sub(f, "", args[grepl(f, args)])
  if (length(path)) dirname(normalizePath(path)) else "."
}
tryCatch(setwd(script_dir()), error = function(e) NULL)

if (!dir.exists("ch8_figures")) dir.create("ch8_figures")
fig_dir <- "ch8_figures"

set.seed(12345)
eco_navy <- "#19375F"
eco_teal <- "#008080"
eco_gold <- "#B8860B"
eco_silver <- "#708090"

################################################################################
# FIGURE 1: QUADRATIC RELATIONSHIP
################################################################################
n <- 200
X_quad <- runif(n, 0, 10)
Y_quad <- 50 - 8*X_quad + 0.8*X_quad^2 + rnorm(n, 0, 5)
df_quad <- data.frame(X = X_quad, Y = Y_quad)
model_linear <- lm(Y ~ X, data = df_quad)
model_quad <- lm(Y ~ X + I(X^2), data = df_quad)
X_pred <- seq(0, 10, length.out = 100)
pred_linear <- predict(model_linear, newdata = data.frame(X = X_pred))
pred_quad <- predict(model_quad, newdata = data.frame(X = X_pred))
df_pred <- data.frame(X = X_pred, Linear = pred_linear, Quadratic = pred_quad)

p1 <- ggplot(df_quad, aes(x = X, y = Y)) +
  geom_point(color = eco_teal, alpha = 0.5, size = 2) +
  geom_line(data = df_pred, aes(x = X, y = Linear, color = "Linear"), linewidth = 1.2, linetype = "dashed") +
  geom_line(data = df_pred, aes(x = X, y = Quadratic, color = "Quadratic"), linewidth = 1.2) +
  scale_color_manual(values = c("Linear" = eco_gold, "Quadratic" = eco_navy)) +
  labs(title = "Quadratic Relationship: Linear vs Quadratic Fit", subtitle = "True model: Y = β0 + β1·X + β2·X² + u", x = "X", y = "Y", color = "Model") +
  theme_minimal(base_size = 14) + theme(plot.title = element_text(face = "bold", hjust = 0.5), plot.subtitle = element_text(hjust = 0.5), legend.position = "bottom")
ggsave(file.path(fig_dir, "ch8_quadratic_relationship.png"), p1, width = 10, height = 6, dpi = 300, bg = "white")

################################################################################
# FIGURE 2: MARGINAL EFFECT QUADRATIC
################################################################################
beta1_hat <- coef(model_quad)[2]
beta2_hat <- coef(model_quad)[3]
marginal_effect <- beta1_hat + 2 * beta2_hat * X_pred
turning_point <- -beta1_hat / (2 * beta2_hat)
df_marginal <- data.frame(X = X_pred, ME = marginal_effect)
p2 <- ggplot(df_marginal, aes(x = X, y = ME)) +
  geom_line(color = eco_navy, linewidth = 1.5) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black") +
  geom_vline(xintercept = turning_point, linetype = "dotted", color = eco_gold, linewidth = 1) +
  annotate("text", x = turning_point + 1, y = max(marginal_effect) * 0.8, label = sprintf("Turning point\nX = %.2f", turning_point), color = eco_gold, fontface = "bold", size = 4) +
  labs(title = "Marginal Effect in Quadratic Model", subtitle = "∂Y/∂X = β1 + 2β2·X", x = "X", y = "∂Y/∂X") +
  theme_minimal(base_size = 14) + theme(plot.title = element_text(face = "bold", hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
ggsave(file.path(fig_dir, "ch8_marginal_effect_quadratic.png"), p2, width = 10, height = 6, dpi = 300, bg = "white")

################################################################################
# FIGURE 3: INTERACTION CONTINUOUS × CONTINUOUS
################################################################################
n <- 300
X1_int <- runif(n, 0, 10)
X2_int <- runif(n, 0, 10)
Y_int <- 20 + 2*X1_int + 1*X2_int + 0.3*X1_int*X2_int + rnorm(n, 0, 8)
df_int <- data.frame(X1 = X1_int, X2 = X2_int, Y = Y_int)
df_int <- df_int %>% mutate(X2_group = cut(X2, breaks = quantile(X2, c(0, 1/3, 2/3, 1)), labels = c("Low X2", "Medium X2", "High X2"), include.lowest = TRUE))
models_by_group <- df_int %>% group_by(X2_group) %>% do(model = lm(Y ~ X1, data = .))
p3 <- ggplot(df_int, aes(x = X1, y = Y, color = X2_group)) +
  geom_point(alpha = 0.4, size = 2) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 1.2) +
  scale_color_manual(values = c(eco_gold, eco_teal, eco_navy)) +
  labs(title = "Interaction Effect: X1 × X2", subtitle = "Effect of X1 on Y depends on X2 (slopes differ)", x = "X1", y = "Y", color = "X2 Level") +
  annotate("text", x = 8, y = max(df_int$Y) * 0.95, label = "Steeper slope when X2 is high\n→ Positive interaction", color = eco_navy, fontface = "bold", size = 4) +
  theme_minimal(base_size = 14) + theme(plot.title = element_text(face = "bold", hjust = 0.5), plot.subtitle = element_text(hjust = 0.5), legend.position = "bottom")
ggsave(file.path(fig_dir, "ch8_interaction_continuous.png"), p3, width = 10, height = 6, dpi = 300, bg = "white")

################################################################################
# FIGURE 4: INTERACTION BINARY
################################################################################
n <- 200
X_cont <- runif(n, 0, 10)
D_binary <- rbinom(n, 1, 0.5)
Y_no_int <- 30 + 2*X_cont + 10*D_binary + rnorm(n, 0, 5)
Y_with_int <- 30 + 2*X_cont + 10*D_binary + 1.5*X_cont*D_binary + rnorm(n, 0, 5)
df_binary_no <- data.frame(X = X_cont, D = factor(D_binary), Y = Y_no_int, Model = "No Interaction")
df_binary_with <- data.frame(X = X_cont, D = factor(D_binary), Y = Y_with_int, Model = "With Interaction")
df_binary <- rbind(df_binary_no, df_binary_with)
df_binary$D <- factor(df_binary$D, labels = c("D = 0", "D = 1"))
p4 <- ggplot(df_binary, aes(x = X, y = Y, color = D)) +
  geom_point(alpha = 0.3, size = 1.5) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 1.2) +
  facet_wrap(~ Model, ncol = 2) +
  scale_color_manual(values = c(eco_teal, eco_navy)) +
  labs(title = "Interaction with Binary Variable", subtitle = "No interaction: parallel slopes  |  With interaction: different slopes", x = "X (continuous)", y = "Y", color = "Group") +
  theme_minimal(base_size = 14) + theme(plot.title = element_text(face = "bold", hjust = 0.5), plot.subtitle = element_text(hjust = 0.5), legend.position = "bottom", strip.text = element_text(face = "bold", size = 12))
ggsave(file.path(fig_dir, "ch8_interaction_binary.png"), p4, width = 12, height = 6, dpi = 300, bg = "white")

################################################################################
# FIGURE 5: LOG-LOG
################################################################################
n <- 150
X_log <- exp(runif(n, 0, 4))
Y_log <- 5 * X_log^0.8 * exp(rnorm(n, 0, 0.15))
df_loglog <- data.frame(X = X_log, Y = Y_log, log_X = log(X_log), log_Y = log(Y_log))
model_loglog <- lm(log_Y ~ log_X, data = df_loglog)
elasticity <- coef(model_loglog)[2]
p5_levels <- ggplot(df_loglog, aes(x = X, y = Y)) +
  geom_point(color = eco_teal, alpha = 0.5, size = 2) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE, color = eco_gold, linewidth = 1, linetype = "dashed") +
  stat_function(fun = function(x) exp(coef(model_loglog)[1]) * x^coef(model_loglog)[2], color = eco_navy, linewidth = 1.2) +
  labs(title = "Level-Level (shows nonlinearity)", x = "X", y = "Y") + theme_minimal(base_size = 12) + theme(plot.title = element_text(face = "bold", hjust = 0.5))
p5_logs <- ggplot(df_loglog, aes(x = log_X, y = log_Y)) +
  geom_point(color = eco_teal, alpha = 0.5, size = 2) +
  geom_smooth(method = "lm", se = FALSE, color = eco_navy, linewidth = 1.2) +
  annotate("text", x = mean(df_loglog$log_X), y = max(df_loglog$log_Y) * 0.95, label = sprintf("Slope = %.3f (elasticity)", elasticity), color = eco_navy, fontface = "bold", size = 4) +
  labs(title = "Log-Log (linearizes relationship)", x = "log(X)", y = "log(Y)") + theme_minimal(base_size = 12) + theme(plot.title = element_text(face = "bold", hjust = 0.5))
p5 <- gridExtra::grid.arrange(p5_levels, p5_logs, ncol = 2, top = grid::textGrob("Log-Log Specification: Constant Elasticity", gp = grid::gpar(fontface = "bold", fontsize = 16)))
ggsave(file.path(fig_dir, "ch8_loglog_specification.png"), p5, width = 12, height = 6, dpi = 300, bg = "white")

################################################################################
# FIGURE 6: LOG SPECIFICATIONS
################################################################################
X_loglevel <- runif(n, 0, 10)
log_Y_loglevel <- 3 + 0.08*X_loglevel + rnorm(n, 0, 0.2)
Y_loglevel <- exp(log_Y_loglevel)
df_loglevel <- data.frame(X = X_loglevel, Y = Y_loglevel, log_Y = log_Y_loglevel)
model_loglevel <- lm(log_Y ~ X, data = df_loglevel)
beta_loglevel <- coef(model_loglevel)[2]
p6a <- ggplot(df_loglevel, aes(x = X, y = log_Y)) +
  geom_point(color = eco_teal, alpha = 0.5, size = 2) +
  geom_smooth(method = "lm", se = FALSE, color = eco_navy, linewidth = 1.2) +
  annotate("text", x = 7, y = max(df_loglevel$log_Y) * 0.95, label = sprintf("β1 = %.3f\n→ 1-unit ↑ in X ≈ %.1f%% ↑ in Y", beta_loglevel, 100*beta_loglevel), color = eco_navy, fontface = "bold", size = 3.5) +
  labs(title = "Log-Level: log(Y) = β0 + β1·X + u", subtitle = "Linear in X, percentage change in Y", x = "X", y = "log(Y)") +
  theme_minimal(base_size = 12) + theme(plot.title = element_text(face = "bold", hjust = 0.5), plot.subtitle = element_text(hjust = 0.5, size = 10))
X_levellog <- exp(runif(n, 0, 3))
Y_levellog <- 50 + 20*log(X_levellog) + rnorm(n, 0, 5)
df_levellog <- data.frame(X = X_levellog, Y = Y_levellog, log_X = log(X_levellog))
model_levellog <- lm(Y ~ log_X, data = df_levellog)
beta_levellog <- coef(model_levellog)[2]
p6b <- ggplot(df_levellog, aes(x = log_X, y = Y)) +
  geom_point(color = eco_teal, alpha = 0.5, size = 2) +
  geom_smooth(method = "lm", se = FALSE, color = eco_navy, linewidth = 1.2) +
  annotate("text", x = mean(df_levellog$log_X), y = max(df_levellog$Y) * 0.95, label = sprintf("β1 = %.2f\n→ 1%% ↑ in X ≈ %.2f ↑ in Y", beta_levellog, beta_levellog/100), color = eco_navy, fontface = "bold", size = 3.5) +
  labs(title = "Level-Log: Y = β0 + β1·log(X) + u", subtitle = "Percentage change in X, linear change in Y", x = "log(X)", y = "Y") +
  theme_minimal(base_size = 12) + theme(plot.title = element_text(face = "bold", hjust = 0.5), plot.subtitle = element_text(hjust = 0.5, size = 10))
p6 <- gridExtra::grid.arrange(p6a, p6b, ncol = 2, top = grid::textGrob("Logarithmic Specifications Comparison", gp = grid::gpar(fontface = "bold", fontsize = 16)))
ggsave(file.path(fig_dir, "ch8_log_specifications.png"), p6, width = 12, height = 6, dpi = 300, bg = "white")

################################################################################
# FIGURE 7: INTERPRETATION GUIDE
################################################################################
interpretation_data <- data.frame(
  Model = c("Level-Level", "Log-Level", "Level-Log", "Log-Log"),
  Specification = c("Y = β0 + β1·X", "log(Y) = β0 + β1·X", "Y = β0 + β1·log(X)", "log(Y) = β0 + β1·log(X)"),
  Interpretation = c("1-unit ↑ in X → β1 ↑ in Y", "1-unit ↑ in X → (100·β1)% ↑ in Y", "1% ↑ in X → (β1/100) ↑ in Y", "1% ↑ in X → β1% ↑ in Y"),
  Example = c("β1 = 2: +1 year education → +$2 wage", "β1 = 0.08: +1 year education → +8% wage", "β1 = 15: +1% in income → +$0.15 spending", "β1 = 0.6: +1% in price → −0.6% in quantity")
)
p7 <- ggplot() +
  annotate("text", x = 0.5, y = 0.95, label = "Interpreting Coefficients in Logarithmic Models", fontface = "bold", size = 6, hjust = 0.5) +
  annotate("text", x = 0.1, y = 0.85, label = "Model", fontface = "bold", size = 4.5) +
  annotate("text", x = 0.35, y = 0.85, label = "Specification", fontface = "bold", size = 4.5) +
  annotate("text", x = 0.65, y = 0.85, label = "Interpretation of β1", fontface = "bold", size = 4.5) +
  xlim(0, 1) + ylim(0, 1) + theme_void()
y_positions <- c(0.75, 0.60, 0.45, 0.30)
colors <- c(eco_navy, eco_teal, eco_gold, eco_silver)
for (i in 1:4) {
  p7 <- p7 +
    annotate("rect", xmin = 0.05, xmax = 0.95, ymin = y_positions[i] - 0.06, ymax = y_positions[i] + 0.06, fill = colors[i], alpha = 0.1) +
    annotate("text", x = 0.1, y = y_positions[i], label = interpretation_data$Model[i], fontface = "bold", size = 4, color = colors[i]) +
    annotate("text", x = 0.35, y = y_positions[i], label = interpretation_data$Specification[i], size = 3.5, family = "mono") +
    annotate("text", x = 0.68, y = y_positions[i] + 0.03, label = interpretation_data$Interpretation[i], size = 3.5, fontface = "italic") +
    annotate("text", x = 0.68, y = y_positions[i] - 0.03, label = interpretation_data$Example[i], size = 3, color = "gray30")
}
p7 <- p7 + annotate("text", x = 0.5, y = 0.05, label = "Key: log(Y) affects left side | log(X) affects right side | Both logs → elasticity", size = 3.5, fontface = "italic", color = "gray30")
ggsave(file.path(fig_dir, "ch8_interpretation_guide.png"), p7, width = 12, height = 8, dpi = 300, bg = "white")

################################################################################
# FIGURE 8: TESTING FUNCTIONAL FORM
################################################################################
X_test <- runif(n, 0, 10)
Y_test <- 50 - 8*X_test + 0.8*X_test^2 + rnorm(n, 0, 5)
model_linear_wrong <- lm(Y_test ~ X_test)
residuals_linear <- residuals(model_linear_wrong)
model_quad_correct <- lm(Y_test ~ X_test + I(X_test^2))
residuals_quad <- residuals(model_quad_correct)
df_resid <- data.frame(X = rep(X_test, 2), Residuals = c(residuals_linear, residuals_quad), Model = rep(c("Linear (misspecified)", "Quadratic (correct)"), each = n))
p8 <- ggplot(df_resid, aes(x = X, y = Residuals)) +
  geom_point(color = eco_teal, alpha = 0.5, size = 2) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black") +
  geom_smooth(se = FALSE, color = eco_navy, linewidth = 1.2) +
  facet_wrap(~ Model, ncol = 2) +
  labs(title = "Testing Functional Form: Residual Plots", subtitle = "Misspecified model shows pattern | Correct model shows random scatter", x = "X", y = "Residuals") +
  theme_minimal(base_size = 14) + theme(plot.title = element_text(face = "bold", hjust = 0.5), plot.subtitle = element_text(hjust = 0.5), strip.text = element_text(face = "bold", size = 12))
ggsave(file.path(fig_dir, "ch8_testing_functional_form.png"), p8, width = 12, height = 6, dpi = 300, bg = "white")

cat("Ch8 figures saved to", fig_dir, "\n")
