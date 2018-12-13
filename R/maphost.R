maphost<-function(){

  library(shiny)
  library(leaflet)
  library(readxl)
  base1 <- read_excel("base1.xlsx")
  attach(base1)
  map <- leaflet()
  map <- addTiles(map)
  map <- setView(map, lng=8.270963 , lat =34.48556, zoom=6)


  ui <- fluidPage(

    titlePanel("Map of Tunisian's hospitals"),
    sidebarLayout(
      sidebarPanel(
        selectInput(inputId = "ville",label = "Choisir la ville",
                    choices = base1$gouvernorat, selected = "Tunis")
      ),

      mainPanel(
        leafletOutput("map")
      )
    )
  )



  server <- function(input, output) {

    output$map <- renderLeaflet({

      base_ville = base1[which(base1$gouvernorat == input$ville ), ]
      #base_ville$longitude= as.numeric(base_ville$longitude)
      #base_ville$latitude= as.numeric(base_ville$latitude)
      for(i in 1:length(base_ville$secteur)){
        long = base_ville$longitude[i]
        lat = base_ville$latitude[i]
        map = addCircleMarkers(map, lng=long, lat=lat, popup = toString(base_ville$nom_etab[i]) )
      }
      map
    })





  }


  shinyApp(ui, server)
}
