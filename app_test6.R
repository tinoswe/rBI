library(shiny)
library(shinydashboard)
library(shinyWidgets)
##
ui <- shinyUI({
  sidebarPanel(
    
    htmlOutput("brand_selector"),
    htmlOutput("candy_selector"))
  
})
##
server <- shinyServer(function(input, output,session) {
  candyData <- read.table(
    text = "Brand       Candy
    Nestle      100Grand
    Netle       Butterfinger
    Nestle      Crunch
    Hershey's   KitKat
    Hershey's   Reeses
    Hershey's   Mounds
    Mars        Snickers
    Mars        Twix
    Mars        M&Ms",
    header = TRUE,
    stringsAsFactors = FALSE)
  
  observeEvent({
    input$candy
  },
  {
    available2 <- candyData
    if(NROW(input$candy) > 0 ) available2 <- candyData[candyData$Candy %in% input$candy, ]
    updatePickerInput(
      session = session,
      inputId = "brand", 
      choices = as.character(unique(available2$Brand)),
      selected = input$brand
    )
  },
  ignoreInit = FALSE,
  ignoreNULL = FALSE)

  output$brand_selector <- renderUI({
    
    pickerInput(
      inputId = "brand", 
      label = "Brand:",
      choices = NULL,
      multiple = T,options = list(`actions-box` = TRUE))
    
  })
    
  observeEvent({
    input$brand
  },{
    available <- candyData
    if(NROW(input$brand > 0)) available <- candyData[candyData$Brand %in% input$brand, ]
    updatePickerInput(
      session = session,
      inputId = "candy",
      choices = unique(available$Candy),
      selected = input$candy
    )
  },
  ignoreInit = FALSE,
  ignoreNULL = FALSE)
  
  output$candy_selector <- renderUI({
    
    pickerInput(
      inputId = "candy", 
      label = "Candy:",
      choices = NULL,
      multiple = T,options = list(`actions-box` = TRUE))
    
  })
  
})
##
shinyApp(ui = ui, server = server)
