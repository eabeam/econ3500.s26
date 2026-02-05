################################################################################
# ECON3500 - Linear Regression Visualizations (Chapter 4)
# Education-Wages Example using REAL ACS 2024 Data
# Script to generate all figures for Simple OLS Regression
################################################################################

# Load required packages
library(ggplot2)
library(gridExtra)
library(scales)
library(dplyr)
library(haven)

# Repo paths: detect script location so figures save next to this file
script_dir <- NULL
# Rscript: script path is in --file=...
args <- commandArgs(trailingOnly = FALSE)
file_arg <- args[grepl("^--file=", args)]
if (length(file_arg) > 0) {
  script_path <- sub("^--file=", "", file_arg[1])
  script_dir <- dirname(normalizePath(script_path))
}
# RStudio (source or Run): use document path
if (is.null(script_dir) && interactive() && requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
  tryCatch({
    script_path <- rstudioapi::getSourceEditorContext()$path
    if (nzchar(script_path)) script_dir <- dirname(normalizePath(script_path))
  }, error = function(e) NULL)
}
# Fallback: assume script is in slides/ch4 and repo is current or parent
if (is.null(script_dir)) {
  script_dir <- getwd()
  if (basename(script_dir) != "ch4") {
    candidate <- file.path(script_dir, "slides", "ch4")
    if (dir.exists(candidate)) script_dir <- normalizePath(candidate)
  }
}
repo_root <- normalizePath(file.path(script_dir, "..", ".."))
data_dir <- file.path(repo_root, "datasets")
fig_dir <- file.path(script_dir, "ch4_figures")
if (!dir.exists(fig_dir)) {
  dir.create(fig_dir, recursive = TRUE)
}
message("Figures will be saved to: ", normalizePath(fig_dir))

################################################################################
# LOAD AND PREPARE REAL ACS 2024 DATA
################################################################################

cat("Loading ACS 2024 data...\n")
acs <- read_dta(file.path(data_dir, "acs2024_2pct.dta"))

# Convert education detailed code (educd) to years of education
# Based on IPUMS ACS documentation
acs$education <- case_when(
  acs$educd <= 2 ~ 0,      # No schooling
  acs$educd <= 17 ~ 2,     # Nursery - grade 4
  acs$educd == 22 ~ 5,     # Grade 5
  acs$educd == 23 ~ 6,     # Grade 6
  acs$educd == 25 ~ 7,     # Grade 7
  acs$educd == 26 ~ 8,     # Grade 8
  acs$educd == 30 ~ 9,     # Grade 9
  acs$educd == 40 ~ 10,    # Grade 10
  acs$educd == 50 ~ 11,    # Grade 11
  acs$educd %in% c(61, 62, 63, 64, 65) ~ 12,  # HS diploma/GED
  acs$educd %in% c(71, 81) ~ 14,  # Some college, 1+ years
  acs$educd == 101 ~ 16,   # Bachelor's degree
  acs$educd == 114 ~ 18,   # Master's degree
  acs$educd == 115 ~ 19,   # Professional degree
  acs$educd == 116 ~ 20,   # Doctoral degree
  TRUE ~ NA_real_
)

# Convert wages to thousands of dollars
acs$wages <- acs$incwage / 1000

# Filter data for regression sample:
# - Ages 25-64 (prime working age)
# - Positive wages
# - Not top-coded (999999)
# - Education between 8 and 20 years (reasonable range)
df <- acs %>%
  filter(
    age >= 25 & age <= 64,
    incwage > 0,
    incwage < 999000,  # Exclude top-coded
    incwage < 2000000, # Exclude very high wages
    !is.na(education),
    education >= 8 & education <= 20
  ) %>%
  select(education, wages, age, sex, perwt) %>%
  # Sample 300 observations for figures (weighted random sample)
  slice_sample(n = 300, weight_by = perwt, replace = FALSE)

