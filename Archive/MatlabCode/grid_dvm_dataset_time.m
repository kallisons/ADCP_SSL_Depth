 function  gout = grid_dvm_dataset_time(cout,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Descrirpiton: 
% Usage:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% History:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default arguments:
 A.var 	= 'zdvm_bksc_mean';
 A.lon 	= nan;
 A.lat 	= nan;
 A.blon	= nan;
 A.blat	= nan;
 A.dx 	= 4;
 A.dy 	= 4;
 A.daybounds = [1 90; 91 181; 182 273; 274 365];	% day boundaries (here seasonal);
% Parse required variables, substituting defaults where necessary
 A = parse_pv_pairs(A, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 if all(isnan([A.lon A.lat A.blon A.blat]))
   % Creates grid given delta-x and delta-y
    dx = A.dx;
    dy = A.dy;
    glon = [dx/2:dx:360-dx/2]; 
    glat = [-90+dy/2:dy:90-dy/2]; 
    gout.lon = glon(:);
    gout.lat = glat(:);
    gout = process_grid(gout);
    gblon = gout.blon;
    gblat = gout.blat;
 else
    % NOT TESTED!!!
    glon = A.lon;
    glat = A.lat;
    gblon = A.blon;
    gblat = A.blat;
    gout.lon = glon(:);
    gout.lat = glat(:);
    gout.blon = gblon(:);
    gout.blat = gblat(:);
 end

 daybounds = A.daybounds;
 gout.day = round(mean(daybounds,2));
 
 % Initializes output 
 nglon 	= length(glon);
 nglat 	= length(glat);
 ngtime = size(daybounds,1);

 gout.num 	= nan(ngtime,nglat,nglon);
 gout.mean 	= nan(ngtime,nglat,nglon);
 gout.std 	= nan(ngtime,nglat,nglon);

 % initialize gridded data cell structure
 for indi=1:nglon
    for indj=1:nglat
       for indl=1:ngtime
          structdata{indl,indj,indi}.var = [];
       end
    end
 end 

 varname 		= A.var;
 allvlon 		= cout.lon;
 allvlat 		= cout.lat;
 allvtime 		= cout.time;
 allvvar 		= cout.(varname);
 % Day of year from time
 allvday 		= min(365,round(date2doy(datenum(allvtime'))));
   

 % Loops through time bounds
 for indl=1:ngtime

    % Select indeces according to time bounds in "daybounds"
    iday =  find(allvday>=daybounds(indl,1) & allvday<= daybounds(indl,2));

    % Subsamples input variables 
   
    vlon 		= cout.lon(iday);
    vlat 		= cout.lat(iday);
    vvar 		= cout.(varname)(iday);
   
    nvar 	= length(vvar);
   
    % puts the data in the gridded data cell structure
    for indv=1:nvar
      %disp(['processing point # ' num2str(indv) '/' num2str(nvar)]);
       ilon = findin2(vlon(indv),gblon);
       ilat = findin2(vlat(indv),gblat);
       structdata{indl,ilat,ilon}.var = [structdata{indl,ilat,ilon}.var vvar(indv)];
    end
   
    % Processes the data from the gridded data cell structure
    for indi=1:length(glon);
       for indj=1:length(glat);
          gout.num(indl,indj,indi)  	= sum(~isnan(structdata{indl,indj,indi}.var));
          gout.mean(indl,indj,indi) 	= nanmean(structdata{indl,indj,indi}.var);
          gout.std(indl,indj,indi) 	= nanstd(structdata{indl,indj,indi}.var);
       end
    end

 end % indl


 gout.num(gout.num==0) = nan;
 gout.std(gout.std==0) = nan;


