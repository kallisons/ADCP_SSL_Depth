 function secout = adcp_smooth_variable(secin,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% History:
% Version 2.0 : 03-09-10 dbianchi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default arguments:
A.var 		= 'amp';
A.name 		= '';
A.filter 	= 'sgolay';
A.span	 	= 5;
% Parse required variables, substituting defaults where necessary
A = parse_pv_pairs(A, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 secout = secin;

 if ~isfield(secin,A.var)
    error('Variable not found');
 end
  
 if isempty(A.name)
    A.name = ['f' A.var];
 end

 span = A.span;
 
 ndepth = size(secin.amp,1);
 ntime  = size(secin.amp,2);

 oldvar  = secin.(A.var);
 newvar = nan(ndepth,ntime);

 disp(['Filtering variable ' A.var ': nrecords = ' num2str(ndepth) ', span = ' num2str(span) ', filter = ' A.filter])
 for indd=1:ndepth
    thisvect = oldvar(indd,:);
    tempvect = smooth(thisvect,span,A.filter);
    newvar(indd,:) = tempvect;
 end
 
 secout.(A.name) = newvar;


