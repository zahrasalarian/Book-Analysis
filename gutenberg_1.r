#install.packages("gutenbergr")
library("gutenbergr")
library(dplyr)

to_download <- gutenberg_metadata%>%
  filter((author == "Dickens, Charles")&(!is.na(gutenberg_bookshelf))&has_text&(language == "en"))
book_id<- as.vector(unlist(to_download$gutenberg_id))
books <- gutenberg_download(book_id, meta_fields = "title")