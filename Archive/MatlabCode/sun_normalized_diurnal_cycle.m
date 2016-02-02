 function  f = sun_normalized_diurnal_cycle(time,lat) 

 % Time is provided in days

 % this functions produces a normalized irradiance cycle
 % for a given latitude. Irradiance is 0 at night time and 
 % integrates to 1 between sunrise and sunset, so that 
 % it must be multiplied by the average diurnal irradiance
 % to obtain the instantaneous light
 % For latitudes greater than 66.5° the normalized factor 
 % breaks down this is due to the "midnight sun" 
 % polewards of the arctic antarctic circles

 % uses integer day:
 time0 = floor(time); 
 if abs(lat)>=66.5
  % error(['Careful! Latitude is poleward of arctic circle!']);
 end
 
 delta 	= sun_declination_angle(time0);
 h0	= sun_hour_angle(delta,repmat(lat,size(delta)));

 hp6 = h0+6;
 hm6 = h0-6;

 cosp6 = cos(pi/12*hp6);
 cosm6 = cos(pi/12*hm6);
 sinm6 = sin(pi/12*hm6);

 NormFact = - 24 ./( 12/pi*(cosp6-cosm6) - 2*h0.*sinm6 ); 

 sintm6 = sin(pi/12*(time*24-6));
 
 f = NormFact .* (sintm6+sinm6);

 f(f<=0) = 0;
 
 
