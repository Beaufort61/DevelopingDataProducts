
library(shiny)
library(ggplot2)
library(Hmisc)

  gdp <- read.csv("./NzEnergyPriceIndexes.csv", fill = TRUE,  na.strings=c(".."))
  gdp$Date <- as.Date(ISOdate(substring(gdp$Date, 1, 4) ,3 * as.numeric(substring(gdp$Date, 6, 6)), 1))


shinyServer(
  function(input, output) {
    
    slice <- reactive( { gdp[(gdp$Date >= input$daterange[1]) & (gdp$Date <= input$daterange[2]),] } )
    
    volatility <- reactive( { a <- gdp[(gdp$Date >= input$daterange[1]) & (gdp$Date <= input$daterange[2]),]
                              f <- paste(input$Sector, " ~ Date" )
                              round(summary(aov(lm(data=a, formula=f)))[[1]]$"Mean Sq"[2])
    } )
                              
    output$priceIndicator <- renderPlot( {
      ggplot(slice(), aes_string("Date", input$Sector)) + geom_line() + stat_summary(fun.data=mean_cl_normal) + geom_smooth(method='lm')
    } )
    
    output$priceVolatility <- renderText( {
      paste("Anaylsis of variance calculates the mean square for residuals as", volatility(), "which is a consistent measure of volatility.")
    } )
  }
)