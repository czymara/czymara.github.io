library(scholar)
library(ggplot2)
library(ggtext)

id <- "khPqHmgAAAAJ"

profile <- get_profile(id) # profile

cit <- get_citation_history(id) # citations

fsize <- 16 # font size

clr <- "#2a2e31"

ggplot(cit, aes(x = year, y = cites)) +
  geom_bar(stat = "identity", fill = clr) +
  theme_bw() +
  labs(
    #title = "Google Scholar citations",
    y = NULL,
    caption = paste0("<b>Total citations: ", profile$total_cites, "</b>",
                     "; H-index: ", profile$h_index
                     #, "<br>", format(Sys.time(), "%B %Y")
                     )) +
  xlab(NULL) +
  scale_x_continuous(breaks = unique(cit$year)) +
  theme(
    axis.line = element_line(colour = clr),
    axis.text = element_text(color = clr, size = fsize),
    axis.ticks = element_line(colour = clr),
    axis.title = element_text(size = fsize, color = clr),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank(),
    panel.background = element_blank(),
    axis.text.x = element_text(angle = 45, hjust = 1),
    # plot.title = element_text(size = fsize),
    plot.caption = ggtext::element_markdown(size = fsize * 1.4, hjust = 0.5, color = clr),
    plot.background = element_rect(fill = "transparent", color = NA))

png("czymara_scholar_citations.png",
    units="px", width=1600, height=1600, res=300, bg="transparent")
last_plot()
dev.off()