cat("Sample size:", nrow(df), "\n")
cat("Education range:", min(df$education), "to", max(df$education), "years\n")
cat("Wage range: $", round(min(df$wages), 1), "k to $", round(max(df$wages), 1), "k\n")

# Fit regression model
model <- lm(wages ~ education, data = df)
df$wages_fitted <- fitted(model)
df$residuals <- residuals(model)

# Extract coefficients
beta0 <- coef(model)[1]
beta1 <- coef(model)[2]
cat("\nRegression results:\n")
cat("Intercept (beta0):", round(beta0, 2), "\n")
cat("Slope (beta1):", round(beta1, 2), "\n")
cat("R-squared:", round(summary(model)$r.squared, 4), "\n")

# Store true parameters for sampling distribution
true_beta0 <- beta0
true_beta1 <- beta1
error_sd <- sigma(model)

################################################################################
# THEME FOR CONSISTENT STYLING
################################################################################

# Econometria color palette
eco_navy <- "#19375F"
eco_teal <- "#008080"
eco_gold <- "#B8860B"
eco_silver <- "#708090"
eco_deep_blue <- eco_navy

theme_econometria <- function() {
  theme_minimal() +
    theme(
      plot.title = element_text(hjust = 0.5, size = 14, face = "bold", color = eco_navy),
      plot.subtitle = element_text(hjust = 0.5, size = 10, color = eco_silver),
      axis.title = element_text(size = 11, color = "#36454F"),
      axis.text = element_text(size = 9, color = "#36454F"),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(color = "gray90", linewidth = 0.3),
      legend.position = "bottom",
      legend.text = element_text(size = 9),
      legend.title = element_text(size = 10, face = "bold")
    )
}

cat("\nGenerating figures...\n")

################################################################################
# FIGURE 1: Raw Scatter Plot
################################################################################
p1 <- ggplot(df, aes(x = education, y = wages)) +
  geom_jitter(color = eco_teal, alpha = 0.6, size = 2.5, width = 0.2, height = 0) +
  labs(
    title = "Education and Annual Wages",
    subtitle = "Raw data from ACS 2024 (n = 300) with jitter",
    x = "Years of Education",
    y = "Annual Wages ($1000s)"
  ) +
  theme_econometria()


ggsave(file.path(fig_dir, "ch4_scatter_raw.png"), p1, width = 8, height = 5, dpi = 300, bg = "white")

################################################################################
# FIGURE 2: Scatter with OLS Line
################################################################################

p2 <- ggplot(df, aes(x = education, y = wages)) +
  geom_jitter(color = eco_teal, alpha = 0.6, size = 2.5, width = 0.2, height = 0) +
  geom_smooth(method = "lm", se = FALSE, color = eco_deep_blue, linewidth = 1.2) +
  annotate("text", x = max(df$education) - 1, y = max(df$wages),
           label = paste0("Ŷ = ", round(beta0, 1), " + ", round(beta1, 2), " × Education"),
           hjust = 1, vjust = 1, size = 4, color = eco_deep_blue, fontface = "bold") +
  labs(
    title = "OLS Regression Line",
    subtitle = "Best-fitting line through the data with jitter",
    x = "Years of Education",
    y = "Annual Wages ($1000s)"
  ) +
  theme_econometria()

ggsave(file.path(fig_dir, "ch4_scatter.png"), p2, width = 8, height = 5, dpi = 300, bg = "white")

################################################################################
# FIGURE 3: Fitted Values and Residuals
################################################################################

# Highlight a few observations (fixed row indices for reproducible figure)
# Randomly select 3 indices with unique values of education
unique_eds <- unique(df$education)
if (length(unique_eds) < 3) stop("Not enough unique education levels for highlighting.")

# Find all indices where the absolute residual is at least 40
eligible_idx <- which(abs(df$residuals) >= 40)
if (length(eligible_idx) < 3) stop("Not enough observations with residual >= 40.")

