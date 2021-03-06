#install.packages("gutenbergr")
library("gutenbergr")
library(tidytext)
library(magrittr)
library(ggplot2)
library(dplyr)
library(stringr)
require(tidyr)
books <- c("Les MisÚrables, v. 1/5: Fantine",
           "Les MisÚrables, v. 2/5: Cosette",
           "Les MisÚrables, v. 3/5: Marius",
           "Les MisÚrables, v. 4/5: The Idyll and the Epic",
           "Les MisÚrables, v. 5/5: Jean Valjean")
books_id = c()
for(book in books){
  id <-gutenberg_works(title == book)[[1]]
  books_id<-c(id,books_id)
}
books_tbl <- gutenberg_download(books_id,meta_fields = "title") 
tidytext <- data_frame(line = 1:nrow(books_tbl), text = books_tbl$text) %>%
  unnest_tokens(word, text)

#verbs for women
women <- tidytext%>%
  filter((lag(word)=="she"))%>%
  group_by(word)%>%
  count()%>%
  arrange(-n)%>%
  head(20)%>%
  mutate(gender="women")

#verbs for men
men <- tidytext%>%
  filter((lag(word)=="he"))%>%
  group_by(word)%>%
  count()%>%
  arrange(-n)%>%
  head(20)%>%
  mutate(gender="men")

#combine tables
women_men <- rbind(women, men)

#draw plot
ggplot(women_men,
       aes(x = n,y=word,
           fill = gender
       )) +
  geom_bar(stat = "identity")
  #scale_y_discrete(guide=guide_axis(n.dodge=2))