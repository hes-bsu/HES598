
library(dplyr)
library(ggplot2)

setwd("~/Google Drive/Git/HES598/Flexdashboard")
BMAcrop<-read.csv("./BMACrop2005_2018.csv")
BMAcrop<-BMAcrop %>%
  filter(value > 0, Crop_0_1>0) 

selectedData<-
  BMAcrop %>%
    filter(county == "Ada" & Category == " Corn")

ggplot(selectedData, aes(x=year,y=acres))+
  geom_bar(stat="identity")