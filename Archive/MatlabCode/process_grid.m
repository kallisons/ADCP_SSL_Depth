 function data = process_grid(data) 

 % Here calculates the Areas of grid boxes, and the Volumes
 % units are in m2 and m3
 R = 6.371e6; 
 
 dx = mean(abs(diff(data.lon)));
 dy = mean(abs(diff(data.lat)));

 if ~isfield(data,'blon')
    disp(['NOTE: Assuming latitude dx degree'])
    data.blon = [data.lon-dx/2 data.lon+dx/2];
 end
 if ~isfield(data,'blat')
    disp(['NOTE: Assuming longitude dy  degree'])
    data.blat = [data.lat-dy/2 data.lat+dy/2];
 end

 data.surf  = nan(length(data.lat),length(data.lon)); 

 % Creates area and volume arrays
 for indi=1:length(data.lon)
    for indj=1:length(data.lat)
           dy = data.blat(indj,2) - data.blat(indj,1);
           dx = data.blon(indi,2) - data.blon(indi,1);
           % Converts to radiants
           dy = 2*pi/360 * dy;
           dx = 2*pi/360 * dx;
           lat =  2*pi/360 * data.lat(indj);
           area = 2*R*R*cos(lat)*sin(dy/2)*dx;           
           data.surf(indj,indi) = area;
    end
 end


