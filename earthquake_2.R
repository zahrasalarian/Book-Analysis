#install.packages('sf')
#devtools::install_github("tylermorganwall/rayshader")
library(lubridate)
library(ggplot2)
library(lubridate)
earthquake <- read.csv(file = 'C:/Users/Zahra Salarian/Documents/R/4/iran.csv')
seasons<-earthquake%>%
    mutate(season = case_when(
    month(time) %in% 10:12 ~ "FALL" ,
    month(time) %in%  4:6  ~ "SPRING" ,
    month(time) %in%  1:3  ~ "WINTER" ,
    TRUE ~ "SUMMER"))%>%
  group_by(season)%>%
  count()

#draw plot
ggplot(seasons,
       aes(x = season,y=n,
           fill=season
       )) +
  geom_bar(stat = "identity")
