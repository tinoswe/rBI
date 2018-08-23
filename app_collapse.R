library(shiny)
library(shinydashboard)
library(shinyjs)

ui <- dashboardPage(
  dashboardHeader(title = "Simple tabs"),
  dashboardSidebar(
    sidebarMenu(
      id = "tabs",
      actionButton('switchtab', 'Switch tab'),
      menuItem("Widgets", tabName = "widgets", icon = icon("th")),
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard"),
               menuSubItem("Sub Menu 1",icon = icon("folder-open"), tabName = "subMenu1")
      )
    )
  ),
  dashboardBody(
    useShinyjs(), 
    extendShinyjs(text = "shinyjs.activateTab = function(name){
                  setTimeout(function(){
                  $('a[href$=' + '\"#shiny-tab-' + name + '\"' + ']').closest('li').addClass('active')
                  }, 200);
                  }"
    ),
    tabItems(
      tabItem(tabName = "subMenu1",
              h2("Dashboard tab / Sub menu 1 content")
      ),
      tabItem(tabName = "widgets",
              h2("Widgets tab content")
      )
    )
  )
  )

server <- function(input, output, session) {
  observeEvent(input$switchtab, {
    newtab <- switch(input$tabs,
                     "subMenu1" = "widgets",
                     "widgets" = "subMenu1"
    )
    updateTabItems(session, "tabs", newtab)
    if (newtab == "subMenu1")
      js$activateTab("dashboard")
  })
}

shinyApp(ui, server)