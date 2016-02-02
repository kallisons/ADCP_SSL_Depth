 function h0 = sun_hour_angle(delta,lat)
 
 % Input angles must be provided in degrees, converted here in radians
 % Arguments: delta = declination angle
 % 	      lat   = latitude angle
 % See Hartmann: Global Physical Climatology. eq. 2.16
 % Output: hours of sunset or sunrise after and before noon

 %Converts angles to radiand
 delta = pi/180 * delta;
 lat   = pi/180 * lat;

 cosh0 = - tan(lat) .* tan(delta);
 cosh0(cosh0> 1) =  1;
 cosh0(cosh0<-1) = -1;
 h0    =(180/pi * acos(cosh0)) * 24/360;

 end