# Ensure unique education levels
eligible_eds <- df$education[eligible_idx]
unique_eligible_eds <- unique(eligible_eds)
if (length(unique_eligible_eds) < 3) stop("Not enough unique education levels with residual >= 40.")

# Sample 3 unique education levels from those with large residuals
highlight_eds <- sample(unique_eligible_eds, 3)
highlight_idx <- sapply(highlight_eds, function(e) {
  candidates <- eligible_idx[df$education[eligible_idx] == e]
  sample(candidates, 1)
})

df$highlight <- FALSE
df$highlight[highlight_idx] <- TRUE

p3 <- ggplot(df, aes(x = education, y = wages)) +
  geom_smooth(method = "lm", se = FALSE, color = eco_deep_blue, linewidth = 1.2) +
  geom_point(data = df[!df$highlight, ], aes(x = education, y = wages),
             color = eco_silver, alpha = 0.3, size = 2) +
  geom_point(data = df[df$highlight, ], aes(x = education, y = wages),
             color = eco_teal, size = 4) +
  geom_point(data = df[df$highlight, ], aes(x = education, y = wages_fitted),
             color = eco_gold, size = 4, shape = 17) +
  geom_segment(data = df[df$highlight, ],
               aes(x = education, xend = education, y = wages, yend = wages_fitted),
               color = "red", linewidth = 1, linetype = "dashed") +
  labs(
    title = "Fitted Values and Residuals",
    subtitle = "Observed Y (teal), Fitted Ŷ (gold), Residuals (red dashed)",
    x = "Years of Education",
    y = "Annual Wages ($1000s)"
  ) +
  theme_econometria()

p3 <- p3 +
  coord_cartesian(ylim = c(NA, 300))


ggsave(file.path(fig_dir, "ch4_residuals.png"), p3, width = 8, height = 5, dpi = 300, bg = "white")

################################################################################
# FIGURE 4: Residual Plot
################################################################################

p4 <- ggplot(df, aes(x = education, y = residuals)) +
  geom_hline(yintercept = 0, color = eco_deep_blue, linewidth = 1, linetype = "dashed") +
  geom_point(color = eco_teal, alpha = 0.5, size = 2) +
  labs(
    title = "Residual Plot",
    subtitle = "Checking for patterns in residuals",
    x = "Years of Education",
    y = "Residuals (û)"
  ) +
  theme_econometria()

ggsave(file.path(fig_dir, "ch4_residual_plot.png"), p4, width = 8, height = 5, dpi = 300, bg = "white")

################################################################################
# FIGURE 5: Population Regression Function (PRF)
################################################################################

# For PRF: use full ACS sample to represent "population"
acs_full <- acs %>%
  filter(
    age >= 25 & age <= 64,
    incwage > 0,
    incwage < 999000,
    !is.na(education),
    education >= 8 & education <= 20
  ) %>%
  mutate(wages = incwage / 1000) %>%
  select(education, wages, perwt) %>%
  slice_sample(n = 2000, weight_by = perwt, replace = FALSE)

model_full <- lm(wages ~ education, data = acs_full)

p5 <- ggplot(acs_full, aes(x = education, y = wages)) +
  geom_point(color = eco_teal, alpha = 0.15, size = 1.5) +
  geom_smooth(method = "lm", se = FALSE, color = eco_deep_blue, linewidth = 1.5) +
  labs(
    title = "Population Regression Function",
    subtitle = "E[Y|X] = β₀ + β₁X (larger population sample, n = 2000)",
    x = "Years of Education",
    y = "Annual Wages ($1000s)"
  ) +
  theme_econometria()

ggsave(file.path(fig_dir, "ch4_prf.png"), p5, width = 8, height = 5, dpi = 300, bg = "white")

################################################################################
# FIGURE 6: Sampling Distribution (20, 200, 2000)
################################################################################

