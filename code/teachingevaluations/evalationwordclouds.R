

### create worldcloude of open evaluation items

evaluations <- read.delim("in/evaluations.txt", fileEncoding="UTF-8")

evaluations <- as.character(evaluations[,1])

packages <- c("quanteda", "quanteda.textplots")
lapply(packages, library, character.only = TRUE)


toks <- tokens(corpus(evaluations), remove_punct = T,
               remove_numbers = T,
               remove_symbols = T,
               remove_separators = T,
               remove_hyphens = T)

toks <-  tokens_remove(toks, c(stopwords("german"),
                               "dass", "h", "wäre", "wären", "z.b", "mal",
                               "bzw", "pro", "eher", "h", "denen",
                               "dafür", "innen", "ja", "wurde"), case_insensitive = TRUE, padding = FALSE)
toks <-  tokens_remove(toks, stopwords(), case_insensitive = TRUE, padding = FALSE)

DFM <- dfm(toks)


### wordcloud (website): English, inline SVG that follows the site's light/dark theme
library(ggplot2)
library(dplyr)
library(ggwordcloud)
col_base <- "#4B2E83" # -> var(--global-base-color)
fnt <- "IBM Plex Sans" # site font; needs to be installed locally

# German -> English lookup; variants of the same word are merged (e.g. gut/gute -> good),
# filler words without a translation here (e.g. immer, finde, dabei) are dropped
dict <- read.csv(text = "de,en
gut,good
gute,good
guter,good
guten,good
beste,best
top,great
super,great
mega,great
toll,great
inhalte,content
mehr,more
videos,videos
vorlesungsvideos,videos
übungen,exercises
übung,exercises
übungsaufgaben,exercises
aufgaben,assignments
aufgabe,assignments
kurs,course
veranstaltung,course
seminar,seminar
dozent,lecturer
dozenten,lecturer
kompetenter,competent
strukturiert,structured
strukturierte,structured
struktur,structure
aufbau,structure
übersichtlich,well-organised
übersichtliche,well-organised
stata,Stata
slack,Slack
hilfreich,helpful
geholfen,helpful
helfen,helpful
einfach,easy
fragen,questions
antworten,answers
folien,slides
digitale,digital
online,online
besser,better
beispiele,examples
anwendungsbeispiele,examples
erklärt,explanations
erklärungen,explanations
erklärung,explanations
erklären,explanations
themen,topics
thema,topics
wissen,knowledge
verstehen,understanding
verstanden,understanding
verständlich,clear
klar,clear
nachvollziehbar,clear
anschaulich,illustrative
anschauliche,illustrative
dank,thanks
feedback,feedback
methoden,methods
modelle,models
lernen,learning
gelernte,learning
praktische,practical
praxis,practical
anwendung,application
anzuwenden,application
umzusetzen,application
vorlesung,lecture
studierenden,students
mitstudierenden,students
kommiliton,students
neue,new
neues,new
plattform,platform
niveau,level
angenehm,pleasant
tempo,pace
komplexe,complex
abstrakte,abstract
lösungen,solutions
lösen,solutions
vermittelt,teaching
vermittlung,teaching
lehre,teaching
spaß,fun
spannend,exciting
spannendes,exciting
spannende,exciting
motiviert,motivated
atmosphäre,atmosphere
lernatmosphäre,atmosphere
sitzungen,sessions
sitzung,sessions
session,sessions
ausführlich,detailed
ausführliche,detailed
forschungspraktikum,research
forschung,research
analyse,analysis
datenanalyse,analysis
erfahrung,experience
möglichkeit,opportunities
möglichkeiten,opportunities
probleme,problems
relevant,relevant
anspruchsvoll,challenging
geeignet,suitable
paper,papers
englisch,English
englischen,English
theoretischer,theory
corona,COVID", fileEncoding = "UTF-8")

words <- data.frame(de = names(topfeatures(DFM, 300)),
                    n = unname(topfeatures(DFM, 300))) %>%
  inner_join(dict, by = "de") %>%
  group_by(word = en) %>%
  summarise(n = sum(n)) %>%
  arrange(desc(n)) %>%
  slice_head(n = 60) %>%
  mutate(face = ifelse(row_number() <= 8, "bold", "plain")) # top words in bold

set.seed(7)
p_cloud <- ggplot(words, aes(label = word, size = n, alpha = n, fontface = face)) +
  geom_text_wordcloud(family = fnt, colour = col_base, shape = "circle",
                      eccentricity = 0.55, rm_outside = TRUE, grid_margin = 1.6) +
  scale_size_area(max_size = 14) +
  scale_alpha_continuous(range = c(0.45, 1), guide = "none") + # rarer words fade out
  theme_void(base_family = fnt) +
  theme(plot.margin = margin(4, 14, 4, 14))

# standalone file (placeholder colours)
ggsave("out/wordcloud_en.svg", p_cloud, device = svglite::svglite,
       width = 4, height = 3.2, bg = "transparent")

# themed copy that the courses page includes inline
svg_cloud <- readLines("out/wordcloud_en.svg", encoding = "UTF-8")
svg_cloud <- svg_cloud[!grepl("^<\\?xml", svg_cloud) & svg_cloud != ""]
svg_cloud <- gsub(col_base, "var(--global-base-color)", svg_cloud, ignore.case = TRUE)
dir.create("../../_includes/teaching", showWarnings = FALSE)
writeLines(svg_cloud, "../../_includes/teaching/wordcloud_en.svg", useBytes = TRUE)


### positive and negative terms

packages <- c("quanteda", "tidytext", "dplyr",
              "magrittr", "reshape2", "translateR")
lapply(packages, library, character.only = TRUE)

translate(evaluations, target = "en",
          google.api.key) ## needs to register (and pay?) Google API

d <- tibble(txt = evaluations)

evaluations_tidy <- d %>%
  unnest_tokens(word, txt)

evaluations_tidy <- evaluations_tidy %>%
  anti_join(get_stopwords())%>%
  anti_join(get_stopwords("german"))

evaluations_tidy %>%
  count(word, sort = TRUE)

bing <- get_sentiments("bing")
positive <- get_sentiments("bing") %>%
  filter(sentiment == "positive")
negative <- get_sentiments("bing") %>%
  filter(sentiment == "negative")

evaluations_tidy %>%
  semi_join(positive) %>%
  count(word, sort = TRUE) # 12 positive (english) words
evaluations_tidy %>%
  semi_join(negative) %>%
  count(word, sort = TRUE) # 4 negative (english) words

12/4 # odds of negative terms 2.6 higher than positive term


evaluations_senti <- evaluations_tidy %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE)


