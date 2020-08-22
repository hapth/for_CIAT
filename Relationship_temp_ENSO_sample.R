#this script use to analyze the relationship of temp and ENSO (i.e. SOI_index)
setwd("/Users/new_user/Documents/For_Work/CIAT/trend/Terra_variability/")
rm(list = c())
library(reshape2);library(ggplot2)
library(raster);library(dplyr)
nvar <- c("ppt","tmean","tmax")
csea <- c("WS","DS")
#csea <- "DS"
nvar <- c("tmax","tmean")
csea <- c("WS","DS")
creg <- "DonDuong"
for (isea in c(csea)){
  for (ivar in c(nvar)){
    if (isea == "DS"){
      st.yrs<- 2005; ed.yrs<- 2017
      sea.name <- "Dry Season"
    } else {
      st.yrs<- 2005; ed.yrs<- 2018
      sea.name <- "Wet Season"
    }
    ifile.name <- paste(ivar,"_",isea,"_",st.yrs,"_",ed.yrs,".txt",sep="")
    idata <- read.table(file=ifile.name,header=T)
    if (ivar == "stl1"){
      idata$value <- idata$value-273.0
    }
    if (ivar == "stl2"){
      idata$value <- idata$value-273.0
    }
    idata$year.id<- as.character(idata$year.id)
    
    mean <- array(NA,dim=c(ed.yrs-st.yrs+1,1))
    year <- seq(st.yrs,ed.yrs)
    for (iyear in seq(st.yrs,ed.yrs)){
      subset <- subset(idata,idata$year.id==iyear)
      mean[iyear-st.yrs+1] <- mean(subset$value)
    }
    sd.value <- sd(mean)
    mean.value<- mean(mean)
    mean <- (mean-mean.value)
    #/sd.value
    
    # create data
    SOI <- read.table(file="SOI_index.txt",header = T)
    SOI$sign[which(SOI$SOI>0)] <- "blue"
    SOI$sign[which(SOI$SOI<=0)] <- "red"
    SOI$ano.value <- NA
    SOI$ano.sign <- NA
    itmp <- 0
    for (iyear in seq(st.yrs,ed.yrs)){
         for (imon in seq(1,12)){
              itmp <- itmp + 1
              if(imon==6){
                 SOI$ano.value[itmp] <- mean[iyear-st.yrs+1]/(0.5)
                 if (SOI$ano.value[itmp] > 0){
                     SOI$ano.sign[itmp] <- "red"
                 } else {
                     SOI$ano.sign[itmp] <- "blue"
                 }
              }
         }
              
    }
  
    if (ivar =="ppt"){
      ctitle <- paste("Precipitation")
      caxis <- "mm"
    } 
    if (ivar=="tmean"){
      ctitle <- paste("Atmospheric temperature mean")
      caxis <- "DegC"
    }
    if (ivar=="tmax"){
      ctitle <- paste("Maximum temperature mean ")
      caxis <- "DegC"
    }
    
    SOI$num <- seq(nrow(SOI))
    idata <- SOI
    y2.labels <- as.character(c(round(seq(-1.5,1,0.5)+mean.value,digits=1)))
      
    p <- ggplot(data=idata,aes(x=num,y=SOI,col=sign))+
      geom_hline(yintercept = 1,color="black",linetype = "dashed")+
      geom_hline(yintercept = -1,color="black",linetype = "dashed")+
      #geom_hline(yintercept = 0,color="black",linetype = "dashed")+
      geom_bar(stat="identity")+ xlab("")+#ggtitle(ctitle)+
      labs(title = ctitle,
           subtitle = paste("Location: LamDong / ", sea.name, sep=""))+
      scale_color_manual(values = c("gray60","gray60"))+
      #geom_bar(aes(x=num,y=ano.value,fill="black"),stat = "identity",color="black")+
      geom_bar(aes(x=num,y=ano.value,fill=ano.sign),stat = "identity",width=1.8,color="black")+
      geom_hline(yintercept = 0,color="chartreuse3",size=1.2,linetype = "solid")+
      #geom_path(aes(x=num,y=ano.value))+
      scale_fill_manual(values = c("royalblue","firebrick2"))+
      scale_x_continuous(breaks = seq(6,nrow(idata),12),labels=seq(2005,2018,1))+
      scale_y_continuous(sec.axis = sec_axis(~ . * 0.5, 
                         breaks = c(-1.5,-1,-0.5,0,0.5,1),name="DegC",
                         labels = c(y2.labels)))+
      #scale_y_continuous(sec.axis = sec_axis((~.*1+mean.value), name = caxis))+
      #scale_y_continuous(sec.axis = sec_axis(~ . *0.5 , name = caxis),  
      #                   breaks=c(seq(-1.5,1.0,0.5)),
      #                   labels = c(round(seq(-1.5,1,0.5)+mean.value,digits=1)))+
      annotate(geom="text",x=30, y=2.4, label="Lanina (strong above dashed line)", color="black")+
      annotate(geom="text",x=30, y=-2.4, label="Elnino (strong below dashed line)", color="black")+
      theme(legend.position = "none",
            legend.text=element_text(size = 16),
            axis.text.y=element_text(size = 16,color ="black"),
            axis.text.x=element_text(size = 16,angle=90,color ="black"),
            axis.title.y = element_text(size = 16,color ="black",angle = 90),
            axis.title.x = element_text(size = 16,color ="black",angle = 0),
            plot.title = element_text(size = 20),
            panel.border = element_rect(colour = "black", fill=NA, size=1))
    #pdf(paste("new_",ivar,"_",isea,"_",st.yrs,"_",ed.yrs,".pdf",sep=""), width = 9, height = 4)
    #print(p)
    #dev.off()
    stat.dat <- round(data.frame(min(mean)+mean.value,max(mean)+mean.value,
                                 max(mean)-min(mean),mean.value,100*(max(mean)-min(mean))/mean.value),digits=1)
    colnames(stat.dat) <- c("min","max","range","mean","range/mean")
    rownames(stat.dat) <- isea
    write.table(stat.dat,file=paste("stat_",ivar,"_",isea,"_",st.yrs,"_",ed.yrs,".txt"),
                col.names = T, row.names = T, sep = "     ")
  }
}
    
    
    