# Use full ACS population for sampling
acs_pop <- acs %>%
  filter(
    age >= 25 & age <= 64,
    incwage > 0,
    incwage < 999000,
    !is.na(education),
    education >= 8 & education <= 20
  ) %>%
  mutate(wages = incwage / 1000)

# "True" slope from the population used for sampling
pop_model <- lm(wages ~ education, data = acs_pop, weights = perwt)
true_beta1_pop <- coef(pop_model)["education"]

draw_sample_and_estimate <- function(sample_size) {
  samp <- acs_pop %>%
    slice_sample(n = sample_size, weight_by = perwt, replace = TRUE)
  model_samp <- lm(wages ~ education, data = samp)
  return(coef(model_samp))
}

# Fixed x-axis limits for all three panels
xlim_range <- c(min(true_beta1_pop - 3, 0), max(true_beta1_pop + 3, 15))

# PANEL 1: n = 20
set.seed(123)
n_sims <- 100
estimates_20 <- t(replicate(n_sims, draw_sample_and_estimate(20)))
df_est_20 <- data.frame(beta0 = estimates_20[,1], beta1 = estimates_20[,2])

p6a <- ggplot(df_est_20, aes(x = beta1)) +
  geom_histogram(bins = 20, fill = eco_teal, color = "white", alpha = 0.7) +
  geom_vline(xintercept = true_beta1_pop, color = "red", linewidth = 1.5, linetype = "dashed") +
  geom_vline(xintercept = mean(df_est_20$beta1), color = eco_deep_blue, linewidth = 1) +
  annotate("text", x = true_beta1_pop + 0.8, y = Inf, vjust = 1.5,
           label = "True β₁", color = "red", fontface = "bold", size = 3.5) +
  coord_cartesian(xlim = xlim_range) +
  labs(
    title = "n = 20 (High Variability)",
    x = expression(hat(beta)[1]),
    y = "Frequency"
  ) +
  theme_econometria() +
  theme(plot.title = element_text(size = 11))

# PANEL 2: n = 200
estimates_200 <- t(replicate(n_sims, draw_sample_and_estimate(200)))
df_est_200 <- data.frame(beta0 = estimates_200[,1], beta1 = estimates_200[,2])

p6b <- ggplot(df_est_200, aes(x = beta1)) +
  geom_histogram(bins = 20, fill = eco_teal, color = "white", alpha = 0.7) +
  geom_vline(xintercept = true_beta1_pop, color = "red", linewidth = 1.5, linetype = "dashed") +
  geom_vline(xintercept = mean(df_est_200$beta1), color = eco_deep_blue, linewidth = 1) +
  annotate("text", x = true_beta1_pop + 0.8, y = Inf, vjust = 1.5,
           label = "True β₁", color = "red", fontface = "bold", size = 3.5) +
  coord_cartesian(xlim = xlim_range) +
  labs(
    title = "n = 200 (Moderate Variability)",
    x = expression(hat(beta)[1]),
    y = "Frequency"
  ) +
  theme_econometria() +
  theme(plot.title = element_text(size = 11))

# PANEL 3: n = 2000
estimates_2000 <- t(replicate(n_sims, draw_sample_and_estimate(2000)))
df_est_2000 <- data.frame(beta0 = estimates_2000[,1], beta1 = estimates_2000[,2])

p6c <- ggplot(df_est_2000, aes(x = beta1)) +
  geom_histogram(bins = 20, fill = eco_teal, color = "white", alpha = 0.7) +
  geom_vline(xintercept = true_beta1_pop, color = "red", linewidth = 1.5, linetype = "dashed") +
  geom_vline(xintercept = mean(df_est_2000$beta1), color = eco_deep_blue, linewidth = 1) +
  annotate("text", x = true_beta1_pop + 0.8, y = Inf, vjust = 1.5,
           label = "True β₁", color = "red", fontface = "bold", size = 3.5) +
  coord_cartesian(xlim = xlim_range) +
  labs(
    title = "n = 2000 (Low Variability)",
    x = expression(hat(beta)[1]),
    y = "Frequency"
  ) +
  theme_econometria() +
  theme(plot.title = element_text(size = 11))

