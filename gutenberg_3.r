#install.packages("gutenbergr")
library("gutenbergr")
library(tidytext)
library(magrittr)
library(ggplot2)
library(dplyr)
library(stringr)
require(tidyr)
books <- c("Les Misérables, v. 1/5: Fantine",
           "Les Misérables, v. 2/5: Cosette",
           "Les Misérables, v. 3/5: Marius",
           "Les Misérables, v. 4/5: The Idyll and the Epic",
           "Les Misérables, v. 5/5: Jean Valjean")
books_id = c()
for(book in books){
  id <-gutenberg_works(title == book)[[1]]
  books_id<-c(id,books_id)
}
books_tbl <- gutenberg_download(books_id,meta_fields = "title") 
#divide into 200 pieces
tidytext <- data_frame(line = 1:nrow(books_tbl), text = books_tbl$text) %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)
tidytext$id <- seq.int(nrow(tidytext))
#n<- 200
#pieces <- split(tidytext, rep(1:n, length.out=nr))
#pieces<-tidytext[, parallel_operation(.SD), by = parallel.id] 
tidytext$group <- as.numeric(cut(tidytext$id, 200))
#bing <- get_sentiments("bing")