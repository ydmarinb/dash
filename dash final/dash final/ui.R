library(ggpubr)
library(shinydashboard)
library(shiny)
library(leaflet)

hurto <- read.csv('hurto.csv')


sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem("General", tabName = "widgets", icon = icon("dashboard")),
        menuItem("Stremming", icon = icon("th"), tabName = "dashboard",
                 badgeLabel = "new", badgeColor = "green"),
        menuItem("Datos", icon = icon("table"), tabName = "data",
                 badgeLabel = "new", badgeColor = "green"),
        selectInput('nombre.barrio', 'Nombre barrio', choices = unique(hurto$nombre_barrio)),
        selectInput('lugar', 'Lugar', choices = unique(hurto$lugar)),
        fluidRow(
            column(7,actionButton("stop","Stop")),
            column(3,actionButton("play","Play"))
        )
        
                    
    )
)



# Put them together into a dashboardPage



#=========================================================

header <- dashboardHeader(title = "Filtros",
                          dropdownMenu(type = "messages",
                                       messageItem(
                                           from = "Autores",
                                           message = "Recuerda visitar la pagina de unalytics",
                                           href = 'https://unalyticsteam.github.io/unalytics.github.io/'
            )))

#=======================================================

body <- dashboardBody(
    
    tabItems(
        tabItem(tabName = "dashboard",
                fluidRow(
                    box(title = "Mapa robos",
                        status = "primary",
                        solidHeader = TRUE,
                        leafletOutput('mapa', width = "100%", height = "750px")),
                    box(title = "Conteo robos", status = "warning",
                        solidHeader = TRUE,
                        plotOutput('barras_stre', width = "100%", height = "350px"))
                )),
        
        tabItem(tabName = "widgets",
                fluidRow(
                    box(plotlyOutput('mosaico', width = "100%", height = "400px")),
                    box(plotlyOutput('densidad', width = "100%", height = "400px")),
                    box(plotlyOutput('barcategori', width = "100%", height = "400px")),
                    box(plotlyOutput('Balloon', width = "100%", height = "400px"))
                )),
        
        tabItem(tabName = "data",
                fluidRow(
                    box(dataTableOutput('tabla'), width = 12)))
    ))
    

# ========================================================

ui <- dashboardPage(header = header,
                    body = body, sidebar = sidebar)


