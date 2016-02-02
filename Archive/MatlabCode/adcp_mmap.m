 function pp = plot_cruise(sec,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots a dataset map in longitude-latitude space
% Usage:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% History:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default arguments:
A.sty       	='.r';
A.lon       	= [0 360];
A.lat       	= [-90 90];
A.projection	='mollweide';
A.var       	='none';
A.coast     	= 1;
A.fig      	= 1;
A.title     	= '';
A.tfontsize 	= 18;
% Parse required variables, substituting defaults where necessary
Param = parse_pv_pairs(A, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 if strcmp(Param.var,'none')
    Param.var = 'lon';
 end
 
 if Param.fig==1
    figure
 end

 m_proj(Param.projection,'long',Param.lon,'lat',Param.lat);

 indg = find(~isnan(sec.(Param.var)));

 pp = m_plot(sec.lon(indg),sec.lat(indg),Param.sty);
 set(pp,'markersize',13);

 hold on
 m_grid('xtick',10,'tickdir','out','yaxislocation','right','fontsize',13,'yticklabels',[-80:40:80]);
 m_coast('patch',[.2 .2 .2],'edgecolor',[0 0 0]);


 if Param.fig==1  & isfield(sec,'name')
   if strcmp(Param.title,'')
      title(['Cruise: ' sec.name],'fontsize',Param.tfontsize);
   else
      title(Param.title,'fontsize',Param.tfontsize);
   end
 else
    if ~strcmp(Param.title,'')
       title(Param.title,'fontsize',Param.tfontsize);
    end
 end
 
