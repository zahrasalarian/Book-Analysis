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
tidytext <- data_frame(line = 1:nrow(books_tbl), text = books_tbl$text) %>%
  unnest_tokens(word, text,to_lower = FALSE)
tidytext$chapter <- 0
tidytext$chapter[unlist(mapply(":", which(tidytext$word == "I"), which(df$time == "II")))] <- 1
#characters name
#tidy_characters<- data_frame(line = 1:nrow(books_tbl), text = books_tbl$text, title=books_tbl$title) %>%
#  unnest_tokens(word, text,to_lower = FALSE) %>%
#  anti_join(stop_words)%>%
#  group_by(title)%>%
#  count(word, sort = TRUE)
