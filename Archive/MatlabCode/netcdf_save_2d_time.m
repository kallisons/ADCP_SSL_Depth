 function save_woce_corrected_o2(data,lon,lat,time,varargin); 
 % 
 % Exampe: 
 % Arguments:
 % filename: name of the file
 % mode: 'clobber' or 'append'
 % data: data on grid 
 % dataname: name of data to save
 % lon:  longitude grid
 % lat:  latitude grid
 % time:  time axis (assume days in the units - can be anything)
 %  

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 A.filename = 'newfile';
 A.mode = 'clobber';
 A.name = 'newvar';
 A.units = 'undefined';
 A.bad          = -1e34;
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 A = parse_pv_pairs(A, varargin);
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 addpath ~/Documents/matlabpathfiles/snctools/
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
    filename = [A.filename '.nc'];

    nlon = length(lon);
    nlat = length(lat);
    ntime = length(time);

    if strcmp(A.mode,'clobber')
       disp(['Creating netcdf file ' filename]);
       nc_create_empty(filename,'clobber');

       nc_add_dimension(filename,'latitude',nlat);
       nc_add_dimension(filename,'longitude',nlon);
       nc_add_dimension(filename,'time',ntime);

       % Define coordinates
       coordinate(1).Name          = 'longitude';
       coordinate(2).Name          = 'latitude';
       coordinate(3).Name          = 'time';
   
       coordinate(1).Dimension     = {'longitude'};
       coordinate(2).Dimension     = {'latitude'};
       coordinate(3).Dimension     = {'time'};
   
       nc_addvar(filename,coordinate(1));
       nc_addvar(filename,coordinate(2));
       nc_addvar(filename,coordinate(3));
   
       nc_varput(filename,coordinate(1).Name,lon);
       nc_varput(filename,coordinate(2).Name,lat);
       nc_varput(filename,coordinate(3).Name,time);
   
       nc_attput (filename,'longitude','units','degrees')
       nc_attput (filename,'latitude','units','degrees')
       nc_attput (filename,'time','units','d')
    elseif strcmp(A.mode,'append')
       disp(['Appending to netcdf file ' filename]);
    else
       error(['mode must be either clobber or append']);
    end

    % Define variables
    % corrects nans for ferret-style
     variable2d.Name    = A.name;
     data(find(isnan(data))) = A.bad;
     variable2d.Datatype  = 'single';
     variable2d.Dimension = {'time','latitude','longitude'};
     nc_addvar(filename,variable2d);
     nc_varput(filename,variable2d.Name,data);
     nc_attput(filename,A.name,'units',A.units)

    

