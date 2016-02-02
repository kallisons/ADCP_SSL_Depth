 function [cout] = dvm_find_depth(cout,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Descrirpiton: 
% Usage:
% cout = dvm_find_depth(cout,'var','ampdiff','mode','max','width',100,'depth',[200],'day',[53 59;61 64],'name','zdvm_diff');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% History:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default arguments:
A.var 		= 'ampdiff'; 
A.name 		= 'zdvm'; 
A.day 		= nan;		% -999 to set all DVM to NaN
A.tempo		= nan;
A.depth		= [250 1200];
A.width		= 50;	% width for searching extrema
A.mode		= 'deep';	% 'last': deepest peak
                                % 'max' : largest peak 
                                % 'nan' : Just substitute in NaN (all method failure)
A.plot		= 1;
A.profplot	= 0;
% Parse required variables, substituting defaults where necessary
 A = parse_pv_pairs(A, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 amp 	= cout.(A.var);
 dday 	= cout.dday;
 depth 	= cout.depth;

 profplot=A.profplot;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find the depth indexes to be processed
 indepth = -sort(abs(A.depth(:))); 
 if isnan(indepth)
    indepth = [depth(1) depth(end)];
 end
 if length(indepth)>1;
    indepth=indepth(1:2);
 else
    indepth=[indepth  depth(end)];
 end
 iz = [findin(indepth(1),depth):1:findin(indepth(2),depth)]';
 amp = amp(iz,:);
 depth = depth(iz);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find the time indexes to be processed
% cday can be: 
%            d0 - only d0
%            [d0 d1] - all indexes between d0 and d1
%            [d0 d1; d1 d2; d3 d4 ...] all indexes between each pair
 cday = A.day;
 if isempty(cday);cday=nan;end
 if isnan(cday) 
    cday = [dday(1) dday(end)];
 end
 if isscalar(cday)
    iday = [findin(cday,dday):length(dday)];
 elseif isvector(cday)
    iday = [findin(cday(1),dday):1:findin(cday(2),dday)]; 
 else
    iday = [];
    nint = size(cday,1);
    for indi=1:nint
       iday = [iday [findin(cday(indi,1),dday):1:findin(cday(indi,2),dday)]];
    end
 end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 % finds the DVM depth according to the specified criteria (mode and parameters)

 zdvm = nan(size(dday));
 ampzdvm = nan(size(dday));

 if A.day~=-999
   
    ndays = length(iday);
   
    dz = sort(abs(diff(depth))); 
    alldz = unique(sort(dz));
    meandz = mean(dz);
    if any(diff(dz)) 
       disp(['WARNING: dz varies from: ' num2str(alldz(1)) ' to ' num2str(alldz(end)) ' ... using ' num2str(meandz)]);
    end
    iwidth = max(0,round(A.width/meandz));
    disp(['NOTE: use ' num2str(iwidth) ' point width  - corresponding to ~ ' num2str(iwidth*meandz) ' meters ']);
    disp(['NOTE: use "' A.mode '" criterion for migration depth']);
   
    for indi=1:ndays
       tind = iday(indi);% current day index  
       tvar = amp(:,tind);
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       % NOTE: this formulation uses "peakfinder.m" algorithm to find local maxima
       % other algorimthms are available and should be tested!
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
       % Iterates reducing the interval by 2 times - just in case it fails with large width
       basis = 2;
       ncount = 0;
       isuccess=0;
       locwidth = iwidth;
       while (ncount<5 & isuccess==0)
          locwidth = locwidth/(basis^ncount);
          ncount = ncount+1;
          [imax,amax]= peakfinder(tvar,locwidth);
          isuccess = ~isempty(imax);
       end

       % Diagnostic plots
       if (profplot)
          figure(100);
          hold on
          plot(tvar,depth,cstyle(indi)) ;
       end
       
       % Consider failure (imax not found)
       if isempty(imax)
          maxdepth = nan;
       else
          switch A.mode
          case {'deep','last'}
             indmaxdepth = max(imax);
             maxdepth    = depth(indmaxdepth);
             % for safety, in the max case, removes answer if it is 
             % a global maximum
             if indmaxdepth==1 | indmaxdepth==length(depth)
                maxdepth=nan;
             end
          case {'first','shallow'}
             indmaxdepth = min(imax);
             maxdepth    = depth(indmaxdepth);
             % for safety, in the max case, removes answer if it is 
             % a global maximum
             if indmaxdepth==1 | indmaxdepth==length(depth)
                maxdepth=nan;
             end
          case 'max'
             [vv ii] = max(amax);
             indmaxdepth = imax(ii);
             maxdepth    = depth(indmaxdepth);
             % for safety, in the max case, removes answer if it is 
             % a global maximum
             if indmaxdepth==1 | indmaxdepth==length(depth)
                maxdepth=nan;
             end
          case 'nan'
             maxdepth    = nan;
          otherwise
             error(['Mode ' A.mode ' is not valid']);
          end
       end
       zdvm(tind) = maxdepth;
       if profplot
          ampzdvm(tind) = tvar(indmaxdepth);
       end
    end
 end % A.day~=-999

 if profplot
    % puts a legend in the diagnostic profile
    legend(num2str(round(cout.dday)')) 
    plot(ampzdvm,zdvm,'k*');    
 end
 
 
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% renames the variable
 cout.(A.name) = zdvm;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 if A.plot==1
    adcp_dvm_depth1(cout,'var',A.var);    
    hold on
    pp = plot(dday,zdvm,'o-','linewidth',5,'color',[0 0 0]);    
    set(pp,'markersize',10,'markerfacecolor',[1 1 1])
 end
 

