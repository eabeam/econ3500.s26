# Generate Chapter 5 heteroskedasticity illustrations
# Output: slides/ch5/ch5_figures/homoskedasticity-pic.png, heteroskedasticity-pic.png

library(ggplot2)

set.seed(3505)

n <- 300
x <- runif(n, 0, 10)

# Homoskedastic errors
u_homo <- rnorm(n, mean = 0, sd = 2)
y_homo <- 5 + 0.8 * x + u_homo

data_homo <- data.frame(x = x, y = y_homo)

# Heteroskedastic errors (variance increases with X)
scale_hetero <- 0.2 + 0.35 * x
u_hetero <- rnorm(n, mean = 0, sd = scale_hetero)
y_hetero <- 5 + 0.8 * x + u_hetero

data_hetero <- data.frame(x = x, y = y_hetero)

base_theme <- theme_minimal(base_size = 16) +
  theme(
    plot.title = element_text(color = "#19375F", face = "bold"),
    axis.title = element_text(color = "#19375F"),
    panel.grid.minor = element_blank()
  )

p_homo <- ggplot(data_homo, aes(x = x, y = y)) +
  geom_point(alpha = 0.6, size = 2, color = "#19375F") +
  geom_smooth(method = "lm", se = FALSE, color = "#008080", linewidth = 1) +
  labs(
    title = "Homoskedasticity",
    x = "X",
    y = "Y"
  ) +
  base_theme

p_hetero <- ggplot(data_hetero, aes(x = x, y = y)) +
  geom_point(alpha = 0.6, size = 2, color = "#19375F") +
  geom_smooth(method = "lm", se = FALSE, color = "#008080", linewidth = 1) +
  labs(
    title = "Heteroskedasticity",
    x = "X",
    y = "Y"
  ) +
  base_theme

out_dir <- "/Users/ebeam/Dropbox/GitHub/econ3500.s26/slides/ch5/ch5_figures"

png(file.path(out_dir, "homoskedasticity-pic.png"), width = 1200, height = 800, res = 150)
print(p_homo)
dev.off()

png(file.path(out_dir, "heteroskedasticity-pic.png"), width = 1200, height = 800, res = 150)
print(p_hetero)
dev.off()
