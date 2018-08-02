library(shiny)
library(dplyr)
library(tidyr)
library(DT)

source("read_input_data.R")
dt <- load_data()
unq_flts <- dt[,c("Practice","Grade","HeatID","Year","Month","Day")]

year_list <- sort(unique(as.vector(dt$Year)), decreasing = FALSE) #%>% append("All", after =  0)
month_list <- sort(unique(as.vector(dt$Month)), decreasing = FALSE) #%>% append("All", after =  0)
day_list <- sort(unique(as.vector(dt$Day)), decreasing = FALSE) #%>% append("All", after =  0)
practice_list <- sort(unique(as.vector(dt$Practice)), decreasing = FALSE) #%>% append("All", after =  0)
grade_list <- sort(unique(as.vector(dt$Grade)), decreasing = FALSE) #%>% append("All", after =  0)
heat_list <- sort(unique(as.vector(dt$HeatID)), decreasing = FALSE) #%>% append("All", after =  0)

# All cells at 300 pixels wide, with cell padding
# and a border around everything
ui <- splitLayout(
   style = "border: 1px solid silver;",
   cellWidths = 300,
   cellArgs = list(style = "padding: 6px"),
   
 )


server <- function(input, output) {
}


shinyApp(ui, server)