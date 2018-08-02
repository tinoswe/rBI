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

ui <- #splitLayout(cellWidths = c("25%", "75%"),
  
  fluidPage(

    br(),    
    fluidRow(
      
    #  textAreaInput("caption", 
    #                "Data Summary", 
    #                "", 
    #                width = "100%", 
    #                height = "100%"),
    #  #verbatimTextOutput("value"),
      
      column(12,
              
        column(1,
               actionButton("yearAll",
                            label = "All/None")
               ),
        column(1,
               #"offset" = 1,
               actionButton("monthAll",
                            label = "All/None")
        ),
        column(1,
               #"offset" = 1,
               actionButton("dayAll",
                            label = "All/None")
        ),
        column(1,
               #"offset" = 1,
               actionButton("practiceAll",
                            label = "All/None")
        ),
        column(1,
               #"offset" = 1,
               actionButton("gradeAll",
                            label = "All/None")
        ),
        column(1,
               #"offset" = 1,
               actionButton("heatAll",
                            label = "All/None")
        )
        
      )
      
      
      
    ),
    br(),    
    
    fluidRow(
      
        column(12,
               
            #wellPanel(
               
             column(1,
                    checkboxGroupInput("yearIn", "Year",
                                       choices = year_list,
                                       selected = year_list)),
             column(1,
                    #"offset" = 1,
                    checkboxGroupInput("monthIn", "Month",
                                       choices = month_list,
                                       selected = month_list)),
             column(1,
                    #"offset" = 1,
                    checkboxGroupInput("dayIn", "Day",
                                       choices = day_list,
                                       selected = day_list)),
             #actionButton("checkAllPractices", 
             #              label="ALL"),
             
             column(1,
                    #"offset" = 1,
                    checkboxGroupInput("practiceIn", "Practice",
                                       choices = practice_list,
                                       selected = practice_list)),
             column(1,
                    #"offset"=1,
                    checkboxGroupInput("gradeIn", "Grade",
                                       choices = grade_list,
                                       selected = grade_list)),
             column(1,
                    #"offset"=1,
                    checkboxGroupInput("heatIn", "Heat",
                                       choices = heat_list,
                                       selected = heat_list))
        )
        
        #, style = "padding: 30px;")#wellPanel
        
      ),#fluidRow
    
    
    fluidRow(
      
      column(12,
             #title="main",
             dataTableOutput("results")
             )
      
    )
    )
    
