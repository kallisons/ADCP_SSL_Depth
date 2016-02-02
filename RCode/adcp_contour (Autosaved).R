library(ncdf4)
library(viridis)
library(RNetCDF)

Sys.setenv(TZ="UTC")

setwd("~/Code/PublishedProjects/ADCP_SSL_Depth/RCode")
source("RCode/filled.contour/filled.contour.R")
source("RCode/filled.contour/filled.legend.R")

nc<-nc_open("../data/01540.nc")
time<-nc$dim$time$vals
depth_cell<-nc$dim$depth_cell$vals


#Depths can vary over time, need to add a test
depths<-ncvar_get(nc, varid="depth", start=c(1,1), count=c(115,1134))
colnames(depths)<-time
rownames(depths)<-depth_cell
depthlist<-apply(depths, MARGIN=1, FUN=mean)
#depths<-t(depths)
#depths<-depths[,ncol(depths):1]
#filled.contour(x=as.numeric(rownames(depths)), y=as.numeric(colnames(depths))*-1, z=depths)

flags<-ncvar_get(nc, varid="pflag", start=c(1,1), count=c(115,1134))
colnames(flags)<-time
rownames(flags)<-depth_cell
flags<-ifelse(flags!=0, NA, 1)

amp<-ncvar_get(nc, varid="amp", start=c(1,1), count=c(115,1134))
colnames(amp)<-time
rownames(amp)<-depth_cell

amp2<-flags*amp
#lowest 10% of measurements
sortamp<-sort(amp2)
lowamp10<-round(length(sortamp)*0.1, digits=0)
baseamp<-mean(sortamp[1:lowamp10])
amp3<-amp2-baseamp
amp3<-ifelse(amp3<0, 0, amp3)
colnames(amp3)<-time
rownames(amp3)<-depthlist*-1
amp3<-t(amp3)
amp3<-amp3[,ncol(amp3):1]

timetable<-utcal.nc(nc$dim$time$units, as.numeric(rownames(amp3)))
lats<-ncvar_get(nc, varid="lat", start=1, count=1134)
lons<-ncvar_get(nc, varid="lon", start=1, count=1134)
timetable<-cbind(timetable,lats)
timetable<-cbind(timetable,lons)
#class(timetable)
timetable<-as.data.frame(timetable)
timetable$minfrachour<-round(timetable$minute/60, digits=2)
timetable$timefrac<-timetable$hour+timetable$minfrachour
timetable$sun_el<-rep(NA)

for(i in 1:nrow(timetable)){
p<-paste("~/Code/BaseCode/ephemeris/eph --lat ",timetable$lats[i]," --lon ",timetable$lons[i]," --date ",timetable$year[i],"-", timetable$month[i], "-", timetable$day[i], " --duration 0 --time ", timetable$timefrac[i], sep="")
sun<-read.table(pipe(p),col.names=c("date","time","TZ","sun_az","sun_el"))
timetable$sun_el[i]<-sun$sun_el
}

quartz()
par(mar=c(8,5,2,1))
filled.contour(x=as.numeric(rownames(amp3)), y=as.numeric(colnames(amp3)), z=amp3, color.palette=inferno, ylab="Depth (m)", xlab="Time")

