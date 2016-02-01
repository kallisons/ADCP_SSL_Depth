 function call = adcp_add_variable_at_depth(call,griddata,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Descrirpiton: 
% Usage:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% History:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default arguments:
A.var       = 'chl';
% Parse required variables, substituting defaults where necessary
A = parse_pv_pairs(A, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extracts a variable from gridded data "Data" at the depth viven by "var"

npoints = length(call.lon);

vname = [A.var];

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %  Samples the gridded dataset at the same points as observations
 % only samples the 3-D fields
    xgrid       = griddata.lon;
    ygrid       = griddata.lat;
    % Observation points
    disp(['All points interpolation ...']);
    % Locations to interpolate
    xnew = call.lon;
    ynew = call.lat;
    mnew = call.time(2,:);

    vgrid = griddata.(A.var);

   % loops to interpolate monthly values

    vi = nan(size(xnew));

   for indm=1:12
       disp(['month # ' num2str(indm) '/12']);
       ithismonth = find(mnew==indm);
       imonth = find(mnew==indm);
       vi(imonth) = interp2(ygrid(:),xgrid(:),squeeze(vgrid(indm,:,:))',ynew(imonth),xnew(imonth));
    end

    call.(vname) = vi;

