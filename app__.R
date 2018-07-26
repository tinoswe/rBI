ui <- fluidPage(
  
  titlePanel("Shiny Pokédex"),
  
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("Generation", "Select Generation:", 
                         c("First" = 1,
                           "Second" = 2,
                           "Third" = 3,
                           "Forth" = 4,
                           "Fifth" = 5,
                           "Sixth" = 6),
                         inline = T)
    ),
    mainPanel(
      dataTableOutput("Generation")
    )  
  )
)

server <- function(input, output) {
  pokemon <- read.csv("Data/pokemon.csv")
  
  #output$Generation <- renderDataTable({
  #  pokemon[pokemon$Generation == input$Generation,-11]
  #})
  output$Generation <- renderDataTable({
    pokemon[pokemon$Generation %in% input$Generation,-11]
  })
}

shinyApp(ui = ui, server = server)