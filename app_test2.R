library(dplyr)
library(ggplot2)
library(shiny)

raw <- diamonds
cutlist <- sort(unique(as.vector(raw$cut)), decreasing = FALSE) %>%
  append("All", after =  0)
colorlist <- sort(unique(as.vector(raw$color)), decreasing = FALSE) %>%
  append("All", 0)

server <- function(input, output) {
  output$table <- renderDataTable({
    if(input$colorchoose == "All") { 
      filt1 <- quote(color != "@?><")
    } else { filt1 <- quote(color == input$colorchoose) }
    if (input$cutchoose == "All") { 
      filt2 <- quote(cut != "@?><")
    } else { filt2 <- quote(cut == input$cutchoose) }
    filter_(raw, filt1) %>% filter_(filt2) } ) }

ui <- shinyUI(fluidPage(
  titlePanel("Dynamic Filter Test App"),
  sidebarLayout(
    sidebarPanel(
      selectizeInput("cutchoose", "Cut:", cutlist),
      selectizeInput("colorchoose", "color:", colorlist) ),
    mainPanel( dataTableOutput("table") ) ) ) )

shinyApp(ui = ui, server = server)

