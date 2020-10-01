library(remotes)
install_github("andrewheiss/quRan")
library(quRan)
library(tidyverse)
library(quRan)
library(tidytext)
library(dplyr)
text <- quran_ar_min
tidytext <- data_frame(line = 1:nrow(quran_ar_min), text = quran_ar_min$text) %>%
  unnest_tokens(word, text)
tidytext[1]<-NULL
words<-tidytext%>%
  group_by(word)%>%
  mutate(num = n())
words <- unique(words[order(-words$num),])
