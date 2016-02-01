 function [ss2 ccb ss1 ttit tt1] = woce_plot_surface(call,varargin)
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
A.index 	= [];	% Provide the list of indices to use - [] for all
A.index1 	= [];	% Provide the list of indices to use - [] for var1
A.index2 	= [];	% Provide the list of indices to use - [] for var2
A.index3 	= [];	% Provide the list of indices to use - [] for var3
A.size 		= 50;
A.nan 		= 1;
A.palette 	= 'jet';
A.fig 		= 1;
A.corr 		= 0;
A.corrpos 	= nan;
A.corrsize 	= 15;
A.markeredgecolor	= [0 0 0];
% Parse required variables, substituting defaults where necessary
A = parse_pv_pairs(A, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 if A.fig==1
    figure
 end

 call.(A.var1) = call.(A.var1) * A.fact1;
 call.(A.var2) = call.(A.var2) * A.fact2;
 if ~strcmp(A.var3,'none')
    call.(A.var3) = call.(A.var3) * A.fact3;
 end
 % Clean by indices if provided
 if ~isempty(A.index1)
    call.(A.var1)(setdiff([1:call.ncast],A.index1)) = nan;
 end
 if ~isempty(A.index2)
    call.(A.var2)(setdiff([1:call.ncast],A.index2)) = nan;
 end
 if ~isempty(A.index3)
    call.(A.var3)(setdiff([1:call.ncast],A.index3)) = nan;
 end

 %------------------------------------------------------------------------
 % Creates dummy variable for NaN
 call.none = nan(size(call.lon));
 call.zlev = [0:1/(length(call.lon)-1):1];
 % Finds good and bad (NaNs)
 indb = find(isnan(call.(A.var3)));
 indg = find(~isnan(call.(A.var3)));
 % Select for input indices if provided
 % with A.index a list of indices to use
 if ~isempty(A.index)
    indg = intersect(indg,A.index);
 end
 %------------------------------------------------------------------------

 if (A.nan==1) | strcmp(A.var3,'none')
    ss1 = scatter3(call.(A.var1)(indb),call.(A.var2)(indb),call.zlev(1:length(indb)),A.size);
    view(2)
    set(ss1,'markerfacecolor',[0.7 0.7 0.7],'markeredgecolor',A.markeredgecolor);
 end

 hold on

 ccb = nan;

 if ~strcmp(A.var3,'none')
    ss2 = scatter3(call.(A.var1)(indg),call.(A.var2)(indg),call.zlev(length(indb)+1:length(indb)+length(indg)),A.size,call.(A.var3)(indg),'filled','markeredgecolor',A.markeredgecolor);
    view(2)
    ccb = colorbarn('palette',A.palette);
 end

 box on
 grid on

 ttit = title(['variable: ' A.var3 '  # points: ' num2str(length(indg))],'fontsize',18,'interpreter','none');

 set(gca,'fontsize',15)
 xlabel(A.var1,'fontsize',18,'interpreter','none')
 ylabel(A.var2,'fontsize',18,'interpreter','none')

 if A.corr==1
    A.ax1 = get(gca,'xlim');
    A.ax2 = get(gca,'ylim'); 
    ccoeff = corrcoef(call.(A.var1),call.(A.var2),'rows','complete').^2;
    correl = ccoeff(1,2);
    if isnan(A.corrpos)
       tt1 = text(A.ax1(end)*0.7,A.ax2(end)*0.2,max(call.zlev),['R^2=' num2str(correl,2)],'fontsize',A.corrsize);
    else
       tt1 = text(A.corrpos(1),A.corrpos(2),max(call.zlev),['R^2=' num2str(correl,2)],'fontsize',A.corrsize);
    end
    set(tt1,'background',[1 1 1],'edgecolor',[0 0 0])
 else
   tt1=nan;
 end

 if ~exist('ss2')
    ss2=ss1;
 end
  
