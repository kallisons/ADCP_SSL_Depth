 function clist = load_cruises(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots a dataset map in longitude-latitude space
% Usage:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% History:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default arguments:
A.cdir   = '/Users/danielebianchi/AOS/ZOOPLANKTON/ADCP/cruises/';
A.prefix = '';
% Parse required variables, substituting defaults where necessary
Param = parse_pv_pairs(A, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cdir = Param.cdir;

allfiles = dir(cdir);

names = {allfiles.name}';

lpref = length(Param.prefix); 

if strcmp(Param.prefix,'')
   icruise  = strmatch('cruise_',names);
else
   icruise  = strncmp(names,Param.prefix,lpref);
end

names = names(icruise);

for inds=1:length(names)
   istr = findstr('.mat',names{inds});
   names{inds} = names{inds}(1:istr-1);
end

clist = names;
 
