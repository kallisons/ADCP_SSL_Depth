 function cout = analyze_cruise(cruise,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Descrirpiton: 
% Usage:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% History:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default arguments:
A.flag 		= 1; %
A.blank 	= 1; %
A.var	 	= 'amp'; %
A.preprocess 	= 0; %
A.minres 	= 60; % (minutes)
A.nhday  	= 2; % (hours) to select around the daytime maximum
A.nhnig 	= 2; % (hours) to select around the nighttime minimum
% Parse required variables, substituting defaults where necessary
 A = parse_pv_pairs(A, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% some preprocessing
tpvar = A.var;
if A.preprocess==1
   disp(['WARNING: Preprocessing cruise - interpolating to same depths']);
   cruise = adcp_preprocess(cruise);
end
% Sets the minimum resolution required to resolve DVM (days):
minres = A.minres ./(24*60); % minutes to days 
% Sets the width of interval around sun max/min to consider in amplitude calculation
nhday = A.nhday/24;
nhnig = A.nhnig/24;
disp(['Using daytime width: '   num2str(A.nhday) ' hours']);
disp(['Using nighttime width: ' num2str(A.nhnig) ' hours']);
depth  =  - cruise.depth(:,1);
ndepth = length(depth);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initializes the output cruise
cout.name  = ['cruise_' cruise.name];
cout.depth = depth;
cout.lon   = nan;
cout.lat   = nan;
cout.dday  = nan;
cout.idiff = nan;
cout.elevation  = nan;
cout.time  = nan(size(cruise.time(:,1)));
ampday   = nan(size(depth));
ampdiff  = nan(size(depth));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 iiday 	 = (cruise.elevation>0); 
 iinig   = (cruise.elevation<0); 
 ntimes = length(cruise.dday);
 % time steps in days
 dttime = diff(cruise.dday);
 % for the sake of simplicity adds a NaN as last timestep
 dttime = [dttime nan];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % Find indexes for blocks of day and night times, in increading order
 % Increase day/night by looking at two things:
 % (1) A switch in sun angle sign
 % (2) A timestep larger than 24 hrs (e.g. jump/discontinuity in data) 
 indday = nan(size(cruise.dday));
 indnig = nan(size(cruise.dday));
 % number of days and nights:
 nday = 0;
 nnig = 0;
 if iiday(1)==1
    nday=nday+1;
    indday(1) = nday;
 else
    nnig=nnig+1;
    indnig(1) = nnig;
 end
 for indt=2:ntimes
     if iiday(indt)==1 
        if (iiday(indt-1)==0) | (dttime(indt-1)>=1)
           % Just switched to day : nday+1
           nday=nday+1;
        end
        indday(indt) = nday;
     else
        if (iiday(indt-1)==1) | (dttime(indt-1)>=1) 
           % Just switched to night : nnig+1
           nnig=nnig+1;
        end
        indnig(indt) = nnig; 
     end   
 end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Flags to classify days (or nights)
% (1) - day/night has enough resolution to be used
%     - day/night starts/ends at sunrise/sunset
% (0) - day/night has not enough resolution to be used
%     - day/night starts/ends abruptly
 igday = ones(1,nday);
 ignig = ones(1,nnig);
 % Days
 for indn=1:nday
    locind = find(indday==indn);
    loctdt = dttime(locind);
    maxdt = max(loctdt);
    if maxdt>minres
       disp(['WARNING: Minimum time resolution failed at day: ' num2str(indn) ' - dt = ' num2str(maxdt*24*60) ' min : flagging Bad']);
       igday(indn) = 0; 
    end 
    % Checks if starts abruptly 
    indbefore = find(indday==indn,1,'first')-1;
    if indbefore<1
       % Day is the First: flagging Bad as default
       disp(['WARNING: Found First day: ' num2str(indn) ' : flagging Bad']);
       igday(indn) = 0;
    else
       % timestep of first switch to night
       dtbefore = dttime(indbefore);
       if dtbefore>minres 
          disp(['WARNING: day ' num2str(indn) ' shows abrupt transition from night : flagging Bad']);
          igday(indn) = 0;
       end    
    end   
    % Checks if ends abruptly (starts have been taken care automatically)
    indnext = find(indday==indn,1,'last')+1;
    if indnext>ntimes
       % Day is the last: flagging Bad as default
       disp(['WARNING: Found last day: ' num2str(indn) ' : flagging Bad']);
       igday(indn) = 0;
    else
       % timestep of first switch to night
       dtnext = dttime(indnext);
       if dtnext>minres 
          disp(['WARNING: day ' num2str(indn) ' shows abrupt transition to night : flagging Bad']);
          igday(indn) = 0;
       end    
    end   
 end
 % Nights
 for indn=1:nnig
    locind = find(indnig==indn);
    loctdt = dttime(locind);
    maxdt = max(loctdt);
    if maxdt>minres
       disp(['WARNING: Minimum time resolution failed at night: ' num2str(indn) ' - dt = ' num2str(maxdt*24*60) ' min : flagging Bad']);
       ignig(indn) = 0; 
    end 
    % Checks if starts abruptly 
    indbefore = find(indnig==indn,1,'first')-1;
    if indbefore<1
       % Night is the first: flagging Bad as default
       disp(['WARNING: Found First night: ' num2str(indn) ' : flagging Bad']);
       ignig(indn) = 0;
    else
       % timestep of first switch to day
       dtbefore = dttime(indbefore);
       if dtbefore>minres 
          disp(['WARNING: night ' num2str(indn) ' shows abrupt transition from day : flagging Bad']);
          ignig(indn) = 0;
       end    
    end   
    % Checks if ends abruptly (starts have been taken care automatically)
    indnext = find(indnig==indn,1,'last')+1;
    if indnext>ntimes
       % Night is the last: flagging Bad as default
       disp(['WARNING: Found last night: ' num2str(indn) ' : flagging Bad']);
       ignig(indn) = 0;
    else
       % timestep of first switch to night
       dtnext = dttime(indnext);
       if dtnext>minres 
          disp(['WARNING: night ' num2str(indn) ' shows abrupt transition to night : flagging Bad']);
          ignig(indn) = 0;
       end    
    end   
 end

 % Processes Amplitudes day by day
 kday = 0; % a counter for indicing good days in the cout cruise 
 %disp(['WARNING: Skipping day=1 from the calculation']);
 for indd=1:nday
    if igday(indd)==1
       kday=kday+1;
       disp(['Processing day ... ' num2str(indd) '/' num2str(indd)]); 
       %~~~~~~~~~~~
       locin = find(indday==indd); 
       elevin = cruise.elevation(locin);
       dttimein = dttime(locin); 
       % finds the index of max sun elevation
       [dummy ielevmax] = max(elevin);
       % Finds the indexes surrounding the Max Elevation
       [ielevmaxb ielevmaxf] = find_surrounding_indeces(ielevmax,dttimein,nhday);
       ampin = adcp_clean_amp(cruise.(tpvar)(:,locin),cruise.depth(:,locin),cruise.pflag(:,locin),'flag',A.flag,'blank',A.blank); 
       % Calculates mean profile
       % uses the surrounding dt
       meandt = (dttime(locin-1) + dttime(locin))/2;
       mmeandt = repmat(meandt,ndepth,1);
       mmeandt(isnan(ampin))=nan;
       % limits mean between the chosen indexes surrounding the max
       profampin = nansum(mmeandt(:,ielevmaxb:ielevmaxf).*ampin(:,ielevmaxb:ielevmaxf),2) ./ ...
                   nansum(mmeandt(:,ielevmaxb:ielevmaxf),2); 
       %~~~~~~~~~~~

       %------------ 
       % Finds existence of night before and after
       indbef  = find(indday==indd,1,'first')-1;
       inigbef = indnig(indbef);  
       indnex  = find(indday==indd,1,'last')+1;
       inignex = indnig(indnex);  
       igoodbef = ignig(inigbef); % Night before has good data
       igoodnex = ignig(inignex); % Night after has good data
       %------------ 
       if igoodbef==1
          %~~~~~~~~~~~
          locbef = find(indnig==inigbef);
          elevbef = cruise.elevation(locbef);
          dttimebef = dttime(locbef); 
          [dummy ielevminbef] = min(elevbef);
          [ielevminbefb ielevminbeff] = find_surrounding_indeces(ielevminbef,dttimebef,nhnig);
          ampbef = adcp_clean_amp(cruise.(tpvar)(:,locbef),cruise.depth(:,locbef),cruise.pflag(:,locbef),'flag',A.flag,'blank',A.blank); 
          % Night Before
          meandt = (dttime(locbef-1) + dttime(locbef))/2;
          mmeandt = repmat(meandt,ndepth,1);
          mmeandt(isnan(ampbef))=nan;
          % limits mean between the chosen indexes surrounding the min elevation
          profampbef = nansum(mmeandt(:,ielevminbefb:ielevminbeff).*ampbef(:,ielevminbefb:ielevminbeff),2) ./ ...
                       nansum(mmeandt(:,ielevminbefb:ielevminbeff),2); 
          %~~~~~~~~~~~
       else 
          profampbef = nan(size(depth));
       end
       if igoodnex==1
          %~~~~~~~~~~~
          locnex = find(indnig==inignex);
          elevnex = cruise.elevation(locnex);
          dttimenex = dttime(locnex); 
          [dummy ielevminnex] = min(elevnex);
          [ielevminnexb ielevminnexf] = find_surrounding_indeces(ielevminnex,dttimenex,nhnig);
          ampnex = adcp_clean_amp(cruise.(tpvar)(:,locnex),cruise.depth(:,locnex),cruise.pflag(:,locnex),'flag',A.flag,'blank',A.blank);  
          % Next night
          meandt = (dttime(locnex-1) + dttime(locnex))/2;
          mmeandt = repmat(meandt,ndepth,1);
          mmeandt(isnan(ampnex))=nan;
          % limits mean between the chosen indexes surrounding the min elevation
          profampnex = nansum(mmeandt(:,ielevminnexb:ielevminnexf).*ampnex(:,ielevminnexb:ielevminnexf),2) ./ ... 
                       nansum(mmeandt(:,ielevminnexb:ielevminnexf),2); 
          %~~~~~~~~~~~
       else
          profampnex = nan(size(depth));
       end

       % Wraps up the processed profile
       cout.lon(kday) 		= cruise.lon(locin(ielevmax));
       cout.lat(kday) 		= cruise.lat(locin(ielevmax));
       cout.dday(kday) 		= cruise.dday(locin(ielevmax));
       cout.time(:,kday)	= cruise.time(:,locin(ielevmax));
       cout.elevation(kday)	= cruise.elevation(locin(ielevmax));
       ampday(:,kday)	= profampin;
       if (igoodbef==1 | igoodnex==1)
          % At least one night around daytime are good
          cout.idiff(kday) 	= 1;
          ampdiff(:,kday) = profampin - nanmean([profampnex profampbef],2);
       else
          % No nights around daytime  
          cout.idiff(kday) 	= 0;
          ampdiff(:,kday) = nan(size(profampin));
       end

    else
       disp(['WARNING: day ' num2str(indd) '/' num2str(indd) ' is flagged Bad: Skipping'] );
    end
 end

 % If the variable used to calculate the DVM is not "amp"
 % then substitutes ampday and ampdiff in the final output
 vname1 = [A.var 'day'];
 vname2 = [A.var 'diff'];
 cout.(vname1) = ampday;
 cout.(vname2) = ampdiff;