# Combine
p6_combined <- grid.arrange(p6a, p6b, p6c, ncol = 3,
                            top = grid::textGrob("Sampling Distribution of β̂₁: Effect of Sample Size",
                                                gp = grid::gpar(fontface = "bold", fontsize = 14, col = eco_deep_blue)))

ggsave(file.path(fig_dir, "ch4_sampling.png"), p6_combined, width = 14, height = 4.5, dpi = 300, bg = "white")

################################################################################
# FIGURE 7: TSS/ESS/SSR Decomposition (REDESIGNED - PEDAGOGICAL)
################################################################################

y_bar <- mean(df$wages)
x_actual <- 14

# Find observation near x = 14 with visible residual
candidates <- df[abs(df$education - x_actual) < 0.5, ]
candidates_visible <- candidates[abs(candidates$residuals) > quantile(abs(df$residuals), 0.5), ]
if (nrow(candidates_visible) > 0) {
  obs_idx <- which(df$education == candidates_visible$education[1] &
                   df$wages == candidates_visible$wages[1])[1]
} else {
  obs_idx <- which.min(abs(df$education - x_actual))
}

y_i <- df$wages[obs_idx]
y_hat_i <- df$wages_fitted[obs_idx]
x_actual <- df$education[obs_idx]

# Colors
color_tss <- "purple"
color_ess <- "blue"
color_ssr <- "red"

# Horizontal offsets
x_tss <- x_actual - 0.2
x_ess <- x_actual
x_ssr <- x_actual + 0.2

p7 <- ggplot() +
  geom_hline(yintercept = y_bar, linetype = "dashed", color = "gray70", linewidth = 0.5) +
  geom_abline(intercept = coef(model)[1], slope = coef(model)[2],
              color = "gray70", linewidth = 0.5, linetype = "solid") +
  geom_point(aes(x = c(x_actual, x_actual, x_actual),
                 y = c(y_bar, y_hat_i, y_i)),
             size = 5, color = c("gray40", "blue", "black")) +
  geom_segment(aes(x = x_tss, xend = x_tss, y = y_bar, yend = y_i),
               color = color_tss, linewidth = 2,
               arrow = arrow(length = unit(0.2, "inches"), type = "closed")) +
  geom_segment(aes(x = x_ess, xend = x_ess, y = y_bar, yend = y_hat_i),
               color = color_ess, linewidth = 2,
               arrow = arrow(length = unit(0.2, "inches"), type = "closed")) +
  geom_segment(aes(x = x_ssr, xend = x_ssr, y = y_hat_i, yend = y_i),
               color = color_ssr, linewidth = 2,
               arrow = arrow(length = unit(0.2, "inches"), type = "closed")) +
  annotate("text", x = x_tss - 0.35, y = (y_bar + y_i)/2,
           label = "TSS\n(total)", color = color_tss, fontface = "bold", size = 4.5, hjust = 1) +
  annotate("text", x = x_ess - 0.35, y = (y_bar + y_hat_i)/2,
           label = "ESS\n(explained)", color = color_ess, fontface = "bold", size = 4.5, hjust = 1) +
  annotate("text", x = x_ssr + 0.35, y = (y_hat_i + y_i)/2,
           label = "SSR\n(residual)", color = color_ssr, fontface = "bold", size = 4.5, hjust = 0) +
  annotate("text", x = x_actual + 0.5, y = y_bar, label = "Ȳ",
           color = "gray40", fontface = "bold", size = 5, hjust = 0) +
  annotate("text", x = x_actual + 0.5, y = y_hat_i, label = "Ŷᵢ",
           color = "blue", fontface = "bold", size = 5, hjust = 0) +
  annotate("text", x = x_actual + 0.5, y = y_i, label = "Yᵢ",
           color = "black", fontface = "bold", size = 5, hjust = 0) +
  scale_x_continuous(limits = c(x_actual - 2, x_actual + 2),
                     breaks = seq(floor(x_actual - 2), ceiling(x_actual + 2), 1)) +
  scale_y_continuous(limits = c(min(y_bar, y_hat_i, y_i) - 10,
                                max(y_bar, y_hat_i, y_i) + 10)) +
  labs(
    title = "Sum of Squares Decomposition: TSS = ESS + SSR",
    subtitle = "One observation illustrates how total variation splits into explained + residual",
    x = "Years of Education",
    y = "Annual Wages ($1000s)"
  ) +
  theme_econometria() +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(color = "gray95", linewidth = 0.3)
  )

