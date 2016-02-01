 function [ss2 ss1] = woce_plot_surface(call,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example: woce2_plot_surface(sec,'var','temp','surf','sigma0','val',[26.7 26.90],'caxis',[0 20])
% Plots a variable var on the surface defined by the interval on varplot
% var: variable to plot
% surf: variable to use for subsampling the surface to plot
% val: interval vavalues for surf variable
% caxis: interval limits for colorbar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% History:
% Version 2.0 : 03-09-10 dbianchi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default arguments:
A.var 		= 'zdvm';
A.fact 		= 1;
A.size 		= 50;
A.palette 	= 'jet';
A.fig 		= 1;
A.coast 	= 1;
A.edge 		= 1;
A.nan 		= 1;
A.selvar 	= 'none';
A.selval	= nan;
% Parse required variables, substituting defaults where necessary
A = parse_pv_pairs(A, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 if A.fig==1
    figure
 end

 if ~strcmp(A.selvar,'none') & isfield(call,A.selvar); 
    selval = call.(A.selvar);
    
    if length(A.selval)==1
       selind = find(~(selval == A.selval)); 
    else
       selinterval = sort(A.selval);
       selind = find( ~(selval>=selinterval(1) & selval<=selinterval(2)));
    end
 else
    selind = [];
 end
    

 % Creates dumb z variable for dealing with NaN

 % Finds good and bad (NaNs)
 indb = find(isnan(call.(A.var)));
 indg = find(~isnan(call.(A.var)));
 indb = union(indb,selind);
 indg = setdiff(indg,selind);


 if A.nan==1
    % Adds gray circles for NaNs
    ss1 = scatter(call.lon(indb),call.lat(indb),A.size,'filled');
    set(ss1,'markerfacecolor',[0.7 0.7 0.7],'markeredgecolor',[0 0 0]);
 end

 hold on

 if A.edge==1
    ss2 = scatter(call.lon(indg),call.lat(indg),A.size,A.fact*call.(A.var)(indg),'filled','markeredgecolor',[0 0 0]);
 else
    ss2 = scatter(call.lon(indg),call.lat(indg),A.size,A.fact*call.(A.var)(indg),'filled');
 end

 plot_coast;

 colorbarn('palette',A.palette);

 box on
 grid on

 xlim([0 360]);
 ylim([-80 75]);

 title(['variable: ' A.var '  # points: ' num2str(length(indg))],'fontsize',18,'interpreter','none')

 set(gca,'fontsize',15)
 xlabel('longitude ','fontsize',18)
 ylabel('latitude ','fontsize',18)



  
