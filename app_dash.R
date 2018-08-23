library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  
  dashboardHeader(title = "L2 Data Analysis"),
  dashboardSidebar(
      br(),
      sidebarMenuOutput("menu"),
      sidebarMenuOutput("filters"),
      sidebarMenuOutput("summary"),
      sidebarMenuOutput("analysis"),
      sidebarMenuOutput("help")
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "about",
              h5("A webapp for the analysis of level 2 data")),
      tabItem(tabName = "loaddata",
                fileInput("dfile",
                          "File input:", 
                          accept = c("text/csv","text/comma-separated-values,text/plain",".csv")
                          )
              )
      )
    )
  )

server <- function(input, output) {

  output$help <- renderMenu({
    sidebarMenu(
      menuItem("About",
               tabName = "about",
               icon = icon("question-circle"))
    )
  })
  
  output$menu <- renderMenu({
    sidebarMenu(
      menuItem("Load Data",
               tabName = "loaddata", 
               icon = icon("clone"))
    )
  })
  
  output$filters <- renderMenu({
    sidebarMenu(
      menuItem("Filters",
               tabName = "filters", 
               icon = icon("filter"),
               menuSubItem('Time',
                           tabName = 'time',
                           icon = ""),
               menuSubItem('Practice',
                           tabName = 'practice',
                           icon = ""), #icon('line-chart')),
               menuSubItem('Grade',
                           tabName = 'grade',
                           icon = ""), #icon('line-chart')),
               menuSubItem('Heat',
                           tabName = 'heat',
                           icon = "") #icon('line-chart'))
      )
    )
  })
  
  output$summary <- renderMenu({
    sidebarMenu(
      menuItem("Summary",
               tabName = "summary", 
               icon = icon("clipboard"),
               menuSubItem("Export Filtered Data",
                           tabName = "",
                           icon = ""))
    )
  })
  
  output$analysis <- renderMenu({
    sidebarMenu(
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
      )
    )
  })
  
}

shinyApp(ui, server)
