 function adcp_dvm_depth(cruise,cout,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Descrirpiton: 
% Usage:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% History:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default arguments:
A.var		= 'ampdiff'; %
A.flag		= 1;
A.center	= 0; % each profile subtracts the mean (centering on 0)
A.fig		= 1;
A.titfont	= 18;
A.font		= 15;
A.sunsize	= 2;
% Parse required variables, substituting defaults where necessary
 A = parse_pv_pairs(A, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 % centers on 0
 if A.center==1
    disp(['WARNING: centering ampday around 0']);
    cout.ampday = cout.ampday - repmat(nanmean(cout.ampday),length(cout.depth),1);
 end
 
 adcp_contour(cruise,'fig',A.fig,'sunsize',A.sunsize,'flag',A.flag);

 title([cout.name],'fontsize',A.titfont,'interpreter','none');
 xlabel(['day'],'fontsize',A.font);
 ylabel(['depth'],'fontsize',A.font);

 hold on
 % Daytime amplitude max
 pp = plot(cout.dday,cout.zdvm_amp,'s','linewidth',2,'color',[0 0 0]);
 set(pp,'markersize',11,'markerfacecolor',[1 1 1])

 % Day-Night maximum
 pp = plot(cout.dday,cout.zdvm_diff,'d','linewidth',2,'color',[1 0 0]);
 set(pp,'markersize',10,'markerfacecolor',[1 1 1])



 

