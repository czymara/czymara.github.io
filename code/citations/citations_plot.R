
library(scholar)
library(ggplot2)

# Define the id for Richard Feynman
id <- "khPqHmgAAAAJ"

# Get his profile and print his name
profile <- get_profile(id)
profile$name 

# Get his publications (a large data frame)
get_publications(id)

# Get his citation history, i.e. citations to his work in a given year 
cit <- get_citation_history(id)

# Plot
ggplot(cit, aes(x = year, y = cites)) +
  geom_bar(stat = "identity") +
  theme_bw() +
  labs(
    title = "Google Scholar citations",
    y = NULL,
    caption = paste0("Total citations: ", profile$total_cites,
                     "\nH-index: ", profile$h_index,
                     "\nUpdated: ", format(Sys.time(), "%d-%B-%Y"))
  ) +
  xlab(NULL) +
  #annotate("text", label = paste0("Updated: ", format(Sys.time(), "%d-%B-%Y")),
  #         x = -Inf, y = Inf, vjust = 1.5, hjust = -0.1, size = 4, colour = 'darkgray') +
  theme(
    axis.line = element_line(colour = "black"),
    axis.text = element_text(color = "black"),
    axis.ticks = element_line(colour = "black"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank(),
    panel.background = element_blank(),
    plot.caption = element_text(size = 14, hjust = 0.5)
  )



dev.copy(png, "czymara_scholar_citations.png",
         units="px", width=1600, height=1600, res=300)
dev.off()

