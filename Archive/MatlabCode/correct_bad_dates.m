
 load ../cruises/cruise_00511
 cruise = cruise_00511;
 vday = cruise.time;
 vday = datenum(vday')';
 offsett = 0.625;
 vday = vday + offsett;
 cruise.dday =  cruise.dday + offsett;
 aday = datevec(vday)';
 cruise.time = aday;
 cruise.elevation = solar_elevation(cruise);
 cruise_00511 = cruise
 save ../cruises/cruise_00511.mat cruise_00511 
 
 


