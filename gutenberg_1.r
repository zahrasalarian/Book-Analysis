#install.packages("gutenbergr")
library("gutenbergr")
library(tidytext)
library(magrittr)
library(ggplot2)
library(dplyr)

to_download <- gutenberg_metadata%>%
  filter((author == "Dickens, Charles")&(!is.na(gutenberg_bookshelf))&has_text&(language == "en"))
book_id<- as.vector(unlist(to_download$gutenberg_id))
books_tbl <- gutenberg_download(book_id, meta_fields = "title")

# download all books from Charles Dickens
#dickes <- gutenberg_works(author == "Dickens, Charles") %>%
#  gutenberg_download(meta_fields = "title")
#aliceref <-gutenberg_works(title == "A Christmas Carol")
#books_tbl <- gutenberg_download(aliceref$gutenberg_id) %>% gutenberg_strip()
tidytext <- data_frame(line = 1:nrow(books_tbl), text = books_tbl$text) %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  count(word, sort = TRUE)
tidytext<-head(tidytext,20)
ggplot(tidytext,aes(x=word, y=n))+
geom_bar(stat="identity", fill="red")
  #geom_bar(height=head(tidytext,10)$n, names.arg=head(tidytext,10)$word, xlab="Mots", ylab="Fréquence", col="#973232", main="Alice in Wonderland")

#words <- plato %>% unnest_tokens(word,text)

#books <- list(
 # A_Christmas_Carol_in_Prose = books_tbl[title=="A Christmas Carol in Prose; Being a Ghost Story of Christmas"],
#  A_Tale_of_Two_Cities = books_tbl[title=="A Tale of Two Cities"],
 # The_Mystery_of_Edwin_Drood = books_tbl[title=="The Mystery of Edwin Drood"],
#  The_Pickwick_Papers = books_tbl[title=="The Pickwick Papers"],
 # The_Haunted_Man_and_the_Ghosts_Bargain = books_tbl[title=="The Haunted Man and the Ghost's Bargain"],
#  The_Cricket_on_the_Hearth =books_tbl[title=="The Cricket on the Hearth: A Fairy Tale of Home"],
 # A_Childs_History_of_England = books_tbl[title=="A Child's History of England"],
#  David_Copperfield = books_tbl[title=="David Copperfield"],
 # Hunted_Down= books_tbl[title=="Hunted Down: The Detective Stories of Charles Dickens"],
  #Holiday_Romance = books_tbl[title=="Holiday Romance"],
#  Barnaby_Rudge = books_tbl[title=="Barnaby Rudge: A Tale of the Riots of 'Eighty"],
 # Martin_Chuzzlewit = books_tbl[title=="Martin Chuzzlewit"],
  #Great_Expectations = books_tbl[title=="Great Expectations"],
#  Some_Christmas_Stories = books_tbl[title=="Some Christmas Stories"],
 # A_Christmas_Carol_1 = books_tbl[gutenburg_id==19337],
  #A_Christmas_Carol_2 = books_tbl[gutenburg_id==19505],
  #The_Cricket_on_the_Hearth = books_tbl[title=="The Cricket on the Hearth"],
  #The_Magic_Fishbone  = books_tbl[gutenberg_id==23344],
  #The_Trial_of_William_Tinkling  = books_tbl[gutenberg_id==23452],
  #Captain_Boldheart = books_tbl[gutenberg_id==23765],
  #A_Christmas_Carol = books_tbl[title=="A Christmas Carol"]
  #) %>%
  #ldply(rbind) %>%
#  gather(key = 'chapter', value = 'text', -book) %>%
 # filter(!is.na(text)) 