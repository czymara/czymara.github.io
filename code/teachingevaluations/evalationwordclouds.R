

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


### wordcloud
win.metafile("out/eval_wordcloud.wmf")

textplot_wordcloud(DFM,
                  # min_size = 1.5,
                 #  min_count = 3,
                   color = "black",
                 adjust = )
# dev.copy(png, width = 350, height = 350, "C:/Users/czymara.local/Nextcloud/teaching/teachingevaluations/out/eval_wordcloud.png")
dev.off()


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

