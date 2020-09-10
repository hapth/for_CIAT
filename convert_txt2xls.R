setwd("/Users/new_user/Documents/For_Work/CIAT/N2_data_raw/")
library(readxl)
library(tidyverse)
library(naniar)
rm(list=ls())
iDir <- "/Users/new_user/Documents/For_Work/CIAT/N2_data_raw/18_st_data/"
nsta <- "Ayunpa"
#nvar <- c("Um","Bh","R","Tgm","Tgtb","Tgx","Tm","Tm","Tx","Ttb","Tx","Um","Utb")

nvar <- c("Um","Bh","Tm","Tm","Tx","Ttb","Tx","Um","Utb")
nvar <- c("Tgx")
for (ista in c(nsta)){
     for (ivar in c(nvar)){
          tmp.dir <- paste(iDir,ista,"/",sep="")
          cfile <- paste(tmp.dir,ivar,".XLS",sep="")
          path <- paste("/Users/new_user/Documents/For_Work/CIAT/N2_data_raw/18_st_data/",
                         ista,"/",ivar,".XLS",sep="")
          data <- NA
          data <- path %>% 
            excel_sheets() %>% 
            set_names() %>% 
            map_df(~ read_excel(path = path, sheet = .x, range = "B5:M36"), .id = "sheet")
            colnames(data) <- c("sheet",seq(1,12))
            day <- seq(31)
            out.file <- paste(ista,"_",ivar,"_1980_2019.txt",sep="")
            file.create(out.file)
            
            for (isheet in seq(80,99)){
                 print(isheet)
                 tmp.data <- as.data.frame(subset(data,data$sheet==isheet))[,2:13]
                 tmp.data[is.na(tmp.data)]<- -99.0
                 tmp.data <- data.frame(day,tmp.data)
                 iyear <- paste("19", isheet,sep="")
                 cat(iyear,file=out.file,sep="\n",append = T)
                 write.table(tmp.data,file=out.file,sep="\t",append = T,row.names = FALSE, col.names = FALSE)
            }
            for (isheet in c("00","01","02","03","04","05","06","07","08","09")){
                 print(isheet)
                 tmp.data <- as.data.frame(subset(data,data$sheet==isheet))[,2:13]
                 tmp.data[is.na(tmp.data)]<- -99.0
                 tmp.data <- data.frame(day,tmp.data)
                 iyear <- paste("20", isheet,sep="")
                 cat(iyear,file=out.file,sep="\n",append = T)
                 write.table(tmp.data,file=out.file,sep="\t",append = T,row.names = FALSE, col.names = FALSE)
            }
            for (isheet in seq(11,19)){
                 print(isheet)
                 tmp.data <- as.data.frame(subset(data,data$sheet==isheet))[,2:13]
                 tmp.data[is.na(tmp.data)]<- -99.0
                 tmp.data <- data.frame(day,tmp.data)
                 iyear <- paste("20", isheet,sep="")
                 cat(iyear,file=out.file,sep="\n",append = T)
                 write.table(tmp.data,file=out.file,sep="\t",append = T,row.names = FALSE, col.names = FALSE)
              
            }
            print(paste("phu` phu` done!!!!!",ista,"--->",ivar,sep=""))
      }
}

