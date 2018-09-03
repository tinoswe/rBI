library(shiny)

ui <-  fluidPage(
  checkboxGroupInput(inputId="test.check", label="", choices="Uncheck For 2", selected="Uncheck For 2"),
  verbatimTextOutput(outputId = "test")
)

server <- function(input, output) {
  output$test <- renderPrint({
    if(!is.null(input$test.check)) {
      1
    } else{
      2
    }
  })
}

shinyApp(ui = ui, server = server)
