
gdp <- read.csv("./NzEnergyPriceIndexes.csv", fill = TRUE,  na.strings=c(".."))
gdp$Date <- as.Date(ISOdate(substring(gdp$Date, 1, 4) ,3 * as.numeric(substring(gdp$Date, 6, 6)), 1))

sectors <- colnames(gdp)
sectors <- sectors[!(sectors=="Date"|sectors=="dtm")]

shinyUI(pageWithSidebar(
  headerPanel("New Zealand Energy Prices"),
  sidebarPanel( selectInput("Sector", "Sector:", sectors),
                dateRangeInput("daterange", "Date range:", start = "1989-01-01", end="2015-01-01")
               ),
  
  mainPanel(plotOutput('priceIndicator'), textOutput('priceVolatility'))
))

