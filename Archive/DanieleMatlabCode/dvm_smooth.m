 function [cout] = smooth_dvm(cout,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Descrirpiton: 
% Usage:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% History:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default arguments:
A.method 	= 'moving'; %
A.span		= 5;
% Parse required variables, substituting defaults where necessary
 A = parse_pv_pairs(A, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


 sampday 	= zeros(size(cout.ampday));
 sampdiff 	= zeros(size(cout.ampdiff));

 depth = cout.depth;

 for indd=1:length(cout.dday)

     % ampday
     y0 = cout.ampday(:,indd);
     indb = find(isnan(y0));
     y1 = smooth(depth,y0,A.span,A.method);
     y1(indb) = nan;
     sampday(:,indd) = y1; 

     % ampdiff
     y0 = cout.ampdiff(:,indd);
     indb = find(isnan(y0));
     y1 = smooth(depth,y0,A.span,A.method);
     y1(indb) = nan;
     sampdiff(:,indd) = y1; 

 end
 
 cout.sampday  = sampday;
 cout.sampdiff = sampdiff;