server <- function(session, input, output) {
  
  output$value <- renderText({ input$caption })
  
  #DAY filter actions:
  #1.) if all are deselected get back to All   
  #observe({
  #    if (is.null(input$dayIn)){
  #      updateCheckboxGroupInput(session, 
  #                               inputId = "dayIn",
  #                               choices = day_list,
  #                               selected = day_list,
  #                               inline = FALSE)
  #    }
  #  })
  
  #2.) if at least one one is selected "All" is deselected
  #observe({
  #  if ( ("All" %in% input$dayIn) && (length(input$dayIn) > 1) ) { 
  #    x <- tail(input$dayIn,-1)
  #    updateCheckboxGroupInput(session, 
  #                             inputId = "dayIn",
  #                             choices = day_list,
  #                             selected = x,
  #                             inline = FALSE)
  #   }
  #})
    
  #3.) if "All" is selected when others are already selected then leave only "All"
  #event: when "All" is clicked all others are deselected
  #observe({
  #  if ((length(input$dayIn)>1) && 
  #      (input$dayIn[length(input$dayIn)-1] == "All") && 
  #      (!is.na(as.numeric(input$dayIn[2:length(input$dayIn)]))) ) { 
  #    updateCheckboxGroupInput(session, 
  #                             inputId = "dayIn",
  #                             choices = day_list,
  #                             selected = "All",
  #                             inline = FALSE)
  #  }
    
    
  #})
  
  #4.) update other filters with allowed combinations
  #observe({
  #  if (!is.na(as.numeric(input$dayIn)) && (length(input$dayIn) > 0)){
  #    p_sel <- unique(unq_flts[unq_flts$Day ==  input$dayIn,]$Practice)
  #  updateCheckboxGroupInput(session, 
  #                             inputId = "practiceIn",
  #                             choices = practice_list,
  #                             selected = p_sel,
  #                             inline = FALSE)
  #  }
  #})

  observeEvent(input$dayAll, {
    if(input$dayAll%%2 == 0){
      updateCheckboxGroupInput(session, 
                               inputId = "dayIn",
                               choices = day_list,
                               selected = day_list,
                               inline = FALSE)
    } else {
      updateCheckboxGroupInput(session, 
                               inputId = "dayIn",
                               choices = day_list,
                               selected = c(),
                               inline = FALSE)
    }})
  
  observeEvent(input$practiceAll, {
    if(input$practiceAll%%2 == 0){
      updateCheckboxGroupInput(session, 
                               inputId = "practiceIn",
                               choices = practice_list,
                               selected = practice_list,
                               inline = FALSE)
    } else {
      updateCheckboxGroupInput(session, 
                               inputId = "practiceIn",
                               choices = practice_list,
                               selected = c(),
                               inline = FALSE)
    }})
  
  observeEvent(input$gradeAll, {
    if(input$gradeAll%%2 == 0){
      updateCheckboxGroupInput(session, 
                               inputId = "gradeIn",
                               choices = grade_list,
                               selected = grade_list,
                               inline = FALSE)
    } else {
      updateCheckboxGroupInput(session, 
                               inputId = "gradeIn",
                               choices = grade_list,
                               selected = c(),
                               inline = FALSE)
    }})
  
  observeEvent(input$heatAll, {
    if(input$heatAll%%2 == 0){
      updateCheckboxGroupInput(session, 
                               inputId = "heatIn",
                               choices = heat_list,
                               selected = heat_list,
                               inline = FALSE)
    } else {
      updateCheckboxGroupInput(session, 
                               inputId = "heatIn",
                               choices = heat_list,
                               selected = c(),
                               inline = FALSE)
    }})
  
  #day updates practice, grade, heat
  observe({
    
    sel_Days <- input$dayIn
    all_Days <- unq_flts$Day
    all_Practices <- unq_flts$Practice
    all_Grades <- unq_flts$Grade
    all_Heats <- unq_flts$HeatID
    
    available_Practices <- unique(unq_flts[all_Days %in% sel_Days]$Practice)
    available_Grades <- unique(unq_flts[all_Days %in% sel_Days]$Grade)
    available_Heats <- unique(unq_flts[all_Days %in% sel_Days]$HeatID)

    updateCheckboxGroupInput(session, 
                             inputId = "practiceIn",
                             choices = practice_list,
                             selected = available_Practices,
                             inline = FALSE)        
    updateCheckboxGroupInput(session, 
                             inputId = "gradeIn",
                             choices = grade_list,
                             selected = available_Grades,
                             inline = FALSE)
    updateCheckboxGroupInput(session, 
                             inputId = "heatIn",
                             choices = heat_list,
                             selected = available_Heats,
                             inline = FALSE)
    }
  )
    
#practice updates days, grades and heats
  observe({

    sel_Practices <- input$practiceIn
    all_Days <- unq_flts$Day
    all_Practices <- unq_flts$Practice
    all_Grades <- unq_flts$Grade
    all_Heats <- unq_flts$HeatID

    available_Days <- unique(unq_flts[all_Practices %in% sel_Practices]$Day)
    available_Grades <- unique(unq_flts[all_Practices %in% sel_Practices]$Grade)
    available_Heats <- unique(unq_flts[all_Practices %in% sel_Practices]$HeatID)

    #updateCheckboxGroupInput(session,
    #                         inputId = "dayIn",
    #                         choices = day_list,
    #                         selected = available_Days,
    #                         inline = FALSE)
    updateCheckboxGroupInput(session,
                             inputId = "gradeIn",
                             choices = grade_list,
                             selected = available_Grades,
                             inline = FALSE)
    updateCheckboxGroupInput(session,
                             inputId = "heatIn",
                             choices = heat_list,
                             selected = available_Heats,
                             inline = FALSE)
  })
  
  output$results <- renderDataTable({

    #if(input$dayIn == "All" && (length(input$dayIn == 1) )){
    #  dt_day <- quote(Day != "@?><")
    #} else { 
    dt_day <- quote(Day %in% input$dayIn) 
    #}
    #if(input$practiceIn == "All"){
    #  dt_practice <- quote(Practice != "@?><")
    #  } else { 
    dt_practice <- quote(Practice %in% input$practiceIn) 
    #}
    #if(input$gradeIn == "All"){
    #dt_grade <- quote(Grade != "@?><")
    #} else { 
    dt_grade <- quote(Grade %in% input$gradeIn) 
    #}
    dt_heat <- quote(HeatID %in% input$heatIn) 
    

    filter_(dt, dt_day) %>% filter_(dt_practice) %>% filter_(dt_day) %>% filter_(dt_grade) %>% filter_(dt_heat)},
    options = list(
      pageLength=20,
      dom="tp",
      autoWidth=FALSE,
      columnDefs = list(list(visible=FALSE,
                             targets=c(0,-1,-2,-3,-4,-5)),
                             list(width = "180",
                                  targets = c(3))),
      order = list(list(3,"asc"))))
  #)
  
}
 
 
 shinyApp(ui = ui, server = server)

