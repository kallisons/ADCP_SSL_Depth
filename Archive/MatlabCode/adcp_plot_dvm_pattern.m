function [format h_m h_i ] = adcp_plot_dvm_pattern(cruise,cout,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Descrirpiton: 
% Usage:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% History:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default arguments:
A.flag      = 1;
A.mode      = 'pcolor';
A.blank     = 1; % 0: no blank; 1 deepest 10% ; 2 minimum
A.palette   = 'jet';
A.visible   = 'on';
A.depths    = 'on';
% Parse required variables, substituting defaults where necessary
A = parse_pv_pairs(A, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 indday = find(~isnan(cout.zdvm_bksc_mean));

 f1 = figure('visible','off');
%s1 = subplot(2,1,1);
 adcp_map(cruise,'fig',0,'sty','b.');
 plot(cout.lon(indday),cout.lat(indday),'r.')
 

 f2 = figure('visible','off');
%s2 = subplot(2,1,2);
 adcp_contour(cruise,'fig',0,'flag',A.flag,'blank',A.blank,'cbar',0);
 title(['cruise: ' cruise.name],'fontsize',18);
 
 hold on

 if strcmp(A.depths,'on')
    pp = plot(cout.dday,cout.zdvm_bksc_day,'s','linewidth',2,'color',[0 0.6 0]);
    set(pp,'markersize',12,'markerfacecolor',[0.7 1.0 0.7])
    
    pp = plot(cout.dday,cout.zdvm_bksc_diff,'d','linewidth',2,'color',[0.6 0 0]);
    set(pp,'markersize',12,'markerfacecolor',[1.0 0.7 0.7])
   
    pp = plot(cout.dday,cout.zdvm_bksc_mean,'o','linewidth',2,'color',[0 0 0]);
    set(pp,'markersize',8,'markerfacecolor',[0.7 0.7 0.7])
    if length(indday)>=2
      nday = length(cout.dday);
      indday2 = [max(1,indday(1)-1) min(nday,indday(end)+1)];
      dlim = cout.dday(indday2);
      xlim([dlim])
    end
 end


 format = 'nor1';

 [h_m h_i]=inset(f2,f1,0.2,A.visible);
 
 close(f1)
 close(f2)
 
function [h_main, h_inset]=inset(main_handle, inset_handle,inset_size, visible)

% The function plotting figure inside figure (main and inset) from 2 existing figures.
% inset_size is the fraction of inset-figure size, default value is 0.35
% The outputs are the axes-handles of both.
% 
% An examle can found in the file: inset_example.m
% 
% Moshe Lindner, August 2010 (C).

if nargin==2
    inset_size=0.45;
end

inset_size=inset_size*.7;
ff = figure('visible',visible);
new_fig=gcf;
main_fig = findobj(main_handle,'Type','axes');
h_main = copyobj(main_fig,new_fig);
set(h_main,'Position',get(main_fig,'Position'))
inset_fig = findobj(inset_handle,'Type','axes');
h_inset = copyobj(inset_fig,new_fig);
ax=get(main_fig,'Position');
set(h_inset,'Position', [.7*ax(1)+ax(3)-inset_size .5*ax(2)+ax(4)-inset_size inset_size inset_size])


