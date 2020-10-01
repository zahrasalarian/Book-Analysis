library("gutenbergr")
library(tidytext)
library(magrittr)
library(ggplot2)
library(dplyr)
library(stringr)

#download Robinson, Frank M books
books_id<-gutenberg_works(author == 'Robinson, Frank M.')[[1]]
books_tbl <- gutenberg_download(books_id,meta_fields = "title") 
tidytext <- data_frame(line = 1:nrow(books_tbl), text = books_tbl$text) %>%
  unnest_lines(word, text,to_lower = FALSE)

#seperate chapters
chapters<-books_tbl%>%
  group_by(title)%>%
  mutate(chapter = cumsum((str_detect(text, regex("CHAPTER [ILVX]+|CHAPTER [1-9]+|^[ILVX]+\\."))))
  )%>%
  group_by(title,chapter)%>%
  filter(n()>50)%>%
  summarise(text = paste0(text, collapse = " "))

#unigram
unigrams_per_chapter<-chapters%>%
  unnest_tokens(unigram, text, token = "ngrams", n = 1)%>%
  group_by(title,chapter)%>%
  count(unigram)%>%
  separate(unigram, c("word"), sep = " ")%>%
  filter(!word %in% stop_words$word)

freq_rank_uni_per_chapter<-unigrams_per_chapter%>%  
  group_by(title,chapter)%>%
  arrange(n)%>%
  mutate(freq=n/n(),rank=last(row_number())-row_number())%>%
  arrange(title,chapter,rank)

#bigram
bigrams_per_chapter<-chapters%>%
  unnest_tokens(bigram, text, token = "ngrams", n = 2)%>%
  group_by(title,chapter)%>%
  count(bigram)%>%
  separate(bigram, c("word_1", "word_2"), sep = " ")%>%
  filter(!word_1 %in% stop_words$word) %>%
  filter(!word_2 %in% stop_words$word)


freq_rank_bi_per_chapter<-bigrams_per_chapter%>%  
  group_by(title,chapter)%>%
  arrange(n)%>%
  mutate(freq=n/n(),rank=last(row_number())-row_number())%>%
  arrange(title,chapter,rank)

freqs_by_chapter<-
  rbind(freq_rank_bi_per_chapter%>%select(rank,freq,title,chapter)%>%mutate(ngram="bigram"),
        freq_rank_uni_per_chapter%>%select(rank,freq,title,chapter)%>%mutate(ngram="unigram"))

freqs_by_chapter<-freqs_by_chapter%>%
  mutate(title=str_trim(title))

#draw plot
ggplot(freqs_by_chapter,aes(rank,freq,color=ngram))+
  geom_point()+
  scale_x_log10()+
  scale_y_log10()+
  facet_wrap(~title)