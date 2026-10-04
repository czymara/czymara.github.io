
### plot time trend of course evaluations

## generate data
evals <- data.frame("semester" = c("2016", "2016/17", "2017/18",
                                   # frankfurt
                                   "2018", "2018/19",
                                   "2019", "2019/20",
                                   "2020", "2020/21",
                                   "2021", "2021/22",
                                   "2022", "2024/25"),
                    "mean" = c(2, 1.6, 1.4,
                               # frankfurt
                               1.7, 1.6,
                               1.4, 1.5,
                               1.4, 1.2,
                               1.2, 1.8,
                               1.5, 1.2
                    ),
                    "sd" = c(0, 0.7, 0.6,
                             # frankfurt
                             0.5, 0.5,
                             0.5, 0.7,
                             1.2, 0.4,
                             0.4, 1.3,
                             0.7, 0.4
                    ),
                    "n" = c(5, 21, 18,
                            # frankfurt
                            6, 10,
                            8, 12,
                            19, 15,
                            6, 18,
                            11, 15
                    ),
                    "University" = c("CGN", "CGN", "CGN",
                                     "FRA", "FRA", "FRA", "FRA", "FRA",
                                     "FRA", "FRA", "FRA", "FRA", "FRA"),
                    "worth" = c (NA, NA, NA, NA,
                                 5.8, 5.3, 5.5, 5.9,
                                 5.8, 5.8, 5.4, 5.8, 5.9),
                    "worthSD" = c (NA, NA, NA, NA,
                                   0.4, 0.8, 0.7, 0.3,
                                   0.6, 0.4, 1.0, 0.6, 0.4)
)

evals$grandmean <- mean(evals$mean, na.rm = T)

evals$worthgrandmean <- mean(evals$worth, na.rm = T)

# load package
library(ggplot2); theme_set(theme_bw() +
                              theme(axis.line = element_line(colour = "black"),
                                    panel.grid.major = element_blank(),
                                    panel.grid.minor = element_blank(),
                                    panel.border = element_blank(),
                                    panel.background = element_blank(),
                                    axis.text = element_text(color="black"),
                                    axis.ticks = element_line(colour = "black")))


## English version (website): inline SVG that follows the site's light/dark theme
# The plot is drawn with placeholder colours, which are then swapped for the
# site's CSS variables, so it uses the same violet, greys and font as the page
library(dplyr)
col_base  <- "#4B2E83" # -> var(--global-base-color)
col_light <- "#9DA1A4" # -> var(--global-text-color-light)
col_grid  <- "#E2DCEE" # -> var(--global-box-border-color)
col_bg    <- "#FFFFFF" # -> var(--global-bg-color)
fnt <- "IBM Plex Sans" # site font; needs to be installed locally

evals_long <- bind_rows(
  evals %>% transmute(semester, value = mean, se = sd / sqrt(n), item = "grade"),
  evals %>% transmute(semester, value = worth, se = worthSD / sqrt(n), item = "worth")
) %>%
  filter(!is.na(value)) %>%
  mutate(semester = factor(semester, levels = evals$semester),
         x = as.numeric(semester))

p_eval <- ggplot(evals_long, aes(x = x, y = value, colour = item, fill = item)) +
  geom_hline(yintercept = 1:6, colour = col_grid, linewidth = 0.3) +
  geom_ribbon(aes(ymin = value - se, ymax = value + se, group = item),
              colour = NA, alpha = 0.15) +
  geom_line(aes(alpha = item), linewidth = 0.9) +
  geom_point(aes(alpha = item), size = 2.2, shape = 21, stroke = 0.9, fill = col_bg) +
  annotate("text", x = 1, y = 2.55, label = "Overall grade (1 = best)",
           hjust = 0, family = fnt, size = 3.9, colour = col_base) +
  annotate("text", x = 2.6, y = 4.75, label = "Course worth attending (6 = fully agree)",
           hjust = 0, family = fnt, size = 3.9, colour = col_base, alpha = 0.75) +
  scale_colour_manual(values = c(grade = col_base, worth = col_base), guide = "none") +
  scale_fill_manual(values = c(grade = col_base, worth = col_base), guide = "none") +
  scale_alpha_manual(values = c(grade = 1, worth = 0.7), guide = "none") +
  scale_x_continuous(breaks = seq_along(levels(evals_long$semester)),
                     labels = levels(evals_long$semester), expand = expansion(add = 0.4)) +
  scale_y_continuous(limits = c(0.8, 6.3), breaks = 1:6) +
  labs(x = NULL, y = NULL,
       caption = "Means with standard errors.\nGrade scale 1–5 until 2018, 1–6 from 2018/19.") +
  theme_void(base_family = fnt) +
  theme(axis.text.x = element_text(colour = col_light, size = 9.5, angle = 45, hjust = 1, vjust = 1,
                                   margin = margin(t = 3)),
        axis.text.y = element_text(colour = col_light, size = 10, margin = margin(r = 4)),
        plot.caption = element_text(colour = col_light, size = 8.5, hjust = 0, margin = margin(t = 10)),
        plot.caption.position = "plot",
        plot.margin = margin(4, 6, 4, 2))

# standalone file (placeholder colours)
ggsave("out/evalovertime.svg", p_eval, device = svglite::svglite,
       width = 4, height = 3.4, bg = "transparent")

# themed copy that the courses page includes inline
svg_eval <- readLines("out/evalovertime.svg", encoding = "UTF-8")
svg_eval <- svg_eval[!grepl("^<\\?xml", svg_eval) & svg_eval != ""]
svg_eval <- gsub(col_base, "var(--global-base-color)", svg_eval, ignore.case = TRUE)
svg_eval <- gsub(col_light, "var(--global-text-color-light)", svg_eval, ignore.case = TRUE)
svg_eval <- gsub(col_grid, "var(--global-box-border-color)", svg_eval, ignore.case = TRUE)
svg_eval <- gsub(col_bg, "var(--global-bg-color)", svg_eval, ignore.case = TRUE)
dir.create("../../_includes/teaching", showWarnings = FALSE)
writeLines(svg_eval, "../../_includes/teaching/evalovertime.svg", useBytes = TRUE)


## german version
ggplot(data = evals, aes(y = semester, x = mean)) +
  geom_errorbarh(aes(xmin = mean - sd/sqrt(n), xmax = mean + sd/sqrt(n)), colour = "grey") +
  xlab("Globalurteil (1: sehr gut)") + ylab("") +
  geom_path(aes(group = 1), colour = "blue") +
  geom_point() +
  geom_errorbarh(aes(xmin = worth - worthSD/sqrt(n), xmax = worth + worthSD/sqrt(n)), colour = "grey") +
  scale_x_continuous(limits = c(0, 6.5), breaks = 1:6,
                     sec.axis = sec_axis(~., breaks = 1:6, 
                                         name = "Der Besuch der Veranstaltung lohnt sich
(6: stimme voll und ganz zu)")) +
  geom_path(aes(x = worth, group = 1), colour = "red") +
  geom_point(aes(x = worth)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
        axis.title.y = element_text(color = "blue"),
        axis.title.y.right = element_text(color = "red")) +
  labs(caption = "Mittelwert und Standardfehler des Mittelwerts
       Bis 2018: Skala von 1-5,
       ab 2018/19: Skala von 1-6") +
  coord_flip()

dev.copy(png, "out/evalovertime_de.png",
         units="px", width=1600, height=1600, res=300)
dev.off()
