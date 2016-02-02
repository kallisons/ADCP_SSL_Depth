 function plot_movie(sec,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Descrirpiton: 
% Usage:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% History:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A.var   = 'bksc';
A.day   = [];
% Parse required variables, substituting defaults where necessary
A = parse_pv_pairs(A, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 tvar = sec.(A.var);

 mintamp = repmat(tvar(end,:),size(tvar,1),1);
 tampall = tvar - mintamp; 

 isbad = sec.pflag~=0;
 tampall(isbad) = nan;

 hlim = [min(tampall(:)) max(tampall(:))];
 vlim = [min(-sec.depth(:)) max(-sec.depth(:))];

 % Gets the time intervals
 if ~isempty(A.day)
   if length(A.day)==1
      istime = findin(A.day(1),sec.dday);
      ietime = size(sec.dday,2);
   else
      istime = findin(A.day(1),sec.dday);
      ietime = findin(A.day(2),sec.dday);
   end 
 else
   istime = 1;
   ietime = size(sec.dday,2);
 end

 figure

 for indt=istime:ietime
   
     tdepth =  - sec.depth(:,indt);
     tamp   =    tampall(:,indt);

     tamp = tamp - min(tamp);
     
     plot(tamp,tdepth,'.-','linewidth',3)

     tday = sec.time(:,indt)';

     tstringtime = ['Year: '   num2str(tday(1))  '   ' ...
                    'Month: '  num2str(tday(2))  '   ' ...
                    'Day: '    num2str(tday(3))  '   ' ...
                    'Hour: '   num2str(tday(4))  '   ' ...
                    'Min: '    num2str(tday(5))  '   ' ...
                    'Sec: '    num2str(tday(6))  '   ' ...
                    ];
 
     title([tstringtime],'fontsize',16);

     xlim(hlim);
     ylim(vlim);

     grid on

     xlabel('Backscatter','fontsize',16)
     ylabel('Depth (m)','fontsize',16)
    
     drawnow;
  end
     
 
   



