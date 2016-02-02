 function [ss2 ss1 ccb ttit tt1] = woce_plot_surface(call,varargin)
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
A.var1 		= 'zdvm_amp';
A.var2 		= 'zdvm_diff';
A.var3 		= 'none';
A.fact1 	= 1;
A.fact2 	= 1;
A.fact3 	= 1;
A.size 		= 50;
A.palette 	= 'jet';
A.fig 		= 1;
A.corr 		= 0;
A.corrpos 	= nan;
A.corrsize 	= 15;
A.markerfacecolor 	= [0.7 0.7 0.7];
A.markeredgecolor 	= [0.0 0.0 0.0];
% Parse required variables, substituting defaults where necessary
A = parse_pv_pairs(A, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 if A.fig==1
    figure
 end

 call.(A.var1) = call.(A.var1) * A.fact1;
 call.(A.var2) = call.(A.var2) * A.fact2;
 call.(A.var3) = call.(A.var3) * A.fact3;

 ss1 = scatter3(call.(A.var1),call.(A.var2),call.(A.var3),A.size);
%view(2)
 set(ss1,'markerfacecolor',A.markerfacecolor,'markeredgecolor',A.markeredgecolor);

 hold on

 ccb = nan;

 box on
 grid on

%ttit = title(['variable: ' A.var3 '  # points: ' num2str(length(indg))],'fontsize',18,'interpreter','none')

 set(gca,'fontsize',15)
 xlabel(A.var1,'fontsize',18,'interpreter','none')
 ylabel(A.var2,'fontsize',18,'interpreter','none')
 ylabel(A.var3,'fontsize',18,'interpreter','none')

