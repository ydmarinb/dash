library(shinydashboard)
library(plotly)
library(tidyverse)
library(shiny)
library(data.table)
library(leaflet)
library(ggmosaic)

# data
hurto <- read.csv('hurto.csv')
tabla <- read.csv('tabla.csv')
rownames(tabla) <- tabla$X
tabla$X <- NULL




# ==========================================================
# se contruye el backend de la aplicacion
# =========================================================

server <- function(input, output, session) {
    
    session<-reactiveValues()
    waits <- reactiveValues() 
    waits$data <- rbinom(n = 1, size = 7, prob = 0.7)
    
    forward<-function(){
        newwait<- rbinom(n = 1,size = 7, prob = 0.7)
        waits$data <- head(c(newwait,waits$data),52) 
    } 
    
    
    observeEvent(input$play,{
        session$timer<-reactiveTimer(4000)
        observeEvent(session$timer(),{
            forward()
        })
    })
    
    
    observeEvent(input$stop,{
        session$timer<-reactiveTimer(Inf)
    })
    
    output$barras_stre <- renderPlot({
        barplot(waits$data,xlab="Robos por barrio",
                ylab="Total",space=0,width=1, border = 'blue',
                col = 'skyblue')
        abline(h = 7, col = 'red')
})
    
    base.filtros <- reactive({
        
        hurto %>% filter(nombre_barrio == input$nombre.barrio,
                         lugar == input$lugar)
    })
    
    output$mapa <- renderLeaflet({
        
        datos.lonlat <- distinct(base.filtros(),longitud
                             ,latitud,.keep_all = TRUE)
        
        leaflet()  %>% 
            setView(lng = -75.5763927, lat = 6.2602243, zoom = 10) %>% 
            addProviderTiles("Esri")  %>%
            addMarkers(lng = datos.lonlat$longitud,
                       lat = datos.lonlat$latitud)    
        
    })
    
    
    
    

    
    output$densidad <- renderPlotly({
        
        
        ggplotly(ggplot(base.filtros(), aes(edad)) +
            geom_density(alpha = 0.5, aes(fill = arma_medio)))
        
    })
    
    output$barcategori <- renderPlotly({
        
        frec <- base.filtros() %>% group_by(modalidad,medio_transporte) %>% 
            summarize(frecuencia = n()) 
        
        
        ggplotly(ggplot(frec, aes(x = reorder(modalidad, frecuencia),
                         y = frecuencia)) +
            geom_col( aes(fill = medio_transporte)) + 
            geom_text(aes(label = frecuencia),
                      nudge_y = 2) + 
            coord_flip() +
            scale_fill_viridis_d()) 
        
    })
    
    output$Balloon <- renderPlotly({
        
        
        
        ggballoonplot(tabla, fill = "value")+
            scale_fill_viridis_c(option = "C")
        
    })
    
    
    output$mosaico <- renderPlotly({
        
        
        
        ggplot(base.filtros()) +
            geom_mosaic(aes(x = product(medio_transporte),
                            fill = arma_medio)) +
            theme(axis.text.x=element_blank(),
                  axis.text.y=element_blank())
        
    })
    
    output$tabla <- renderDataTable({
       base.filtros()[, -c(1,2,12,14)]
    })
    
    
    
}


             
