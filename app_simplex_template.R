require(shinydashboard)
shinyApp(
  ui = tagList(
    
    #shinythemes::themeSelector(),
    
    navbarPage(
      theme = "spacelab",  # <--- To use a theme, uncomment this
      "Plant L2 Data",
      tabPanel("Input data",
               sidebarPanel(
                 
                 fileInput("datafile", 
                           "File input:",
                           accept = c(
                             "text/csv",
                             "text/comma-separated-values,text/plain",
                             ".csv")),
                 fluidRow(
                   box(width = 12, 
                       title = "", 
                       splitLayout(
                         checkboxGroupInput("practiceIn", "Practice",
                                            choices = c(),
                                            selected = c()),
                         checkboxGroupInput("gradeIn", "Grade",
                                             choices = c(),
                                             selected = c()),
                         checkboxGroupInput("heatIn", "Heat",
                                             choices = c(),
                                             selected = c())
                       )
                   )
                 )
               ),
               mainPanel(
                 tabsetPanel(
                   tabPanel("Data table",
                            tableOutput("table")
                   ),
                   tabPanel("Summary", 
                            textOutput("summarytxt_1"),
                            textOutput("summarytxt_2"),
                            textOutput("summarytxt_3")
                   )
                 )
               )
      ),
      tabPanel("Scatterplots", "This panel is intentionally left blank"),
      tabPanel("Histograms", "This panel is intentionally left blank")
    )
  ),
  
  
  
  server = function(session, input, output) {
    
    # read input file and store into object
    dt <- reactive({
      inFile <- input$datafile
      if (is.null(inFile))
        return(NULL)
      df <- fread(inFile$datapath,
                  sep=",", 
                  header=T, 
                  stringsAsFactors=FALSE,
                  dec=".")      
      df
    })
    
    output$summarytxt_1 <- renderText({ 
      df_ <- dt()
      paste("Practices: ", length(unique(df_$Practice)))
    })
    
    output$table <- renderTable({
      dt()
    })
  
    output$summarytxt_2 = renderText({
      df_ <- dt()
      paste("Grades: ", length(unique(df_$Grade)))
    })
    
    output$summarytxt_3 <- renderText({ 
      df_ <- dt()
      paste("Heats: ", length(unique(df_$HeatID)))
    })
    
    
    observe({
      if (!is.null(dt())){
        df_ <- dt()
        
        practice_list <- unique(df_$Practice)
        updateCheckboxGroupInput(session,
                                 inputId = "practiceIn",
                                 choices = practice_list,
                                 selected = practice_list,
                                 inline = FALSE)
        grade_list <- unique(df_$Grade)
        updateCheckboxGroupInput(session,
                                 inputId = "gradeIn",
                                 choices = grade_list,
                                 selected = grade_list,
                                 inline = FALSE)
        heat_list <- unique(df_$HeatID)
        updateCheckboxGroupInput(session,
                                 inputId = "heatIn",
                                 choices = heat_list,
                                 selected = heat_list,
                                 inline = FALSE)
      }
    })
    
  }
)

