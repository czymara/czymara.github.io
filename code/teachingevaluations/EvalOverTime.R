
### plot time trend of course evaluations

## generate data
evals <- data.frame("semester" = c("2016", "2016/17", "2017", "2017/18",
                                   # frankfurt
                                   "2018", "2018/19",
                                   "2019", "2019/20",
                                   "2020", "2020/21",
                                   "2021", "2021/22",
                                   "2022", "2024/25"),
                    "mean" = c(2, 1.6, NA, 1.4,
                               # frankfurt
                               1.7, 1.6,
                               1.4, 1.5,
                               1.4, 1.2,
                               1.2, 1.8,
                               1.5, 1.2
                    ),
                    "sd" = c(0, 0.7, NA, 0.6,
                             # frankfurt
                             0.5, 0.5,
                             0.5, 0.7,
                             1.2, 0.4,
                             0.4, 1.3,
                             0.7, 0.4
                    ),
                    "n" = c(5, 21, NA, 18,
                            # frankfurt
                            6, 10,
                            8, 12,
                            19, 15,
                            6, 18,
                            11, 15
                    ),
                    "University" = c("CGN", "CGN", "CGN", "CGN",
                                     "FRA", "FRA", "FRA", "FRA", "FRA",
                                     "FRA", "FRA", "FRA", "FRA", "FRA"),
                    "worth" = c (NA, NA, NA, NA, NA,
                                 5.8, 5.3, 5.5, 5.9,
                                 5.8, 5.8, 5.4, 5.8, 5.9),
                    "worthSD" = c (NA, NA, NA, NA, NA,
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


## English version

ggplot(data = evals, aes(y = semester, x = mean)) +
  geom_errorbarh(aes(xmin = mean - sd/sqrt(n), xmax = mean + sd/sqrt(n)), colour = "grey") +
  xlab("Overall grade (1: best)") + ylab("") +
  geom_path(aes(group = 1), colour = "blue") +
  geom_point() +
  geom_errorbarh(aes(xmin = worth - worthSD/sqrt(n), xmax = worth + worthSD/sqrt(n)), colour = "grey") +
  scale_x_continuous(limits = c(0, 6.5), breaks = 1:6,
                     sec.axis = sec_axis(~., breaks = 1:6, name = "Course worth\nattending (6: agree)")) +
  geom_path(aes(x = worth, group = 1), colour = "red") +
  geom_point(aes(x = worth)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
        axis.title.y = element_text(color = "blue"),
        axis.title.y.right = element_text(color = "red")) +
  labs(caption = "Mean and standard errors of mean
       Overall grade (left y-axis): Until 2018 scale 1-5,
       from 2018/19 scale 1-6") +
  coord_flip()

dev.copy(png, "out/evalovertime.png",
         units="px", width=1600, height=1600, res=300)
dev.off()


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
