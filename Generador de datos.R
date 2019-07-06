

#setwd('../Documents/Simposio/dash board/data/')
hurto <- read.csv('../hurto.csv')



barrios <- c('La Candelaria', 'Belén', 'Aranjuez', 'Villa Hermosa')
longitud <- c(-75.56207 ,-75.57350,-75.56064,-75.55184)
latitud <- c(6.249172 ,6.244254 ,6.281832,6.256428)

i=0
while(i<100){
  dat=data.frame(timestamp=rep(as.numeric(Sys.time())),
                 barrios=barrios,
                 longitud = longitud,
                 latitud = latitud,
                 arma = sample(unique(hurto$arma_medio), 4),
                 modalidad = sample(unique(hurto$modalidad), 4),
                 sede_receptora = sample(unique(hurto$sede_receptora), 4),
                 edad = sample(unique(hurto$edad), 4),
                 robos = rbinom(n = 4,size = 50, prob = 0.7),
                 sumM =rbinom(n = 4,size = 20, prob = 0.4))
  
  write.csv(dat,paste0("hurto",gsub("[^0-9]","",Sys.time()),".csv"),
            row.names = FALSE)
  i=i+1
  Sys.sleep(2)
}


