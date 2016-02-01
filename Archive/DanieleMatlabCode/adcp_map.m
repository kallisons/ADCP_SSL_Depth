 function [ffig pp] = plot_cruise(sec,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots a dataset map in longitude-latitude space
% Usage:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% History:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default arguments:
A.day       = 0;
A.sty       ='.';
A.col       ='r';
A.size      = 10;
A.var       ='none';
A.coast     = 1;
A.fig      = 1;
A.hold      = 'off';
A.title     = '';
A.tfontsize = 18;
A.linewidth = 1;
A.axis      = [0 360 -90 90];
% Parse required variables, substituting defaults where necessary
A = parse_pv_pairs(A, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 if strcmp(A.var,'none')
    A.var = 'lon';
 end
 
 if A.fig==1
    ffig = figure;
 else 
    ffig = gcf;
    hold on
 end

 indg = find(~isnan(sec.(A.var)));

 switch A.day
 case 0
    pp = plot(sec.lon(indg),sec.lat(indg),A.sty,'markersize',A.size,'markerfacecolor',A.col,'markeredgecolor',A.col);
 case 1
    pp = scatter(sec.lon(indg),sec.lat(indg),30,sec.dday(indg),'filled');
    colorbarn;
 end

 plot_coast('linewidth',A.linewidth);

 if A.fig==1  & isfield(sec,'name') &  ~iscell(sec.name)
   if strcmp(A.title,'')
      title(['Cruise: ' sec.name],'fontsize',A.tfontsize,'interpreter','none');
   else
      title(A.title,'fontsize',A.tfontsize);
   end
 else
    if ~strcmp(A.title,'')
       title(A.title,'fontsize',A.tfontsize);
    end
 end
 
 xlabel('longitude','fontsize',15)
 ylabel('latitude','fontsize',15)

 axis(A.axis);

