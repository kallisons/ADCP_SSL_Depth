 function ampout = adcp_clean_amp(ampin,depth,flag,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Descrirpiton: 
% Usage:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% History:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default arguments:
A.flag      = 1;
A.blank	    = 1; % 0: no blank; 1 deepest 10% ; 2 minimum
A.method    = 0; % Method for interpolation only
% Parse required variables, substituting defaults where necessary
Param = parse_pv_pairs(A, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 ldepth = -depth(:,1);

 % Check whether depth changes over the cruise 
 ddepth = depth - repmat(depth(:,1),1,size(depth,2));
 profddepth = find(sum(ddepth,1)~=0);
 if ~isempty(profddepth)
    disp(['WARNING : different depth or NaNs in # ' num2str(length(profddepth)) ' profiles']);
 end


   % Corrects each profile by subtracting a local value
    switch Param.blank
    case 0
       ampout = ampin;
    case 1
       % uses as blank the mean of last 10% lowest points
       sortprof  = sort(ampin,1);
      %thisblank =repmat(nanmean(sortprof(1:ceil(length(ldepth)/10),:)),size(ampin,1),1);
       thisblank =repmat(nanmean(sortprof(1:max((length(ldepth)-1),ceil(length(ldepth)/10)),:)),size(ampin,1),1);
       ampout = ampin - thisblank;
    case 2
       ampout = ampin - repmat(min(ampin),size(ampin,1),1);
    end
 
 isbad = flag~=0;
 switch Param.flag
 case 1
    ampout(isbad) = nan;
 case 2
    % Uses interpolation to fill the NaNs - CAREFUL
    disp(['WARNING: in adcp_clean_amp.m using interpolation to substitute BAD FLAGS']); 
    ampout(isbad) = nan;
    ampout = inpaint_nans(ampout,Param.method);
 end






  
