library(ncdf4)

setwd("~/Code/PublishedProjects/ADCP_SSL_Depth/RCode")

nc<-nc_open("../data/01540.nc")
time<-nc$dim$time$vals
depth_cell<-nc$dim$depth_cell$vals

depths<-ncvar_get(nc, varid="depth", start=c(1,1), count=c(115,1134))
colnames(depths)<-time
rownames(depths)<-depth_cell
depthlist<-apply(depths, MARGIN=1, FUN=mean)
#depths<-t(depths)
#depths<-depths[,ncol(depths):1]
#filled.contour(x=as.numeric(rownames(depths)), y=as.numeric(colnames(depths))*-1, z=depths)

amp<-ncvar_get(nc, varid="amp", start=c(1,1), count=c(115,1134))
colnames(amp)<-time
rownames(amp)<-depthlist

quartz()
amp<-t(amp)
amp<-amp[,ncol(amp):1]
filled.contour(x=as.numeric(rownames(amp)), y=as.numeric(colnames(amp))*-1, z=amp)

