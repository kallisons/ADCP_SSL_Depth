 function call = adcp_add_variable_at_depth(call,griddata,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Descrirpiton: 
% Usage:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% History:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default arguments:
A.var       = 'bottom';
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

    vgrid = griddata.(A.var);

    vi = interp2(ygrid(:),xgrid(:),vgrid',ynew,xnew);

    call.(vname) = vi;

