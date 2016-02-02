 function adcp_dvm_depth(cruise,cout,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Descrirpiton: 
% Usage:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% History:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default arguments:
A.map 	= 1;
A.flag 	= 1;
% Parse required variables, substituting defaults where necessary
A = parse_pv_pairs(A, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 xaxlim = [cruise.dday(1) cruise.dday(end)];

 if length(cout.dday)>1
    figure

    subplot(2,2,1)
    adcp_dvm_depth2(cruise,cout,'var','ampday','flag',A.flag,'fig',0,'font',10,'titfont',12,'sunsize',2)
    xlim(xaxlim)
   
    subplot(2,2,2)
    adcp_dvm_depth2(cruise,cout,'var','ampdiff','flag',A.flag,'fig',0,'font',10,'titfont',12,'sunsize',2)
    xlim(xaxlim)
   
    subplot(2,2,3)
    adcp_dvm_depth1(cout,'var','ampday','fig',0,'font',10,'titfont',12) 
    xlim(xaxlim)
   
    subplot(2,2,4)
    adcp_dvm_depth1(cout,'var','ampdiff','fig',0,'font',10,'titfont',12) 
    xlim(xaxlim)
   
    if A.map==1
       axes('position',[0.4 0.4 0.2 0.2]);
       adcp_map(cruise,'fig',0)
       title(['']);
       xlabel('','fontsize',10)
       ylabel('','fontsize',10)
       set(gca,'xticklabel',[])
       set(gca,'yticklabel',[])
    end
 else

    figure
    subplot(2,2,1)
    adcp_contour(cruise,'fig',0)

    subplot(2,2,2)
    adcp_map(cruise','fig',0);
   %title(['']);
   %xlabel('','fontsize',10)
   %ylabel('','fontsize',10)
   %set(gca,'xticklabel',[])
   %set(gca,'yticklabel',[])

    subplot(2,2,3)
    plot(cout.ampday,cout.depth,'-','linewidth',3);
    title('ampday','fontsize',12);
    ylabel('depth')
    grid on
    box on

    subplot(2,2,4)
    plot(cout.ampdiff,cout.depth,'-','linewidth',3);
    title('ampdiff','fontsize',12);
    ylabel('depth')
    grid on
    box on

 end
