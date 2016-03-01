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

test<-noonall$adcptime
compare<-as.numeric(rownames(amp3))

noonamp<-amp3[which(compare==test[5]),]

noonamp<-noonamp[,which((as.numeric(colnames(noonamp))<=-150))]


for(a in 1:nrow(noonamp)){
	
	print(findpeaks(noonamp[a,], nups=2, npeaks=1))
}