library(shiny)
library(ggplot2)
library(dplyr)

BMAcrop<-read.csv("./BMACrop2005_2018.csv")
BMAcrop<-BMAcrop %>%
  filter(value > 0, Crop_0_1>0) 
Categories<-as.character(BMAcrop$Category)

ui<-fluidPage(

titlePanel("downloaded from USDA NASS Cropscape."),
sidebarLayout(
sidebarPanel(
  selectInput("county", label="County:", choices = c("Ada", "Canyon"), selected ="Ada"),
  
  selectInput("Category", label="CropType:", choices = Categories, selected ="Corn")
  
), 
mainPanel(plotOutput("myplot"))
)
)

server<-function(input,ouput)
  {
  output$myplot<-renderPlot(ggplot(BMAcrop, aes(x=year,y=acres))+
                            geom_bar(data=BMAcrop[,c(BMAcrop$county==input$county, BMAcrop$Category==input$Category)])
  )                           
}

shinyApp(ui=ui, server=server)