# plot
evaluations_senti %>%
  inner_join(bing) %>%
  acast(word ~ sentiment, value.var = "n", fill = 0) %>%
  comparison.cloud(colors = c("#F8766D", "#00BFC4"), max.words = 100
  )
dev.off()



## sentiment analysis

# create dictionary (see https://www.inwt-statistics.de/blog-artikel-lesen/text-mining-part-3-sentiment-analyse.html)
SentiWS <- c(
  readLines("C:/Users/czymara.local/Google Drive/job/zonstiges/spielRei/twitter/SentiWS_v2.0_Positive.txt",
            encoding = "UTF-8"),
  readLines("C:/Users/czymara.local/Google Drive/job/zonstiges/spielRei/twitter/SentiWS_v2.0_Negative.txt",
            encoding = "UTF-8")
) %>% lapply(function(x) {
  # Extrahieren der einzelnen Spalten
  res <- strsplit(x, "\t", fixed = TRUE)[[1]]
  return(data.frame(word = res[1], value = res[2],
                    stringsAsFactors = FALSE))
}) %>%
  bind_rows %>%
  mutate(word = gsub("\\|.*", "", word) %>% tolower,
         value = as.numeric(value)) %>%
  # manche Wörter kommen doppelt vor, hier nehmen wir den mittleren Wert
  group_by(word) %>% summarise(value = mean(value)) %>% ungroup



DFM %>%
  inner_join(SentiWS) %>%
  count(word, sort = TRUE)

words <- NULL
words$word <- colnames(DFM)

# mean sentiment
sentTwt <- left_join(words,
                     SentiWS,
                     by = "word") %>%
  mutate(value = as.numeric(value)) %>%
  filter(!is.na(value))

mean(sentTwt$value) # negative

