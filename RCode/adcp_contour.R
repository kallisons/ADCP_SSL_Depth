library(ncdf4)
library(viridis)
library(RNetCDF)
library(pracma)
library(fields)

Sys.setenv(TZ="UTC")

timept=9986
depthc=60

setwd("~/Code/PublishedProjects/ADCP_SSL_Depth/RCode")
source("filled.contour/filled.contour.R", chdir = TRUE)
source("filled.contour/filled.legend.R", chdir = TRUE)

nc<-nc_open("../data/os75nb.nc")
#nc<-nc_open("../data/os75nb.nc")
time<-nc$dim$time$vals
depth_cell<-nc$dim$depth_cell$vals


#Depths can vary over time, need to add a test
depths<-ncvar_get(nc, varid="depth", start=c(1,1), count=c(depthc,timept))
colnames(depths)<-time
rownames(depths)<-depth_cell
depthlist<-apply(depths, MARGIN=1, FUN=mean)
#depths<-t(depths)
#depths<-depths[,ncol(depths):1]
#filled.contour(x=as.numeric(rownames(depths)), y=as.numeric(colnames(depths))*-1, z=depths)

flags<-ncvar_get(nc, varid="pflag", start=c(1,1), count=c(depthc,timept))
colnames(flags)<-time
rownames(flags)<-depth_cell
flags<-ifelse(flags!=0, NA, 1)

amp<-ncvar_get(nc, varid="amp", start=c(1,1), count=c(depthc,timept))
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
amp3<-amp3[,which((as.numeric(colnames(amp3))>=-700))]

timetable<-utcal.nc(nc$dim$time$units, as.numeric(rownames(amp3)))
timetable<-cbind(timetable, utinvcal.nc("seconds since 1970-01-01", timetable))
timetable<-cbind(as.numeric(rownames(amp3)), timetable)
colnames(timetable)[1]<-"adcptime"
colnames(timetable)[8]<-"unix"
lats<-ncvar_get(nc, varid="lat", start=1, count=timept)
lons<-ncvar_get(nc, varid="lon", start=1, count=timept)
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

outgraph<-"~/Code/PublishedProjects/ADCP_SSL_Depth/graphs/test.ps"
#postscript(outgraph, width=8, height=5)

quartz(width=5, height=5)
par(plt = c(0.17,0.75,0.70,0.95), #c(left, right, bottom, top)  
    las = 1,                      # orientation of axis labels
    cex.axis = 1,                 # size of axis annotation
    tck = -0.04,
    xaxs="i",
    yaxs="i")
plot(timetable$unix, timetable$sun_el, xaxt="n", type="l", xlab="", ylab="Sun Elevation")
abline(h=0)
 
par(new = "TRUE",              
    plt = c(0.17,0.75,0.17,0.68),                                    
    las = 1,                      
    cex.axis = 1,                 # size of axis annotation
    tck = -0.04
    )     

filled.contour3(x=as.numeric(rownames(amp3)), y=as.numeric(colnames(amp3)), z=amp3, color.palette=viridis, ylab="Depth (m)", xlab="Time")

par(new = "TRUE",
    plt = c(0.8,0.85,0.17,0.68),   # define plot region for legend
    las = 1,
    cex.axis = 0.8,
    tck=-0.4)

filled.legend(x=as.numeric(rownames(amp3)), y=as.numeric(colnames(amp3)), z=amp3, color.palette=viridis)

#dev.off()
