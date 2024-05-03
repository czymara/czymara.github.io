
library(scholar)
library(wordcloud)
library(RColorBrewer)

pubs <- get_publications("khPqHmgAAAAJ")


wordcloud::wordcloud(pubs$title)


wordcloud::wordcloud(pubs$title, min.freq = 2,
          max.words=100, random.order=FALSE,
          scale=c(2, .75),
          colors=brewer.pal(8, "Dark2")
          )

