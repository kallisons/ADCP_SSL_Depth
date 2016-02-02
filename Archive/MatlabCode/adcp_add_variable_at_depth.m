 function call = adcp_add_variable_at_depth(call,griddata,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Descrirpiton: 
% Usage:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% History:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default arguments:
A.var1       = 'zdvm_diff';
A.var2       = 'o2';
% Parse required variables, substituting defaults where necessary
A = parse_pv_pairs(A, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extracts a variable from gridded data "Data" at the depth viven by "var"

npoints = length(call.(A.var1));

vname = [A.var2 '_on_' A.var1];

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %  Samples the gridded dataset at the same points as observations
 % only samples the 3-D fields
    ndepth      = length(griddata.depth);
    zgrid       = abs(griddata.depth);
    xgrid       = griddata.lon;
    ygrid       = griddata.lat;
    % Observation points
    disp(['All points interpolation ...']);
    % Locations to interpolate
    xnew = call.lon;
    ynew = call.lat;
    znew = abs(call.(A.var1));

    indg = find(~isnan(znew));
    xnew = xnew(indg);
    ynew = ynew(indg);
    znew = znew(indg);

    vgrid = griddata.(A.var2);

    vi = interp3(ygrid,zgrid,xgrid,vgrid,ynew,znew,xnew);

    vout = nan(size(call.(A.var1)));

    vout(indg) = vi;
    
    call.(vname) = vout;

