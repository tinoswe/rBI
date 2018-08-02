require(shiny)
require(shinydashboard)
require(shinyWidgets)
require(data.table)
require(lubridate)
require(dplyr)
require(tidyr)
require(DT)

shinyApp(
  ui = tagList(
    
    #shinythemes::themeSelector(),
    
    navbarPage(
      theme = "simplex", #spacelab",  # <--- To use a theme, uncomment this
      "Plant L2 Data",
      tabPanel("Input data",
               sidebarPanel(
                 fileInput("datafile","File input:", accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
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
                                             selected = c()),
                         switchInput("practiceAllNone", "") ) ) ) ),
               mainPanel(
                 tabsetPanel(
                   tabPanel("Data table",
                            tableOutput("table")),
                   tabPanel("Summary",
                            fluidRow(
                              box(width = 12, 
                                  title = "", 
                                  #splitLayout(
                                    box(width=3,
                                        title="",
                                        h5(textOutput("summarytxt_1")),
                                        h5(textOutput("summarytxt_2")),
                                        h5(textOutput("summarytxt_3"))
                                        ),
                                    box(width=9,
                                        title="",
                                        plotOutput("outplot_summary")
                                        #) 
                                  ) ) ) ) ) ) ) ,
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
    
    #output table
    output$table <- renderTable({
      
      dt_practice <- quote(Practice %in% input$practiceIn) 
      dt_grade <- quote(Grade %in% input$gradeIn) 
      dt_heat <- quote(HeatID %in% input$heatIn) 

      df <- dt()
      
      if (!is.null(dt())){
        filter_(df, dt_practice) %>% filter_(dt_grade) %>% filter_(dt_heat)
      }        
      })
    
    #get summary data
    output$summarytxt_1 <- renderText({
      df_ <- dt()
      paste("Practices: ", length(unique(df_$Practice)))
    })

    output$summarytxt_2 = renderText({
      df_ <- dt()
      paste("Grades: ", length(unique(df_$Grade)))
    })
    
    output$summarytxt_3 <- renderText({ 
      df_ <- dt()
      paste("Heats: ", length(unique(df_$HeatID)))
    })
    
    output$outplot_summary <- renderPlot({
      
      if(!is.null(dt())){
        df <- dt()
        dfg <- as.data.frame(table(df$Grade))$Var1
        dfgc <- as.data.frame(table(df$Grade))$Freq
        plot( dfg, dfgc )
      }
      
    })
    
    #update filters after csv is loaded
    observe({
      if (!is.null(dt())){
        df_ <- dt()
        
        practice_list <- unique(df_$Practice)
        updateCheckboxGroupInput(session,
                                 inputId = "practiceIn",
                                 choices = practice_list,
                                 selected = if (input$practiceAllNone) practice_list,
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
    
    # practice updates grade and heat, and text
    observe({

      if (!is.null(dt())){

        df <- dt()
        unq_flts <- df[,c("Practice","Grade","HeatID")]

        sel_Practices <- input$practiceIn
        all_Practices <- unq_flts$Practice
        all_Grades <- unq_flts$Grade
        all_Heats <- unq_flts$HeatID

        available_Grades <- unique(unq_flts[all_Practices %in% sel_Practices]$Grade)
        available_Heats <- unique(unq_flts[all_Practices %in% sel_Practices]$HeatID)
        
        updateCheckboxGroupInput(session,
                                 inputId = "gradeIn",
                                 choices = input$grade,
                                 selected = available_Grades,
                                 inline = FALSE)
        updateCheckboxGroupInput(session,
                                 inputId = "heatIn",
                                 choices = input$heat,
                                 selected = available_Heats,
                                 inline = FALSE)
      }
    })
    
    # grade updates practice and heat, and text
    observe({
      
      if (!is.null(dt())){
        
        df <- dt()
        unq_flts <- df[,c("Practice","Grade","HeatID")]
        
        sel_grades <- input$gradeIn
        all_Practices <- unq_flts$Practice
        all_Grades <- unq_flts$Grade
        all_Heats <- unq_flts$HeatID
        
        available_Practices <- unique(unq_flts[all_Grades %in% sel_grades]$Practice)
        available_Heats <- unique(unq_flts[all_Grades %in% sel_grades]$HeatID)
        
        updateCheckboxGroupInput(session,
                                 inputId = "practiceIn",
                                 choices = input$practice,
                                 selected = available_Practices,
                                 inline = FALSE)
        updateCheckboxGroupInput(session,
                                 inputId = "heatIn",
                                 choices = input$heat,
                                 selected = available_Heats,
                                 inline = FALSE)
      }
    })
    
    # heat updates grade, and text
    observe({
       
       if (!is.null(dt())){
         
         df <- dt()
         unq_flts <- df[,c("Practice","Grade","HeatID")]
         
         sel_heats <- input$heatIn
         all_Practices <- unq_flts$Practice
         all_Grades <- unq_flts$Grade
         all_Heats <- unq_flts$HeatID
         
         available_Practices <- unique(unq_flts[all_Heats %in% sel_heats]$Practice)
         available_Grades <- unique(unq_flts[all_Heats %in% sel_heats]$Grade)
         
         updateCheckboxGroupInput(session,
                                  inputId = "gradeIn",
                                  choices = input$grade,
                                  selected = available_Grades,
                                  inline = FALSE)
       }
     })
    
    observeEvent(input$practiceIn,{
      output$summarytxt_1 <- renderText({
        paste("Practices: ", length(unique(input$practiceIn)))
      })
    })
    
    observeEvent(input$gradeIn,{
      output$summarytxt_2 <- renderText({
        paste("Grades: ", length(unique(input$gradeIn)))
      })
    })

    observeEvent(input$heatIn,{
      output$summarytxt_3 <- renderText({
        paste("Heats: ", length(unique(input$heatIn)))
      })
    })
    
    observeEvent(input$datafile,{
      updateSwitchInput(session,"practiceAllNone",value=1)
      })
    #})
    
  }
)

#text to be added in summary
#---------------------------
#1. original file size
#2. in memory size of entire dataset
#3. in memory size of filtered dataset
#4. download filtered table as csv

