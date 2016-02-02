  function [secout cpoly] = woce2_selcruise(secin,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Subsamples a cruise out of a dataset
% Arguments:
%   'mode': choice mode
%   'draw': 1 for redrawing, 0 for keeping current figure
%   'name': new name for figure
% two 'mode' usages:
%   'mode' = 'cruise': selects cruise with most points within the polygon
%   'mode' = 'station': selects all stations within the poligon
%   select one point: chooses the closest cruise
%   select a polygon: chooses the cruise with most points within the polygon
% Usage:
%   glo1 = woce2_selcruise(glodap);
%   glo2 = woce2_selcruise(glodap,'draw',1,'mode','station','name','sec2');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% History:
% Version 2.0 : 03/09/2010
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default arguments:
A.draw      = 0; % default draws the old and new selection
A.name      = 'none'; % default draws the old and new selection
A.poly     = nan; % default draws the old and new selection
% Parse required variables, substituting defaults where necessary
A = parse_pv_pairs(A, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 % create or gets figure
 if A.draw==1
   fig = figure;
   adcp_map(secin,'fig',0);
 else
   fig = gcf;
 end

 if ~isstruct(A.poly) & isnan(A.poly)
     % Starts chosing:
    if strcmp(A.zoom,'on')
       atemp = input('Zoom in if needed','s');
    end
    % graphic input of the hull to include ---------------------------------------------
    newpoli = ginput;
    cpoly.xpoly = newpoli(:,1);
    cpoly.ypoly = newpoli(:,2);
    % closes the polygon:
    cpoly.xpoly(end+1) = cpoly.xpoly(1);
    cpoly.ypoly(end+1) = cpoly.ypoly(1);
    % plots polygon
    line(xpoly,ypoly,'linestyle','--','marker','none','color','g')
    hold on
 else
    cpoly = A.poly;
 end

 xi = secin.lon;
 yi = secin.lat;

 indall  = inpolygon(xi,yi,cpoly.xpoly,cpoly.ypoly);
 inpol   = find(indall);

 % Selects the indexes
 % check whether poligon is more than 3 points (remember, last point == first point)
 npoly = length(inpol);
 if npoly< 3
    % NOT IMPLEMENTED YET!
    % Finds the closest station
    xxmean = mean(cpoly.xpoly(1:end-1));
    yymean = mean(cpoly.ypoly(1:end-1));
    distall2 = (xi-xxmean).^2+(yi-yymean).^2;
    [mmin mind] = min(distall2);
    plot(xi(mind),yi(mind),'r*')
   %istation = secin.ustation(mind);
   %% finds all station indexes that belong to the same cruise   
   %indall = find(secin.cruise == secin.cruise(mind));
   error(['Too little points in the region'])
 end


 % Selects the section
 secout = secin;
 secout.name = 'subset';
 secout.ncast = length(inpol);
 for indv=1:secin.nvar
     secout.(secin.var{indv}) = secin.(secin.var{indv})(:,inpol);  
 end 









