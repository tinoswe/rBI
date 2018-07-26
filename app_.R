library(shiny)
library(dplyr)
library(tidyr)
library()

source("read_input_data.R")
dt <- load_data()
setkey(dt)

unq_flts <- unique.matrix(dt[,c("Practice","Grade","HeatID","Year","Month","Day")])

ui <- fluidPage(
   
      fluidRow(
        
        column(3,
               wellPanel(
                 checkboxGroupInput("yearIn", "Year",
                                    choices = unique(unq_flts$Year),
                                    selected = ""),
                 checkboxGroupInput("monthIn", "Month",
                                    choices = unique(unq_flts$Month),
                                    selected = ""),
                 checkboxGroupInput("dayIn", "Day",
                                    choices = unique(unq_flts$Day),
                                    selected = ""),
                 checkboxGroupInput("practiceIn", "Practice",
                                    choices = unique(unq_flts$Practice),
                                    selected = ""),
                 checkboxGroupInput("gradeIn", "Grade",
                                    choices = unique(unq_flts$Grade),
                                    selected = ""),
                 checkboxGroupInput("heatIn", "Heat",
                                    choices = unique(unq_flts$HeatID),
                                    selected = "")
                 )
               ),
        
        column(9,
               dataTableOutput("results")
                               
               )
        )

)

server <- shinyServer(function(session, input, output) {
   
  output$results <- renderDataTable(dt,
                                    options = list(
                                      pageLength=100,
                                      ordering=FALSE,
                                      paging=FALSE,
                                      columns.searchable=FALSE,
                                      dom="t",
                                      columnDefs = list(list(visible=FALSE, targets=c(-1,-2,-3,-4,-5),
                                                        list(width="15%", targets=c(2))
                                                        #order = list(list(3, 'asc'))
                                                        )),
                                      autoWidth=FALSE
                                      )
                                    )
  
 })
 
 
 shinyApp(ui = ui, server = server)

