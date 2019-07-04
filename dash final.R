## app.R ##
library(shinydashboard)
library(plotly)
library(tidyverse)
library(shiny)
library(data.table)
library(leaflet)
#setwd('../Documents/Simposio/dash borad/data/')

filenames <- list.files(pattern="*.csv", full.names=TRUE)

data_at_start <- rbindlist(lapply(filenames, fread))

ids_at_start <- unique(data_at_start$barrios)


IsThereNewFile <- function(){ 
  filenames <- list.files(pattern="*.csv", full.names=TRUE)
  length(filenames)
}

ReadAllData=function(){
  
  filenames <- list.files(pattern="*.csv", full.names=TRUE)
  temp= rbindlist(lapply(filenames, fread))
  temp$timestamp =as.POSIXct(as.numeric(as.character(temp$timestamp)),origin="1970-01-01",tz="GMT")
  temp
}

# ======================================================


sidebar <- dashboardSidebar(

)


#=========================================================

header <- dashboardHeader(title = "Filtros")

#=======================================================

body <- dashboardBody(
  fluidRow(
    box(leafletOutput('myleaflet', width = "100%", height = "400px")),
    box(plotOutput('timeseries_all', width = "100%", height = "400px")),
    box(plotOutput('modalidad', width = "100%", height = "400px"))
    
    
    
    
      
  )
)

# ========================================================

ui <- dashboardPage(header = header,
                    body = body, sidebar = sidebar)


# ===================================================================
server <- function(input, output, session) {
  alldata <- reactivePoll(10, session,IsThereNewFile, ReadAllData) 
  
  output$myleaflet <- renderLeaflet({
    
    leaflet()  %>% 
      setView(lng = -75.5763927, lat = 6.2602243, zoom = 10) %>% 
      addProviderTiles("Esri")  %>%
      addMarkers(lng = longitud, lat = latitud)    
  
  })
  
  output$timeseries_all = renderPlot({
    dat=alldata()
    end=nrow(dat)
    start=1
    
    if(nrow(dat)>=1){
      dat[start:end,]%>%ggplot(aes(x=timestamp,y=robos))+
        geom_line(aes(color=barrios))+
        theme(axis.title.x = element_blank(),
              axis.title.y = element_text(colour="blue",size=14),
              axis.text = element_text(colour="darkred",size=12),
              plot.title = element_blank())
    }
  })
  
 
  
  output$modalidad = renderPlot({
    dat=alldata()
    end=nrow(dat)
    start=1
    
    if(nrow(dat)>=1){
      dat[start:end,]%>%ggplot(aes(x=modalidad,y= sumM))+
        geom_col(aes(fill=barrios))+
        theme(axis.title.x = element_blank(),
              axis.title.y = element_text(colour="blue",size=14),
              axis.text = element_text(colour="darkred",size=12),
              plot.title = element_blank())
    }
  })
 
  
}

shinyApp(ui, server)
