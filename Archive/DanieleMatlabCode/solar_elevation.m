 function elevation = calculate_sun_azimuth(sec)

% Slightly convuluted loop since sun_position.m doesnt take vecorial input

 ntime = length(sec.dday);

 elevation = nan(size(sec.dday));

 for indt=1:ntime

    location.longitude 	= sec.lon(indt); 
    location.latitude 	= sec.lat(indt); 
    location.altitude	= 0;
    
    time.year		= sec.time(1,indt)';
    time.month		= sec.time(2,indt)';
    time.day		= sec.time(3,indt)';
    time.hour		= sec.time(4,indt)';
    time.min		= sec.time(5,indt)';
    time.sec		= sec.time(6,indt)';
    
    % Time should be already in UTC - so offset hour is 0
    time.UTC		= 0;
   
    sun = sun_position(time,location);

    elevation(indt) = 90 - sun.zenith;
    
  end
  

