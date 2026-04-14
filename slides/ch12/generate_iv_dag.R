# Generate IV DAG figure for Chapter 12
# Output: ch12_figures/ch12_iv_dag.png
# Shows instrument Z -> Education -> Earnings with unobserved Ability confounder

library(ggdag)
library(ggplot2)
library(dagitty)
library(tibble)

fig_dir <- "./ch12_figures"

# Course color palette (matches custom-econometria.scss and ch8b figures)
eco_teal <- "#008080"
eco_silver <- "#708090"
eco_gold <- "#B8860B"
fig_bg <- "#D6DEE6"
node_text_color <- "white"
node_sz <- 22
text_sz <- 4
edge_w <- 0.8

theme_dag_clean <- function() {
  theme_dag() +
    theme(
      plot.background = element_rect(fill = fig_bg, color = NA),
      panel.background = element_rect(fill = fig_bg, color = NA),
      plot.margin = margin(10, 10, 10, 10)
    )
}

# IV DAG: Z -> Education -> Earnings, Ability (unobserved) -> Education & Earnings
# NO arrow from Z to Earnings (exclusion restriction)
# NO arrow from Z to Ability (exogeneity)
dag_iv <- dagify(
  Earnings ~ Education + Ability,
  Education ~ Ability + Z,
  labels = c("Ability" = "Ability",
             "Education" = "Education",
             "Earnings" = "Earnings",
             "Z" = "Z"),
  coords = tibble(name = c("Z", "Education", "Ability", "Earnings"),
                  x = c(0, 1.5, 2.5, 3.5),
                  y = c(1, 1, 2.2, 1))
)

td <- tidy_dagitty(dag_iv)

p_iv <- ggplot(td, aes(x = x, y = y, xend = xend, yend = yend)) +
  geom_dag_edges(edge_width = edge_w) +
  geom_dag_node(aes(colour = name), size = node_sz) +
  scale_colour_manual(values = c("Ability" = eco_silver,
                                 "Education" = eco_teal,
                                 "Earnings" = eco_teal,
                                 "Z" = eco_gold)) +
  geom_dag_text(aes(label = label), color = node_text_color,
                size = 3.5, lineheight = 0.85, fontface = "bold") +
  theme_dag_clean() +
  theme(legend.position = "none") +
  scale_x_continuous(expand = expansion(mult = c(0.35, 0.2))) +
  scale_y_continuous(expand = expansion(mult = 0.3)) +
  coord_cartesian(clip = "off")

ggsave(file.path(fig_dir, "ch12_iv_dag.png"),
       p_iv, width = 8, height = 4, dpi = 300, bg = fig_bg)

cat("Done: ch12_iv_dag.png\n")
