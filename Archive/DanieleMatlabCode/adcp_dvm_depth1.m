 function adcp_dvm_depth(cout,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Descrirpiton: 
% Usage:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% History:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default arguments:
A.var		= 'ampdiff'; %
A.center	= 0; % each profile subtracts the mean (centering on 0)
A.fig		= 1;
A.palette	= 'jet'; %
A.titfont       = 18;
A.font          = 15;
A.cbar          = 1;
% Parse required variables, substituting defaults where necessary
 A = parse_pv_pairs(A, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 % centers on 0
 if A.center==1
    disp(['WARNING: centering ampday around 0']);
    cout.ampday = cout.ampday - repmat(nanmean(cout.ampday),length(cout.depth),1);
 end

 if A.fig==1
    figure
 end

 pcolor(cout.dday,cout.depth,cout.(A.var));shading flat
 if A.cbar==1
    colorbarn('palette',A.palette);
 end
 hold on
 
 title([cout.name, ' : ', A.var],'fontsize',A.titfont,'interpreter','none');
 xlabel(['day'],'fontsize',A.font);
 ylabel(['depth'],'fontsize',A.font);

 [C,h] = contour(cout.dday,cout.depth,cout.(A.var),'k','linewidth',2);
 if any(strcmp(A.var,{'ampdiff','sampdiff'}))
    p=get(h,'Children');
    c=get(p,'Cdata');
    for indp=1:length(p)
       if c{indp}(1)<0
          set(p(indp),'LineStyle','--')
       end
    end
 end
 
%clabel(C,h);


 

