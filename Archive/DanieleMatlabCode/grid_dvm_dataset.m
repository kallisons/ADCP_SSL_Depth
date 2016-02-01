 function  gout = grid_dvm_dataset(cout,varargin)
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
    glon = A.lon;
    glat = A.lat;
    gblon = A.blon;
    gblat = A.blat;
    gout.lon = glon(:);
    gout.lat = glat(:);
    gout.blon = gblon(:);
    gout.blat = gblat(:);
 end

 % Input variables 

 varname = A.var;
 vlon = cout.lon;
 vlat = cout.lat;
 vvar = cout.(varname);

 nvar = length(vvar);
 
 nglon = length(glon);
 nglat = length(glat);

 % Initializes output 

 gout.num 	= nan(nglat,nglon);
 gout.mean 	= nan(nglat,nglon);
 gout.std 	= nan(nglat,nglon);

 % initialize gridded data cell structure
 for indi=1:length(glon);
    for indj=1:length(glat);
       structdata{indj,indi}.var = [];
    end
 end 

 % puts the data in the gridded data cell structure
 for indv=1:nvar
   %disp(['processing point # ' num2str(indv) '/' num2str(nvar)]);
    ilon = findin2(vlon(indv),gblon);
    ilat = findin2(vlat(indv),gblat);
    structdata{ilat,ilon}.var = [structdata{ilat,ilon}.var vvar(indv)];
 end

 % Processes the data from the gridded data cell structure
 for indi=1:length(glon);
    for indj=1:length(glat);
       gout.num(indj,indi)  	= sum(~isnan(structdata{indj,indi}.var));
       gout.mean(indj,indi) 	= nanmean(structdata{indj,indi}.var);
       gout.std(indj,indi) 	= nanstd(structdata{indj,indi}.var);
    end
 end
 gout.num(gout.num==0) = nan;
 gout.std(gout.std==0) = nan;


