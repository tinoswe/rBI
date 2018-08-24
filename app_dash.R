require(shiny)
require(shinydashboard)
require(shinyjs)
require(shinyWidgets)
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
    tabItems(
      tabItem(tabName = "about",
              h5("A webapp for the analysis of level 2 data")),
      tabItem(tabName = "loaddata",
              fileInput("datafile",
                        "Choose input file:", 
                        accept = c("text/csv","text/comma-separated-values,text/plain",".csv")
                        ),
              #actionButton("resetinputfile", 'Reset'),
              tableOutput("table")
              ),
      tabItem(tabName="clearall",
              br(),
              #h4("ciao"),
              #fileInput("upfile", "Choose File:"),
              actionButton("resetinputfile", 'Reset')
              
              
      )
      )
    )
  )


server <- function(input, output, session) {

  observeEvent(input$resetinputfile, {
    reset("datafile")
    })
  
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

  #observeEvent(input$resetinputfile, {
  #  reset(datafile)
  #}, priority = 1000)
  
  #output table
  output$table <- renderTable({
    df <- dt()
  },
  align = "c")
  
  output$menu <- renderMenu({
    if (!is.null(dt())) {
      sidebarMenu(
        menuItem("Input Data",
                 tabName = "loaddata", 
                 icon = icon("clone")),
        menuItem("Filters",
                 tabName = "filters", 
                 icon = icon("filter")
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
        menuItem("Input Data",
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
