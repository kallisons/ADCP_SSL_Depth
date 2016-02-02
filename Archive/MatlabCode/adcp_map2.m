 function plot_cruise(cruise,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots a dataset map in longitude-latitude space
% Usage:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% History:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default arguments:
A.sty       ='.b';
A.coast     = 1;
A.hold      = 'off';
A.title     = '';
A.size= 10;
A.tfontsize = 18;
A.day = 0;
A.nday = 0;
% Parse required variables, substituting defaults where necessary
A = parse_pv_pairs(A, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 
 if strcmp(A.hold,'off')
    figure
 else
    hold on
 end

 plot(cruise.lon,cruise.lat,A.sty,'markersize',A.size)

 plot_coast

 if strcmp(A.title,'')
    title(['Cruise: ' cruise.name],'fontsize',A.tfontsize);
 end

 if A.day==1

    if A.nday==0
       dstep = 1;
    else
       % automatically select the step to have <10 days plotted
       mind = round(min(cruise.dday));
       maxd = round(max(cruise.dday));
       dstep = max(1,round((maxd-mind)/A.nday));
    end

    iday = [round(min(cruise.dday)):dstep:round(max(cruise.dday))];
    for indd=1:length(iday)
       indl = findin(iday(indd),cruise.dday);
       dlon = cruise.lon(indl);
       dlat = cruise.lat(indl);
       tt = text(dlon,dlat,num2str(iday(indd)));
       set(tt,'color','r','fontsize',15);
    end
 end

 ttax = [get(gca,'xlim') get(gca,'ylim')];
 ttax = ttax + [-20 20 -20 20];
 axis(ttax);

 end
 
