#install.packages('sf')
devtools::install_github("tylermorganwall/rayshader")
library(lubridate)
library(ggplot2)
library(lubridate)

#get season function
getSeason<-function(date){
  if (date > 11 | date <= 3){
    return ("WINTER")
  }
  else if (date == 4 | date == 5){
    return ("SPRING")
  }
  else if (date >=6 & date <= 9){
    return ("SUMMER")
  }
  else{
    return ("FALL")
  }
}
earthquake <- read.csv(file = 'C:/Users/Zahra Salarian/Documents/R/4/iran.csv')
months<-as_tibble(month(earthquake$time))
months<-months%>%
  group_by(value)%>%
  mutate(count = n())
months <- unique(months[order(-months$count),])
seasons<-months%>%
  mutate(season = getSeason(value))
seasons[1]<-NULL
seasons<-seasons %>% 
  group_by(season) %>% 
  summarise(total_quake = sum(count))

#draw plot
ggplot(seasons,
       aes(x = season,y=total_quake,
           fill=season
       )) +
  geom_bar(stat = "identity")
