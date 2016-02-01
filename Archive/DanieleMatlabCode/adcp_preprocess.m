 function cruise = preprocess(cruise,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Descrirpiton: 
% Usage:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% History:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default arguments:
A.tempo       	= 'none';
A.interpolate 	= 1;
A.verbose 	= 1;
A.backscatter 	= 1; % ADDS backscatter data from absorption and spherical attenuation
A.nandepth 	= 1; % Removes the depths that have NaN values (very few cases)
% Parse required variables, substituting defaults where necessary
A = parse_pv_pairs(A, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% First thing, removes the profiles where dday, lon or lat are undefined (NaN)
 indbad = [];
 for indd=1:length(cruise.dday)
    if any(isnan([cruise.dday(indd) cruise.lon(indd) cruise.lat(indd) cruise.elevation(indd)]));
       if A.verbose==1 
          disp(['WARNING: found NaN in lon/lat/day/elevation at timestep ' num2str(indd) '/' num2str(length(cruise.dday)) ', day: ' num2str(cruise.dday(indd)) ' - REMOVING']);
       end
       indbad = [indbad indd];
    end
 end
 cruise.dday(indbad) = [];
 cruise.lon(indbad) = [];
 cruise.lat(indbad) = [];
 if isfield(cruise,'depth_bt')
    cruise.depth_bt(indbad) = [];
 end
 cruise.elevation(indbad) = [];
 cruise.time(:,indbad) = [];
 cruise.depth(:,indbad) = [];
 cruise.amp(:,indbad) = [];
 cruise.pflag(:,indbad) = [];
 if isfield(cruise,'u')
    cruise.u(:,indbad) = [];
    cruise.v(:,indbad) = [];
    cruise.w(:,indbad) = [];
 end

 if A.interpolate==1
    % If interpolate=1 then make sure all samples are on the same depth by interpolating
    % to the most frequent vertical grid - the assumption (which seems to hold for all the cruises)
    % is that a very small fraction of the profiles are on a different depth
    
    modepth = mode(cruise.depth,2);
    cruise.udepth = -abs(modepth);

    nprof = size(cruise.depth,2);

    % Careful! Changes NaN flags to 9s (still bad)
    cruise.pflag(isnan(cruise.pflag)) = 9;
   
    adiff = abs(cruise.depth - repmat(modepth,1,nprof));
    mm = max(adiff);
    % index for profiles with different depths intervals (from the mode of depths)
    cprof = find(mm); 
   
    if ~isempty(cprof)
       % interpolates profiles/sets nans where extrapolation takes place - and flags it to 1 (bad) 
       if A.verbose==1 
          disp(['WARNING : different depth in # ' num2str(length(cprof)) ' profiles']);
          disp(['WARNING : interpolating different depths into most common depth grid']);
       end
       for indp=1:length(cprof)
          %disp(indp);
           iindp = cprof(indp);  
           olddepth = cruise.depth(:,iindp);
           oldamp   = cruise.amp(:,iindp); 
           oldpflag = cruise.pflag(:,iindp);
           if isfield(cruise,'u');
              oldu = cruise.u(:,iindp);
              oldv = cruise.v(:,iindp);
              oldw = cruise.w(:,iindp);
           end
           % removes NaNs in olddepth or bad flagged values
           % removes repeated indexes
           irepdepth = [1;diff(olddepth)]==0;
           inan = find( isnan(olddepth) | oldpflag~=0 | irepdepth);
           olddepth(inan) = [];
           oldamp(inan) = [];
           if isfield(cruise,'u');
              oldu(inan) = [];
              oldv(inan) = [];
              oldw(inan) = [];
           end
           if length(olddepth)>1
              % interpolates
              newamp 	 = interp1(olddepth,oldamp,modepth,'linear',nan);
              if isfield(cruise,'u');
                 newu    = interp1(olddepth,oldu,modepth,'linear',nan);
                 newv    = interp1(olddepth,oldv,modepth,'linear',nan);
                 neww    = interp1(olddepth,oldw,modepth,'linear',nan);
              end
              % substitute new profiles into cruise
              cruise.depth(:,iindp) = modepth;
              cruise.amp(:,iindp)   = newamp;
              if isfield(cruise,'u');
                 cruise.u(:,iindp) = newu;
                 cruise.v(:,iindp) = newv;
                 cruise.w(:,iindp) = neww;
              end
           else
              cruise.depth(:,iindp) = modepth;
              cruise.amp(:,iindp)   = nan;
              if isfield(cruise,'u');
                 cruise.u(:,iindp) = nan;
                 cruise.v(:,iindp) = nan;
                 cruise.w(:,iindp) = nan;
              end
           end

           % flags NaN in new profile
           iflag = find(isnan(cruise.amp(:,iindp)));
           cruise.pflag(:,iindp) = ones(size(modepth));
           cruise.pflag(iflag,iindp) = nan;
       end
    end
 end

 if A.nandepth==1
    allnames  = fieldnames(cruise);
    inandepth = find(isnan(cruise.udepth)); 
    ndepth = size(cruise.depth,1);
    for indn=1:length(allnames)
       if isnumeric(cruise.(allnames{indn}))
          if size(cruise.(allnames{indn}),1) == ndepth
             cruise.(allnames{indn})(inandepth,:) = [];
          end
       end
    end
 end
 
 if A.backscatter==1
    cruise = adcp_calculate_backscatter(cruise);
 end
   
 end

