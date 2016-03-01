library(pracma)

#convert to solar noon
#find peak below 150 m at noon

timetable$unixlocal<-timetable$unix+timetable$lons*240  #Convert from UTC to local time based on solar noon.  
DateConvert<-timetable$unixlocal
class(DateConvert)<-"POSIXct"
DateExtract<-as.POSIXlt(DateConvert)
timetable$date<-as.character(DateExtract, format="%Y-%m-%d")
timetable$Hour<-as.numeric(as.character(DateExtract, format="%H%M"))

timetable$FindNoon<-abs(timetable$Hour-1200)

noon<-aggregate(timetable$FindNoon, list(timetable$date), min)
colnames(noon)<-c("date", "FindNoon")
noonall<-merge(noon, timetable)

noonamp<-amp3[which(rownames(amp3)==noonall$adcptime),]

for(a in 1:nrow(noonamp))
findpeaks(amp3[600,], nups=2, npeaks=1)