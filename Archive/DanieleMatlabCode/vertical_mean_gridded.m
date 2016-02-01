  function griddata = vertical_mean_gridded(griddata,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Descrirpiton: 
% Usage:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% History:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default arguments:
A.var       	= 'temp';
A.depth		= [0 100];
A.name		= 'none';
% Parse required variables, substituting defaults where necessary
A = parse_pv_pairs(A, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 nlon = length(griddata.lon);
 nlat = length(griddata.lat);

 varin     = griddata.(A.var);
 varmask   = ~(isnan(varin));

 depth = griddata.depth';

 dz = diff(griddata.bdepth')';

 ddzz = repmat(dz,[1 nlat nlon]); 

 A.depth = sort(abs(A.depth));
 if length(A.depth)==1
    A.depth = [A.depth A.depth];
 end

 ind1 = findin(depth,A.depth(1)); 
 ind2 = findin(depth,A.depth(2)); 

 
 varprod   = varin .* ddzz .* varmask; 
 vardz     =          ddzz .* varmask; 
 
 varout  = double( squeeze(sum(varprod(ind1:ind2,:,:),1)) ./ squeeze(sum(vardz(ind1:ind2,:,:),1)) );

 if strcmp(A.name,'none')
    varname = [A.var '_' num2str(A.depth(1)) '_' num2str(A.depth(2))]; 
 else
    varname = A.name;
 end

 griddata.(varname) = varout;


