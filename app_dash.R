require(shiny)
require(shinydashboard)
require(shinyjs)
require(shinyWidgets)
require(shinythemes)
require(data.table)
require(lubridate)
require(dplyr)
require(tidyr)
require(DT)

ui <- dashboardPage(
  
  
  dashboardHeader(title = "L2 Data Analysis"),
  
  dashboardSidebar(
      br(),
      sidebarMenu(id="x",
                  sidebarMenuOutput("menu"))
      ),
  
  dashboardBody(
    useShinyjs(),
    
    tags$head(
      tags$script(src="js/togglecaret.js")
    ),
    
    tabItems(
      tabItem(tabName = "about",
              h5("A webapp for the analysis of level 2 data")),
      tabItem(tabName = "loaddata",
              fileInput("datafile",
                        "", 
                        accept = c("text/csv","text/comma-separated-values,text/plain",".csv")
                        )#,
              #tableOutput("table")
              ),
      tabItem(tabName = "thedata",
              tableOutput("table")),
      tabItem(tabName="clearall",
              actionButton("resetinputfile", "Reset")
      )
      )
    )
  )

server <- function(input, output, session) {

  # Toggle menu carets
  observeEvent(
    eventExpr=input$showpractices, 
    handlerExpr=session$sendCustomMessage(
      type = 'togglecaret', 
      message = list(
        id='showpracticesicon', 
        val=!is.null(input$practices)
      )
    ),
    ignoreInit=TRUE
  )
  
  observeEvent(
    eventExpr=input$showgrades, 
    handlerExpr=session$sendCustomMessage(
      type = 'togglecaret', 
      message = list(
        id='showgradesicon', 
        val=!is.null(input$grades)
      )
    ),
    ignoreInit=TRUE
  )
  
  observeEvent(
    eventExpr=input$showheats, 
    handlerExpr=session$sendCustomMessage(
      type = 'togglecaret', 
      message = list(
        id='showheatsicon', 
        val=!is.null(input$heats)
      )
    ),
    ignoreInit=TRUE
  )
  
  rv <- reactiveValues(data = NULL)
  observe({
    req(input$datafile)
    rv$data <- fread(input$datafile$datapath,
                     sep=",", 
                     header=T, 
                     stringsAsFactors=FALSE,
                     dec=".")
  })
  
  observeEvent(input$resetinputfile, {
    rv$data <- NULL
    reset("datafile")
  })
  
  observeEvent(input$resetinputfile, {
    reset("datafile")
    })

  output$table <- renderTable({
    rv$data
    },
  align = "c")
  
  output$menu <- renderMenu({
    if (!is.null(rv$data)) {
      sidebarMenu(
        menuItem("Choose Input Data",
                 tabName = "loaddata", 
                 icon = icon("clone")),
        menuItem("Loaded Data",
                 tabName = "thedata", 
                 icon = icon("database")),
        menuItem("Filters",
                 tabName = "filters", 
                 icon = icon("filter"),
                 HTML('
                      <a id="showpractices" href="#" class="action-button" style="padding-left:1em;" width="100%">
                      <i id="showpracticesicon" style="padding-right:0.5em;" class="fa fa-caret-right"></i>
                      Practices
                      </a>'
                 ),
                 conditionalPanel('input.showpractices % 2 == 1',
                                  div(style='padding-left:1em', 
                                      checkboxGroupInput("practices", 
                                                         "",#'Select one or more', 
                                                         choices=unique(rv$data$Practice), 
                                                         selected=c())
                                  )),
                 HTML('
                      <a id="showgrades" href="#" class="action-button" style="padding-left:1em;" width="100%">
                      <i id="showgradesicon" style="padding-right:0.5em;" class="fa fa-caret-right"></i>
                      Grades
                      </a>'
                 ),
                 conditionalPanel('input.showgrades % 2 == 1',
                                  div(style='padding-left:1em', 
                                      checkboxGroupInput("grades", 
                                                         "",#'Select one or more', 
                                                         choices=unique(rv$data$Grade), 
                                                         selected=c())
                                  )),
                 HTML('
                      <a id="showheats" href="#" class="action-button" style="padding-left:1em;" width="100%">
                      <i id="showheatsicon" style="padding-right:0.5em;" class="fa fa-caret-right"></i>
                      Heats
                      </a>'
                 ),
                 conditionalPanel('input.showheats % 2 == 1',
                                  div(style='padding-left:1em', 
                                      checkboxGroupInput("heats", 
                                                         "",#'Select one or more', 
                                                         choices=unique(rv$data$HeatID), 
                                                         selected=c())
                                  ))
                 
                 ),
        menuItem("Summary",
                 tabName = "summary", 
                 icon = icon("clipboard"),
                 menuSubItem("Export Filtered Data",
                             tabName = "",
                             icon = ""),
                 menuSubItem("Clear All Data",
                             tabName = "clearall",
                             icon = "")),
        menuItem("Data Analysis",
                 tabName = "dataanalysis", 
                 icon = icon("flask"),
                 menuSubItem("Scatterplots",
                             tabName = "scatter",
                             icon = ""),
                 menuSubItem("Histograms",
                             tabName = "histo",
                             icon = ""), 
                 menuSubItem("QCA",#Qualitative Comparative Analysis (categorical vars)
                             tabName = "comp",
                             icon = ""), 
                 menuSubItem("Fancy Algorithms",
                             tabName = "ml",
                             icon = ""), 
                 menuSubItem("Customized Analysis",
                             tabName = "custom",
                             icon = "") 
                 ),
        menuItem("About",
                 tabName = "about",
                 icon = icon("question-circle"))
        )}
    else{
      sidebarMenu(
        menuItem("Choose Input Data",
                 tabName = "loaddata", 
                 icon = icon("clone")
                 ),
        menuItem("About",
                 tabName = "about",
                 icon = icon("question-circle")
                 )
      )
    }
  })
}

shinyApp(ui, server)
