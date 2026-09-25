library(shiny)
library(leaflet)
library(sf)
library(dplyr)


# ---------------------------------------------------------
# DATA
# ---------------------------------------------------------

dist_all <- st_read("WG_Districts.shp")

wg1kmgrid <- st_read("fishnet_wgclip.shp")


# ---------------------------------------------------------
# UI
# ---------------------------------------------------------

ui <- fluidPage(
  
  tags$head(
    
    tags$style(HTML("

      .intro-container {
        max-width: 1000px;
        margin: 30px auto;
        padding: 0 25px 40px 25px;
      }

      .intro-container h1 {
        margin-bottom: 25px;
      }

      .intro-container h2 {
        margin-top: 35px;
        margin-bottom: 15px;
      }

      .intro-container h3 {
        margin-top: 30px;
      }

      .intro-container p {
        font-size: 16px;
        line-height: 1.6;
      }

      .intro-container li {
        font-size: 16px;
        line-height: 1.7;
        margin-bottom: 8px;
      }

      .launch-button {
        text-align: center;
        margin: 30px 0 45px 0;
      }

      .launch-button .btn {
        font-size: 18px;
        padding: 12px 30px;
      }

      .source-text {
        font-size: 14px !important;
        line-height: 1.5 !important;
      }

      .map-container {
        padding: 15px;
      }

    "))
    
  ),
  
  
  # -------------------------------------------------------
  # PAGE DISPLAY
  # -------------------------------------------------------
  
  uiOutput("current_page")
  
)


# ---------------------------------------------------------
# SERVER
# ---------------------------------------------------------

server <- function(input, output, session) {
  
  
  # -------------------------------------------------------
  # PAGE CONTROL
  # -------------------------------------------------------
  
  page <- reactiveVal("intro")
  
  
  # -------------------------------------------------------
  # INTRODUCTION PAGE
  # -------------------------------------------------------
  
  intro_page <- function() {
    
    tagList(
      
      div(
        class = "intro-container",
        
        
        # -------------------------------------------------
        # TITLE
        # -------------------------------------------------
        
        h1("Western Ghats Presence Location Tool"),
        
        
        # -------------------------------------------------
        # INTRODUCTION
        # -------------------------------------------------
        
        p(
          "This tool helps you approximate the location of a species observation ",
          "in the Western Ghats. You can use the map to locate where an observation ",
          "was made and record the unique ID of the square grid cell covering that location."
        ),
        
        
        # -------------------------------------------------
        # HOW TO USE
        # -------------------------------------------------
        
        h2("How to use the app"),
        
        tags$ol(
          
          tags$li(
            strong("Select the state")
          ),
          
          tags$li(
            strong("Select the district")
          ),
          
          tags$li(
            strong(
              "Scroll and zoom the map to identify the approximate location of the observation"
            )
          ),
          
          tags$li(
            strong(
              "If using a phone or tablet, tap on the grid cell to see its ID number. ",
              "If using a computer, hover your pointer over the grid cell to see its ID."
            )
          ),
          
          tags$li(
            strong(
              "Use this ID number to share the approximate location of the species observation."
            )
          )
          
        ),
        
        
        p(
          "You can switch between the ",
          strong("OpenStreetMap"),
          " and ",
          strong("Satellite Imagery"),
          " views using the map controls."
        ),
        
        
        p(
          "If the observation falls close to the boundary between two grid cells, ",
          "select the cell that best matches the observation location."
        ),
        
        
        # -------------------------------------------------
        # LAUNCH BUTTON
        # -------------------------------------------------
        
        div(
          class = "launch-button",
          
          actionButton(
            inputId = "launch_app",
            label = "Launch Map →",
            class = "btn-primary"
          )
          
        ),
        
        
        # -------------------------------------------------
        # WHY IS THIS USEFUL?
        # -------------------------------------------------
        
        h2("Why is this tool useful?"),
        
        p(
          "Species observations are often obtained through anecdotal reports, ",
          "personal communications, and other informal sources, where an exact ",
          "geographic coordinate may not be available. This tool provides a simple ",
          "and consistent way to record the approximate location of such observations ",
          "across the Western Ghats."
        ),
        
        
        # -------------------------------------------------
        # TECHNICAL INFORMATION
        # -------------------------------------------------
        
        h3("Technical information"),
        
        p(
          "The spatial extent of the tool is based on the Western Ghats region ",
          "defined in the ",
          strong("Western Ghats Ecosystem Profile (CEPF, 2007)"),
          ". The district boundaries used in the application are from ",
          strong("Survey of India (SOI)"),
          "."
        ),
        
        p(
          "The Western Ghats region has been divided into a regular square grid. ",
          "The grid cells were generated in R using the ",
          code("create_fishnet()"),
          " function from the ",
          strong("sprawl"),
          " package. Each grid cell has a unique identification number ",
          code("cell_id"),
          ", which can be used to represent an approximate species location ",
          "when precise geographic coordinates are unavailable."
        ),
        
        p(
          "The dimensions of the grid cells were defined to correspond exactly ",
          "to the spatial dimensions of pixels in the ",
          strong("30 arc-second resolution WorldClim v2.1"),
          " bioclimatic datasets. This allows an observation assigned to a grid ",
          "cell to be directly associated with the corresponding environmental ",
          "raster cell used in species distribution modelling."
        ),
        
        p(
          "The grid therefore provides a standardized spatial framework for ",
          "compiling occurrence information from diverse sources, including ",
          "published records, anecdotal observations, personal communications, ",
          "and other opportunistic records. These records can subsequently be ",
          "used to inform species distribution models and other spatial analyses ",
          "while retaining a consistent spatial resolution across the Western Ghats."
        ),
        
        
        # -------------------------------------------------
        # HOW TO CITE
        # -------------------------------------------------
        
        h3("How to cite this tool"),
        
        p(
          "If you use this tool or the associated grid in a publication, ",
          "please cite the version of the tool available in the project repository:"
        ),
        
        p(
          class = "source-text",
          
          "Nazareth, O. (2026). ",
          em("Western Ghats Species Presence Location Tool"),
          " [Shiny web application]. GitHub."
        ),
        
        p(
          class = "source-text",
          
          a(
            href = "https://github.com/orvillnazareth/Western-Ghats-Species-Presence-Location-Tool",
            target = "_blank",
            "GitHub repository"
          )
          
        ),
        
        
        # -------------------------------------------------
        # SOURCES
        # -------------------------------------------------
        
        h3("Sources"),
        
        p(
          class = "source-text",
          
          strong("Western Ghats boundary:"),
          
          br(),
          
          "CEPF. 2007. ",
          em("Western Ghats Ecosystem Profile."),
          
          br(),
          
          a(
            href = "https://www.cepf.net/sites/default/files/western-ghats-ecosystem-profile-english.pdf",
            target = "_blank",
            "CEPF 2007 — Western Ghats Ecosystem Profile (PDF)"
          )
          
        ),
        
        p(
          class = "source-text",
          
          strong("District boundaries:"),
          
          br(),
          
          "Survey of India (SOI)."
          
        ),
        
        p(
          class = "source-text",
          
          strong("Environmental data:"),
          
          br(),
          
          "WorldClim v2.1, 30 arc-second resolution."
          
        ),
        
        p(
          class = "source-text",
          
          strong("Grid generation:"),
          
          br(),
          
          code("create_fishnet()"),
          " function from the ",
          strong("sprawl"),
          " R package."
          
        ),
        
        
        # -------------------------------------------------
        # CONTACT
        # -------------------------------------------------
        
        p(
          class = "source-text",
          
          strong("Queries:"),
          
          br(),
          
          "Orvill Nazareth — ",
          
          a(
            href = "mailto:nazareth.orvill@gmail.com",
            "nazareth.orvill@gmail.com"
          )
          
        )
        
      )
      
    )
    
  }
  
  
  # -------------------------------------------------------
  # MAP PAGE
  # -------------------------------------------------------
  
  map_page <- function() {
    
    tagList(
      
      div(
        class = "map-container",
        
        actionButton(
          inputId = "back_to_intro",
          label = "← Back to Introduction",
          class = "btn-default"
        ),
        
        br(),
        br(),
        
        sidebarLayout(
          
          sidebarPanel(
            
            selectizeInput(
              inputId = "state",
              label = "Select State",
              choices = sort(unique(dist_all$State_Name)),
              options = list(
                placeholder = "Select a state"
              )
            ),
            
            uiOutput("district"),
            
            br(),
            
            p(
              strong("How to use:")
            ),
            
            p(
              "1. Select the state and district where the observation was made."
            ),
            
            p(
              "2. Scroll and zoom the map to find the approximate observation location."
            ),
            
            p(
              "3. Tap a grid cell on a phone or tablet, or hover over it ",
              "with your pointer on a computer, to see its Grid ID."
            ),
            
            p(
              "4. Use the Grid ID to share the approximate location."
            )
            
          ),
          
          mainPanel(
            
            leafletOutput(
              outputId = "map",
              height = "600px"
            )
            
          )
          
        )
        
      )
      
    )
    
  }
  
  
  # -------------------------------------------------------
  # RENDER CURRENT PAGE
  # -------------------------------------------------------
  
  output$current_page <- renderUI({
    
    if (page() == "intro") {
      
      intro_page()
      
    } else {
      
      map_page()
      
    }
    
  })
  
  
  # -------------------------------------------------------
  # LAUNCH MAP
  # -------------------------------------------------------
  
  observeEvent(input$launch_app, {
    
    page("map")
    
  })
  
  
  # -------------------------------------------------------
  # RETURN TO INTRODUCTION
  # -------------------------------------------------------
  
  observeEvent(input$back_to_intro, {
    
    page("intro")
    
  })
  
  
  # -------------------------------------------------------
  # FILTER DISTRICTS
  # -------------------------------------------------------
  
  filtered <- reactive({
    
    req(input$state)
    
    dist_all %>%
      filter(State_Name == input$state)
    
  })
  
  
  # -------------------------------------------------------
  # DISTRICT DROPDOWN
  # -------------------------------------------------------
  
  output$district <- renderUI({
    
    req(filtered())
    
    selectizeInput(
      
      inputId = "dist_filter",
      
      label = "Select District",
      
      choices = sort(unique(filtered()$Dist_Name)),
      
      options = list(
        placeholder = "Select a district"
      )
      
    )
    
  })
  
  
  # -------------------------------------------------------
  # MAP
  # -------------------------------------------------------
  
  output$map <- renderLeaflet({
    
    req(input$dist_filter)
    
    dist_select <- dist_all %>%
      filter(Dist_Name == input$dist_filter)
    
    
    # Select grid cells intersecting selected district
    
    grid_select <- st_filter(
      
      wg1kmgrid,
      
      dist_select,
      
      .predicate = st_intersects
      
    )
    
    
    leaflet() %>%
      
      addTiles(
        group = "OpenStreetMap"
      ) %>%
      
      addProviderTiles(
        providers$Esri.WorldImagery,
        group = "Esri World Imagery"
      ) %>%
      
      addPolygons(
        
        data = grid_select,
        
        fillOpacity = 0.1,
        
        group = "grid",
        
        color = "red",
        
        weight = 2,
        
        label = ~as.character(cell_id),
        
        highlightOptions = highlightOptions(
          weight = 4,
          bringToFront = TRUE
        )
        
      ) %>%
      
      addLayersControl(
        
        baseGroups = c(
          "OpenStreetMap",
          "Esri World Imagery"
        ),
        
        overlayGroups = c(
          "grid"
        ),
        
        options = layersControlOptions(
          collapsed = FALSE
        )
        
      )
    
  })
  
  
}


# ---------------------------------------------------------
# RUN APP
# ---------------------------------------------------------

shinyApp(
  ui = ui,
  server = server
)