#install.packages("gutenbergr")
library("gutenbergr")
library(tidytext)
library(magrittr)
library(ggplot2)
library(dplyr)
library(stringr)

#to_download <- gutenberg_metadata%>%
#  filter((author == "Dickens, Charles")&(!is.na(gutenberg_bookshelf))&has_text&(language == "en"))
#book_id<- as.vector(unlist(to_download$gutenberg_id))
#books_tbl <- gutenberg_download(book_id, meta_fields = "title")

# download all books from Charles Dickens
books <- c("The Pickwick Papers","Oliver Twist",
           "Nicholas Nickleby","The Old Curiosity Shop",
           "Barnaby Rudge","Martin Chuzzlewit",
           "Dombey and Son","David Copperfield",
           "Bleak House","Hard Times",
           "Little Dorrit","A Tale of Two Cities",
           "Great Expectations","Our Mutual Friend",
           "The Mystery of Edwin Drood")
#dickes <- gutenberg_works(author == "Dickens, Charles") %>%
#  gutenberg_download(meta_fields = "title")
books_id = c()
for(book in books){
  id <-gutenberg_works(title == book)[[1]]
  books_id<-c(id,books_id)
}
books_tbl <- gutenberg_download(books_id,meta_fields = "title") 

#(((())))
#tidytext <- data_frame(line = 1:nrow(books_tbl), text = books_tbl$text) %>%
# unnest_tokens(word, text) %>%
#  anti_join(stop_words) %>%
# count(word, sort = TRUE)
#t <- data_frame(line = 1:nrow(books_tbl), text = books_tbl$text) 

#tidytext['n'] <- sqrt(tidytext['n'])
#tidytext<-head(tidytext,20)
#ggplot(tidytext,aes(x=word, y=n))+
#  geom_bar(stat="identity", fill="red")

#wordcloud
library(devtools) 
#install_github("lchiffon/wordcloud2")
library(wordcloud2)
#figPath = system.file("dickens.jpg",package = "wordcloud2")
#wordcloud2(data = tidytext, size = 1.5,color='random-light', backgroundColor="black")


#characters name
#tidytext_2 <- data_frame(line = 1:nrow(books_tbl), text = books_tbl$text, title=books_tbl$title) %>%
#  unnest_tokens(word, text) %>%
#  anti_join(stop_words)%>%
#  group_by(title)%>%
# count(word, sort = TRUE)

#tidytext_3<-tidytext_2%>%
#  filter(str_detect(word,"[A-Z][a-z]+"))
#tidytext_4<-tidytext_2%>%
#  filter(str_detect(word,"[A-Za-z]+"))

#names <-names[!str_to_lower(names)%in%words]

#tidytext_2<- tidytext_2%>%
#  group_by(title,word)%>%
# mutate(n_word = n())
#tidytext_2<- distinct(tidytext_2)
#count(word, sort = TRUE)