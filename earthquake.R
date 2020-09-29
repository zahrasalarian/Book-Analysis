library(lubridate)
earthquake <- read.csv(file = 'C:/Users/Zahra Salarian/Documents/R/4/iran.csv')
#t <- earthquake%>%
#  filter(mag>=6)
inds = which((earthquake$mag>=6)&
               (day(earthquake$time)==day(lead(earthquake$time,1)))
             &(lead(earthquake$mag,1)<5))
rows <- lapply(inds, function(x) x:(x+1))
earthquake<-earthquake[unlist(rows),]

ggplot(earthquake,
       aes(x = mag,y=time,
           fill = time
       )) +
  geom_bar(stat = "identity")
