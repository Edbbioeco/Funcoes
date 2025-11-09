library(ggplot2)

theme_set(theme_bw() +
            theme(axis.text = element_text(color = "black", size = 15),
                  axis.title = element_text(color = "black", size = 15),
                  legend.text = element_text(color = "black", size = 15),
                  legend.title = element_text(color = "black", size = 15),
                  legend.position = "bottom",
                  legend.background = element_blank(),
                  panel.border = element_rect(color = "black", linewidth = 1),
                  panel.grid = element_line(linewidth = 0.75, color = "gray60",
                                            linetype = "dashed")))
