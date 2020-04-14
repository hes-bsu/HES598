library(shiny)
library(ggplot2)
library(dplyr)

BMAcrop<-read.csv("./BMACrop2005_2018.csv")
BMAcrop<-BMAcrop %>%
  filter(value > 0, Crop_0_1>0) 
Categories<-as.character(BMAcrop$Category)

ui<-fluidPage(

titlePanel("Number of acres of the crops grown in the Treasure Valley, ID from 2005 to 2018. Data was downloaded from USDA NASS Cropscape."),
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
  
  dataInput<-reactive(BMAcrop %>%
                        filter(county == input$county & Category == input$Category))
  output$myplot<-renderPlot({ggplot(dataInput, aes(x=year,y=acres))+
                            #geom_bar(data=BMAcrop[,c(BMAcrop$county==input$county, BMAcrop$Category==input$Category)], stat = "identity")
                              geom_bar( stat = "identity")
  })                           
}

shinyApp(ui=ui, server=server)