ggsave(file.path(fig_dir, "ch4_fit_decomposition.png"), p7, width = 9, height = 6, dpi = 300, bg = "white")

################################################################################
# CONTINUE WITH REMAINING FIGURES (8-11)
################################################################################

# Calculate R-squared components
TSS <- sum((df$wages - mean(df$wages))^2)
ESS <- sum((df$wages_fitted - mean(df$wages))^2)
SSR <- sum(df$residuals^2)
r_squared <- ESS / TSS

# FIGURE 8: R-squared Visualization
p8_data <- data.frame(
  component = c("ESS\n(Explained)", "SSR\n(Residual)"),
  value = c(ESS, SSR),
  percent = c(r_squared, 1 - r_squared)
)

p8a <- ggplot(p8_data, aes(x = "", y = value, fill = component)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y") +
  scale_fill_manual(values = c("ESS\n(Explained)" = eco_teal, "SSR\n(Residual)" = "coral")) +
  labs(title = paste0("R² = ", round(r_squared, 3))) +
  theme_void() +
  theme(legend.title = element_blank(),
        plot.title = element_text(hjust = 0.5, face = "bold", size = 12))

p8b <- ggplot(p8_data, aes(x = component, y = percent, fill = component)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = paste0(round(percent * 100, 1), "%")),
            vjust = -0.5, fontface = "bold", size = 5) +
  scale_fill_manual(values = c("ESS\n(Explained)" = eco_teal, "SSR\n(Residual)" = "coral")) +
  scale_y_continuous(labels = percent, limits = c(0, 1)) +
  labs(
    title = "Variance Decomposition",
    x = NULL,
    y = "Proportion of Total Variance"
  ) +
  theme_econometria() +
  theme(legend.position = "none")

p8 <- grid.arrange(p8a, p8b, ncol = 2,
                   top = grid::textGrob("R-squared Interpretation",
                                        gp = grid::gpar(fontface = "bold", fontsize = 14, col = eco_deep_blue)))

ggsave(file.path(fig_dir, "ch4_r_squared.png"), p8, width = 10, height = 4.5, dpi = 300, bg = "white")

# FIGURE 9: Sample Size Comparison
sample_sizes <- c(30, 100, 500, 2000)
results_list <- list()

for (i in seq_along(sample_sizes)) {
  n_size <- sample_sizes[i]
  samp <- acs_pop %>%
    slice_sample(n = n_size, weight_by = perwt, replace = TRUE)

  df_temp <- data.frame(
    education = samp$education,
    wages = samp$wages,
    sample_size = paste0("n = ", n_size)
  )

  results_list[[i]] <- df_temp
}

df_sizes <- do.call(rbind, results_list)
df_sizes$sample_size <- factor(df_sizes$sample_size,
                               levels = paste0("n = ", sample_sizes))

p9 <- ggplot(df_sizes, aes(x = education, y = wages)) +
  geom_point(color = eco_teal, alpha = 0.4, size = 1.5) +
  geom_smooth(method = "lm", se = TRUE, color = eco_deep_blue,
              fill = eco_silver, alpha = 0.3, linewidth = 1) +
  facet_wrap(~ sample_size, ncol = 2) +
  labs(
    title = "Effect of Sample Size on Estimation Precision",
    subtitle = "Larger samples produce more precise estimates (narrower confidence bands)",
    x = "Years of Education",
    y = "Annual Wages ($1000s)"
  ) +
  theme_econometria() +
  theme(strip.text = element_text(face = "bold", size = 10))

