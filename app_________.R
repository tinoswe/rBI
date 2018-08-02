library(shiny)
library(ggplot2)
data(diamonds)
hw <- diamonds

runApp(
  list(
    ui=(
      fluidPage(
        title = 'Examples of DataTables',
        sidebarLayout(
          sidebarPanel(
            actionButton("selectall", label="Select/Deselect all"),
            checkboxGroupInput('show_vars', 'Columns in diamonds to show:',
                               names(hw), selected = names(hw))
            
          ),
          mainPanel(
            verbatimTextOutput("summary"),
            tabsetPanel(
              id = 'dataset',
              tabPanel('hw', dataTableOutput('mytable1'))
            ))))),
    
    server = (function(input, output, session) {
      output$summary <- renderPrint({
        dataset <- hw[, input$show_vars, drop = FALSE]
        summary(dataset)
      })
      observe({
        if (input$selectall > 0) {
          if (input$selectall %% 2 == 0){
            updateCheckboxGroupInput(session=session, inputId="show_vars",
                                     choices = list("carat" = "carat",
                                                    "cut" = "cut",
                                                    "color" = "color",
                                                    "clarity"= "clarity",
                                                    "depth" = "depth",
                                                    "table" = "table",
                                                    "price" = "price",
                                                    "x" = "x",
                                                    "y" = "y",
                                                    "z" = "z"),
                                     selected = c(names(hw)))
            
          }
          else {
            updateCheckboxGroupInput(session=session, inputId="show_vars",
                                     choices = list("carat" = "carat",
                                                    "cut" = "cut",
                                                    "color" = "color",
                                                    "clarity"= "clarity",
                                                    "depth" = "depth",
                                                    "table" = "table",
                                                    "price" = "price",
                                                    "x" = "x",
                                                    "y" = "y",
                                                    "z" = "z"),
                                     selected = c())
            
          }}
      })
      
      # a large table, reative to input$show_vars
      output$mytable1 <- renderDataTable({
        if (is.null(input$show_vars)){
          data.frame("no variables selected" = c("no variables selected"))
        } else{
          hw[, input$show_vars, drop = FALSE]
        }
        
      })
    })
    
  )
  )