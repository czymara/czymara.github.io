

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


### wordcloud (website): inline SVG that follows the site's light/dark theme
library(ggplot2)
library(dplyr)
library(ggwordcloud)
col_base  <- "#4B2E83" # -> var(--global-base-color)
col_light <- "#9DA1A4" # -> var(--global-text-color-light)
fnt <- "IBM Plex Sans" # site font; needs to be installed locally

words <- data.frame(word = names(topfeatures(DFM, 150)),
                    n = unname(topfeatures(DFM, 150))) %>%
  mutate(top = n >= quantile(n, 0.8), # most frequent words in violet, rest in grey
         angle = ifelse(row_number() %% 6 == 0, 90, 0))

set.seed(42)
p_cloud <- ggplot(words, aes(label = word, size = n, colour = top, angle = angle)) +
  geom_text_wordcloud(family = fnt, shape = "circle", eccentricity = 0.65,
                      rm_outside = TRUE, grid_margin = 1.2) +
  scale_size_area(max_size = 11) +
  scale_colour_manual(values = c("TRUE" = col_base, "FALSE" = col_light), guide = "none") +
  theme_void(base_family = fnt) +
  theme(plot.margin = margin(4, 14, 4, 14))

# standalone file (placeholder colours)
ggsave("out/lehrewordcloud.svg", p_cloud, device = svglite::svglite,
       width = 4, height = 3.4, bg = "transparent")

# themed copy that the courses page includes inline
svg_cloud <- readLines("out/lehrewordcloud.svg", encoding = "UTF-8")
svg_cloud <- svg_cloud[!grepl("^<\\?xml", svg_cloud) & svg_cloud != ""]
svg_cloud <- gsub(col_base, "var(--global-base-color)", svg_cloud, ignore.case = TRUE)
svg_cloud <- gsub(col_light, "var(--global-text-color-light)", svg_cloud, ignore.case = TRUE)
dir.create("../../_includes/teaching", showWarnings = FALSE)
writeLines(svg_cloud, "../../_includes/teaching/lehrewordcloud.svg", useBytes = TRUE)


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