ggsave(file.path(fig_dir, "ch4_sample_size_comparison.png"), p9, width = 10, height = 8, dpi = 300, bg = "white")

# Shared OVB dataset for Figures 10 and 11
set.seed(3503)
n_ovb <- 300

# Simulate ability as omitted variable (not in dataset)
# In reality, higher education correlates with higher ability
acs_ovb <- acs_pop %>%
  slice_sample(n = n_ovb, weight_by = perwt, replace = TRUE) %>%
  select(education, wages)

# Add simulated ability (correlated with education)
acs_ovb$ability <- 100 + 5 * acs_ovb$education + rnorm(n_ovb, 0, 15)
# Center ability so the "true" line is evaluated at average ability
acs_ovb$ability <- acs_ovb$ability - mean(acs_ovb$ability)

# Generate wages on a realistic scale (in $1000s)
wage_base <- mean(acs_ovb$wages, na.rm = TRUE)
acs_ovb$wages_true <- wage_base + 0.8 * acs_ovb$education +
                      0.25 * acs_ovb$ability + rnorm(n_ovb, 0, 8)
acs_ovb$u_true <- acs_ovb$wages_true - (wage_base + 0.8 * acs_ovb$education)

# Model 1: TRUE model (if we could observe ability)
model_true <- lm(wages_true ~ education + ability, data = acs_ovb)
beta_edu_true <- coef(model_true)["education"]


# Model 2: BIASED model (omits ability)
model_omit <- lm(wages_true ~ education, data = acs_ovb)
beta_edu_omit <- coef(model_omit)["education"]
acs_ovb$residuals_omit <- residuals(model_omit)

# Color code by ability terciles
acs_ovb$ability_group <- cut(acs_ovb$ability,
                              breaks = quantile(acs_ovb$ability, c(0, 0.33, 0.67, 1)),
                              labels = c("Low Ability", "Medium Ability", "High Ability"),
                              include.lowest = TRUE)

# FIGURE 10: Zero Conditional Mean
zcm_data <- acs_ovb %>%
  mutate(educ_bins = cut(education, breaks = c(7, 10, 12, 14, 16, 21),
                         labels = c("8-10", "11-12", "13-14", "15-16", "17+")))

mean_u_by_bin <- zcm_data %>%
  group_by(educ_bins) %>%
  summarize(mean_u = mean(u_true),
            educ_mid = mean(education),
            .groups = "drop")

p10 <- ggplot(zcm_data, aes(x = education, y = u_true)) +
  geom_hline(yintercept = 0, linetype = "dashed", color = eco_deep_blue, linewidth = 1) +
  geom_point(color = eco_teal, alpha = 0.4, size = 2) +
  geom_point(data = mean_u_by_bin, aes(x = educ_mid, y = mean_u),
             color = eco_deep_blue, size = 5, shape = 18) +
  geom_line(data = mean_u_by_bin, aes(x = educ_mid, y = mean_u),
            color = eco_deep_blue, linewidth = 1.2) +
  annotate("text", x = max(zcm_data$education) - 1, y = 16,
           label = "Blue diamonds = E[u|X]\n(should be ≈ 0 for all X)",
           color = eco_deep_blue, fontface = "bold", size = 3.5) +
  labs(
    title = "Zero Conditional Mean Assumption: E[u|X] = 0",
    subtitle = "Average true error at each X level should be close to zero",
    x = "Years of Education",
    y = "True Error (u)"
  ) +
  theme_econometria()
p10 <- p10 + coord_cartesian(ylim = c(-20, 20))

ggsave(file.path(fig_dir, "ch4_zero_conditional_mean.png"), p10, width = 8, height = 5, dpi = 300, bg = "white")

