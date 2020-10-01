#install.packages('sf')
devtools::install_github("tylermorganwall/rayshader")
library(lubridate)
library(ggplot2)
library(stringr)
earthquake <- read.csv(file = 'C:/Users/Zahra Salarian/Documents/R/4/iran.csv')
#select cities in iran
earthquake<-earthquake%>%
  mutate(city =str_match(place, "of\\s*(.*?)\\s*, Iran")[,2])%>%
  group_by(city)%>%
  count()%>%
  #detect the safest cities
  filter(n <= 2)%>%
  summarise(city,n)
earthquake<-earthquake[!(is.na(earthquake$city)),]
#draw plot of safest cities
ggplot(earthquake,
       aes(y = city,x=n,fill=n
       )) +
  geom_bar(stat = "identity")+
  scale_y_discrete(guide=guide_axis(n.dodge=2))