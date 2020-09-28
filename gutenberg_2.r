#install.packages("gutenbergr")
library("gutenbergr")
library(tidytext)
library(magrittr)
library(ggplot2)
library(dplyr)
library(stringr)

# download all books from Charles Dickens
books <- c("The Pickwick Papers","Oliver Twist",
           "Nicholas Nickleby","The Old Curiosity Shop",
           "Barnaby Rudge","Martin Chuzzlewit",
           "Dombey and Son","David Copperfield",
           "Bleak House","Hard Times",
           "Little Dorrit","A Tale of Two Cities",
           "Great Expectations","Our Mutual Friend",
           "The Mystery of Edwin Drood")
books_id = c()
for(book in books){
  id <-gutenberg_works(title == book)[[1]]
  books_id<-c(id,books_id)
}
books_tbl <- gutenberg_download(books_id,meta_fields = "title") 

#characters name
tidy_characters<- data_frame(line = 1:nrow(books_tbl), text = books_tbl$text, title=books_tbl$title) %>%
  unnest_tokens(word, text,to_lower = FALSE) %>%
  anti_join(stop_words)%>%
  group_by(title)%>%
  count(word, sort = TRUE)

tidytext_name<-tidy_characters%>%
  filter(str_detect(word,"[A-Z][a-z]+"))
names<-tidytext_name[[2]] 
tidytext_word<-tidy_characters%>%
   filter(str_detect(word,"[A-Za-z]+"))
words<-tidytext_word[[2]]
names_table <-unique(names[!str_to_lower(names)%in%words])
#delete some words manually
names_table<-as_tibble(names_table [! names_table %in% c("Mr","Mrs","He","She",
                                                "The","But","It","And","You","We","My","What","No")])
names(names_table)<-"word"
names_table<-inner_join(x = tidytext_name, y = names_table, by = "word")
names(names_table)[1]<-"title_of_book"
names_table <- names_table[order(names_table$title_of_book,-names_table$n),]
names_table<-names_table%>%
  group_by(title_of_book) %>%
  top_n(n = 5)
ggplot(names_table,
       aes(y = word,x=n,
           fill = title_of_book
       )) +
  geom_bar(stat = "identity")+
  scale_y_discrete(guide=guide_axis(n.dodge=2))