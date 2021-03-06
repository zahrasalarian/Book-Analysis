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

#Number of repetitions of words
tidytext <- data_frame(line = 1:nrow(books_tbl), text = books_tbl$text) %>%
 unnest_tokens(word, text) %>%
  anti_join(stop_words)
tidytext[1]<-NULL
tidytext<-tidytext%>%
  group_by(word)%>%
  count(word, sort = TRUE)

#tidytext['n'] <- sqrt(tidytext['n'])
tidytext_bar<-head(tidytext,20)
#draw plot
ggplot(tidytext_bar,aes(x=word, y=n))+
  geom_bar(stat="identity",fill="#fbcbc9")+
  geom_label(aes(label = word))

#wordcloud
library(devtools) 
#install_github("lchiffon/wordcloud2")
library(wordcloud2)
#figPath = system.file("dickens.jpg",package = "wordcloud2")
tidytext_cloud<-head(tidytext,200)
#tidytext_cloud['n'] <- sqrt(tidytext_cloud['n'])
figPath = system.file('examples/t.png', package = 'wordcloud2')
#simple wordcloud
wordcloud2(data = tidytext_cloud, size = ,color='random-dark')

#wordcloud with pic(it didn't work on my system but i put the code here)
#wordcloud2(data = tidytext_cloud,figPath=figPath, size = ,color='random-dark')