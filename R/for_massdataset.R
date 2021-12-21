no_function()

tinytools::setwd_project()
setwd("manuscript/Figures/Figure_massdataset/")

expression_data = 
  matrix(sample(-50:50, 200, replace = TRUE), ncol = 10)

library(circlize)

library(ComplexHeatmap)

col_fun = colorRamp2(breaks = c(-50,0,50), colors = c("skyblue", "white", "red"))

expression_data_plot = 
Heatmap(
  expression_data,
  cluster_columns = TRUE,
  cluster_rows = TRUE,
  col = col_fun,
  show_column_dend = FALSE, 
  show_row_dend = FALSE,
  show_heatmap_legend = FALSE, 
  rect_gp = gpar(col = "white"), border = TRUE
)

library(ggplotify)
expression_data_plot = as.ggplot(plot = expression_data_plot)
expression_data_plot
ggsave(expression_data_plot, filename = "expression_data_plot.pdf", width = 3, height = 6)

library(tidyverse)

variable_info = 
  data.frame(rep(1,20), rep(2,20), rep(3,20)) %>% 
  as.matrix()
  
col_fun2 = colorRamp2(breaks = c(1, 2, 3), colors = ggsci::pal_lancet()(n=6)[1:3])

variable_info_plot = 
Heatmap(
  variable_info,
  cluster_columns = TRUE,
  cluster_rows = TRUE,
  show_column_dend = FALSE, 
  show_row_dend = FALSE,
  show_heatmap_legend = FALSE, 
  rect_gp = gpar(col = "white"),
  col = col_fun2, 
  show_column_names = FALSE,
  border = TRUE
)

variable_info_plot = as.ggplot(variable_info_plot)
variable_info_plot
ggsave(variable_info_plot, filename = "variable_info_plot.pdf", width = 1, height = 6)



sample_info = 
  data.frame(rep(1,10), rep(2,10), rep(3,10), rep(4,10), rep(5,10)) %>% 
  as.matrix()

col_fun2 = colorRamp2(breaks = c(1, 2, 3, 4, 5), colors = ggsci::pal_lancet()(n=8)[4:8])

sample_info_plot = 
  Heatmap(
    sample_info,
    cluster_columns = TRUE,
    cluster_rows = TRUE,
    show_column_dend = FALSE, 
    show_row_dend = FALSE,
    show_heatmap_legend = FALSE, 
    rect_gp = gpar(col = "white"),
    col = col_fun2, 
    show_column_names = FALSE,
    border = TRUE
  )

sample_info_plot = as.ggplot(sample_info_plot)
sample_info_plot
ggsave(sample_info_plot, filename = "sample_info_plot.pdf", width = 1.5, height = 3)







