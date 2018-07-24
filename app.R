library(shiny)
source("read_input_data.R")
dt <- load_data()
# Define UI for miles per gallon app ----
ui <- basicPage(
  h2("The data"),
  DT::dataTableOutput("mytable")
)

# Define server logic to plot various variables against mpg ----
server <- function(input, output) {
  
  output$mytable = DT::renderDataTable({
    dt
  })
}

shinyApp(ui, server)