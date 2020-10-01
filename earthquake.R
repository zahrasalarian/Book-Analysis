library(lubridate)
earthquake <- read.csv(file = 'C:/Users/Zahra Salarian/Documents/R/4/iran.csv')

#get big earthquakes that had prequake before them
inds = which((earthquake$mag>=6)&
               (day(earthquake$time)==day(lead(earthquake$time,1)))
             &(lead(earthquake$mag,1)<5))
rows <- lapply(inds, function(x) x:(x+1))
earthquake<-earthquake[unlist(rows),]
earthquake<-earthquake%>%
  mutate(label = ifelse(earthquake$mag>=6,'main_quake','pre_quake'))
ggplot(earthquake,
       aes(x = mag,y=time,
           fill = label
       )) +
  geom_bar(stat = "identity")