# FIGURE 11: Omitted Variable Bias
# Label positions (keep annotations inside plot)
y_max_ovb <- max(acs_ovb$wages_true, na.rm = TRUE)
y_min_ovb <- min(acs_ovb$wages_true, na.rm = TRUE)
y_rng_ovb <- y_max_ovb - y_min_ovb
label_x_ovb <- min(acs_ovb$education, na.rm = TRUE) + 0.5
label_y1_ovb <- y_max_ovb - 0.05 * y_rng_ovb
label_y2_ovb <- y_max_ovb - 0.12 * y_rng_ovb

p11 <- ggplot(acs_ovb, aes(x = education, y = wages_true)) +
  geom_point(aes(color = ability_group), alpha = 0.6, size = 2.5) +
  geom_abline(intercept = coef(model_omit)[1], slope = coef(model_omit)[2],
              color = "red", linewidth = 1.5, linetype = "solid") +
  geom_abline(intercept = coef(model_true)[1], slope = coef(model_true)[2],
              color = eco_deep_blue, linewidth = 1.5, linetype = "dashed") +
  scale_color_manual(values = c("Low Ability" = "#FFA07A", "Medium Ability" = "#FFD700",
                                "High Ability" = "#90EE90")) +
  annotate("text", x = label_x_ovb, y = label_y1_ovb,
           label = paste0("Biased (omits ability): β₁ = ", round(beta_edu_omit, 2)),
           color = "red", fontface = "bold", hjust = 0, size = 4) +
  annotate("text", x = label_x_ovb, y = label_y2_ovb,
           label = paste0("True (includes ability): β₁ = ", round(beta_edu_true, 2)),
           color = eco_deep_blue, fontface = "bold", hjust = 0, size = 4) +
  labs(
    title = "Omitted Variable Bias",
    subtitle = "Higher education correlates with higher ability → biased estimate when ability omitted",
    x = "Years of Education",
    y = "Annual Wages ($1000s)",
    color = "Ability Level"
  ) +
  theme_econometria() +
  scale_y_continuous(expand = expansion(mult = c(0.05, 0.12)))

p11 <- p11 + coord_cartesian(ylim = c(min(zcm_data$residuals_omit), 150))


ggsave(file.path(fig_dir, "ch4_ovb.png"), p11, width = 9, height = 6, dpi = 300, bg = "white")

################################################################################
# SUMMARY
################################################################################

cat("\n================================================================================\n")
cat("FIGURE GENERATION COMPLETE\n")
cat("================================================================================\n")
cat("Generated 11 figures for Chapter 4 (Linear Regression):\n")
cat("  1. ch4_scatter_raw.png - Raw scatter plot\n")
cat("  2. ch4_scatter.png - Scatter with OLS line\n")
cat("  3. ch4_residuals.png - Fitted values and residuals\n")
cat("  4. ch4_residual_plot.png - Residual diagnostic plot\n")
cat("  5. ch4_prf.png - Population regression function\n")
cat("  6. ch4_sampling.png - Sampling distribution (20/200/2000 progression)\n")
cat("  7. ch4_fit_decomposition.png - TSS = ESS + SSR decomposition\n")
cat("  8. ch4_r_squared.png - R-squared interpretation\n")
cat("  9. ch4_sample_size_comparison.png - Effect of sample size\n")
cat("  10. ch4_zero_conditional_mean.png - E[u|X] = 0 assumption\n")
cat("  11. ch4_ovb.png - Omitted variable bias\n")
cat("\nAll figures saved to:", fig_dir, "\n")
cat("Data: REAL ACS 2024 microdata (2% sample)\n")
cat("Sample: Ages 25-64, positive wages, education 8-20 years\n")
cat("Color palette: Econometria (#19375F, #008080, #B8860B, #708090)\n")
cat("\nRegression summary:\n")
print(summary(model))
cat("================================================================================\n")
