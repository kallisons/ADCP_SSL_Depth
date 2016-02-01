 function delta = sun_declination_angle(day)
 % See Hartmann: Global Physical Climatology. eq. A.5 and A.6

 day  = mod(day,365);

 theta = (2*pi*day)/365;

 a = [ 0.006918;
      -0.399912;
      -0.006758;
      -0.002697];
 b = [ 0;
       0.070257;
       0.000907;
       0.001480];

 delta = 180/pi * ( ...
         a(1) * cos(0*theta) + b(1) * sin(0*theta) + ...
         a(2) * cos(1*theta) + b(2) * sin(1*theta) + ...
         a(3) * cos(2*theta) + b(3) * sin(2*theta) + ...
         a(4) * cos(3*theta) + b(4) * sin(3*theta) );
   
 end
