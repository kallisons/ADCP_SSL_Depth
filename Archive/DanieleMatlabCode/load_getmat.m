function data =  load_getmat(prefix, howmany)
%  data =  load_getmat(prefix)
%  -------------------------------------------------------------------
%  fieldnames   size        meaning:
%
%    dday     1   x nprofs   zero-based decimal day (end of profile)
%    time     6   x nprofs   year,month,day,hour,minute,second (end of profile)
% iblkprf     2   x nprofs   database block and profile number
%     lon     1   x nprofs   longitude (from smoothed navigation; end of profile)
%     lat     1   x nprofs   latitude  (from smoothed navigation; end of profile)
% heading     1   x nprofs   average primary heading (usually gyro)
% tr_temp     1   x nprofs   average temperature
% last_temp   1   x nprofs   last temperature
% last_good_bin 1 x nprofs   last good bin (-1 is bad profile)
%     amp   nbins x nprofs   signal return amplitude or rssi (averaged)
%    amp1   nbins x nprofs   signal return amplitude or rssi (beam 1)
%    amp2   nbins x nprofs   signal return amplitude or rssi (beam 2)
%    amp3   nbins x nprofs   signal return amplitude or rssi (beam 3)
%    amp4   nbins x nprofs   signal return amplitude or rssi (beam 4)
%   swcor   nbins x nprofs   spectral width (nb150) or correlation (os or wh)
%   umeas   nbins x nprofs   measured  velocity (positive north, m/s)
%   umeas_bt  1   x nprofs   measured  velocity (positive north, m/s) from bottom track
%   uship     1   x nprofs   ship      velocity (positive north, m/s)
%       u   nbins x nprofs   ocean     velocity (positive north, m/s)
%   umean     1   x nprofs   ref layer velocity (positive north, m/s)
%   vmeas   nbins x nprofs   measured  velocity (positive east, m/s)
%   vmeas_bt  1   x nprofs   measured  velocity (positive east, m/s) from bottom track
%   vship     1   x nprofs   ship      velocity (positive east, m/s)
%       v   nbins x nprofs   ocean     velocity (positive east, m/s)
%   vmean     1   x nprofs   ref layer velocity (positive east, m/s)
%       w   nbins x nprofs   vertical  velocity (up   , m/s)
%   wmean     1   x nprofs   mean vertical velocity for each profile
%       e   nbins x nprofs   error velocity (m/s)
%   depth   nbins x nprofs   center depth for each bin and profile, positive down
%      pg   nbins x nprofs   percent good 
%   pflag   nbins x nprofs   0 is unflagged, otherwise there is a code.  see www docs
% nanmask   nbins x nprofs   suitable for dot-multiply with velocity
%
% ---- all diagnostics: only if called with (......'all')
%               (some might not be present in any case)
%
%    mps      1 x nprofs     ship speed, m/s
%   fmeas   nbins x nprofs   measured velocity (positive ship's fwd direction, m/s)
%   pmeas   nbins x nprofs   measured velocity (positive ship's port direction, m/s)
%    fvel   nbins x nprofs   ocean velocity (positive ship's fwd direction, m/s)
%    pvel   nbins x nprofs   ocean velocity (positive ship's port direction, m/s)
% head_misalign 1 x nprofs   heading correction (best_head = heading - head_misalign)
% scale_factor  1 x nprofs   scale factor applied to watertrack data
%
% --- additional diagnostics, only if single-ping processing 
%                and vmadcp.def newer than 11/2008
%
%   rvar_uu   nbins x nprofs   variance of singleping residual (u)
%   rvar_uv   nbins x nprofs   covariance of singleping residual (u,v)
%   rvar_vv   nbins x nprofs   variance of singleping residual (v)
%   rvar_ff   nbins x nprofs   variance of singleping residual (fwd)
%   rvar_fp   nbins x nprofs   covariance of singleping residual (fwd,port)
%   rvar_pp   nbins x nprofs   variance of singleping residual (port)
%
%   tsvar_uu  1 x nprofs   variance of singleping time series (u)
%   tsvar_uv  1 x nprofs   covariance of singleping time series (u,v)
%   tsvar_vv  1 x nprofs   variance of singleping time series (v)
%   tsvar_ff  1 x nprofs   variance of singleping time series (fwd)
%   tsvar_fp  1 x nprofs   covariance of singleping time series (fwd,port)
%   tsvar_pp  1 x nprofs   variance of singleping time series (port)
%   tsvar_n   1 x nprofs   number of points in singleping time series
%
%  -------------------------------------------------------------------
%  data =  load_getmat(prefix)
%  input:
%          prefix is the whole path up to the common base of the files
%                 or, use path as well as prefix
%
%  eg     
%          cd cruisedir
%          data = load_getmat('allbins_');
%  eg
%          data = load_getmat(fullfile(cruisedir, 'allbins_'));
%
%  The field "nanmask" holds the editing flags and is designed to turn bad
%  velocity data into NaNs.    Use as follows
%
%  u = data.u .* data.nanmask;
%  v = data.v .* data.nanmask;
%
% %---------------
%
% depending on the version of "getmat", some of these fields may not be available.
% Try downloading a new copy of load_getmat.m or update your CODAS programs.
%
% NOTE: (1) decimal day starts with zero, i.e. Jan 1 noon is 0.5 (not 1.5)
%       (2) The following values are from the END of the ensemble
%                decimal day, time 
%                longitude
%                latitude
%       (3) To get additional diagnostic fields, call with 
%                load_getmat('allbins_', 'all');
%               

data = struct;

if nargin == 2
    if isstr(howmany)
        if strcmp(howmany, 'all')
            allvars = 1;
        else
            allvars = 0;
        end
    else
        allvars = 0;
    end
else
    allvars = 0;
end
     



% initialize so the names come out in a nice order
fnames = {...
'dday' ,'time' ,'iblkprf' ,'lon' ,'lat' ,'heading' ,...
'amp' ,'amp1' ,'amp2' ,'amp3' ,'amp4' , ...
'swcor' , ...
'umeas', 'umeas_bt', 'uship' ,'umean' ,'u' ,...
'vmeas' ,'vmeas_bt', 'vship' ,'vmean' ,'v' ,...
'w' ,'wmean' ,'e' ,...
'depth' ,...
'pg' ,'pflag' ,'nanmask' ,...
'rvar_uu', 'rvar_uv', 'rvar_vv', 'rvar_ff', 'rvar_fp', 'rvar_pp', ...
'tsvar_uu', 'tsvar_uv', 'tsvar_vv', 'tsvar_ff', 'tsvar_fp', 'tsvar_pp', 'tsvar_n', ...
'mps', 'fmeas' ,'pmeas' ,'fvel' ,'pvel', 'head_misalign', 'scale_factor' };

for iname = 1:length(fnames)
    data = setfield(data, fnames{iname}, []);
end


% get the loadable ones --------------------


data=fill_field_from_file(data,  prefix, 'pg', 'PGOOD'         ,'pg'     );
data=fill_field_from_file(data,  prefix, 'pf', 'PFLAG'         ,'pflag'  );
data=fill_field_from_file(data,  prefix, 'amp', 'AMP'          ,'amp'    );

data=fill_field_from_file(data,  prefix, 'sw', 'SPECTRAL_WIDTH','swcor'  );
                                                               
data=fill_field_from_file(data,  prefix, 'u', 'U'              ,'umeas'  );
data=fill_field_from_file(data,  prefix, 'v', 'V'              ,'vmeas'  );

data=fill_field_from_file(data,  prefix, 'w',    'W'           ,'w'  );
data=fill_field_from_file(data,  prefix, 'w',    'W_MEAN'      ,'wmean'  );
data=fill_field_from_file(data,  prefix, 'e',    'E'           ,'e'  );
data=fill_field_from_file(data,  prefix, 'depth','DEPTH'       ,'depth'  );

data=fill_field_from_file(data,  prefix, 'other','LON'         ,'all'  );
data=fill_field_from_file(data,  prefix, 'bt'   ,'D_BT'       ,'all'  );

if allvars == 1
    data=fill_field_from_file(data,  prefix, 'resid_stats',  'RESID_STATS',  'all');
    data=fill_field_from_file(data,  prefix, 'tseries_stats', 'TSERIES_STATS','all');
end


% convenience variables:
data = fix_pflag(data, prefix);

fnames = fieldnames(data);
for iname = 1:length(fnames)
    fieldname = fnames{iname};
    if isemptys(getfield(data,fieldname));
        data = rmfield(data, fieldname);
    end
end

if allvars == 1
    data = more_vels(data);
end


%---------------------------------
function data = fill_field_from_file(data, prefix, filebase, varname, fieldname);
%
% data = fill_field_from_file(data, prefix, filebase, varname, fieldname);

filename = sprintf('%s%s.mat', prefix, filebase);
if exist(filename,'file')
    fileinfo = dir(filename);
    if fileinfo.bytes == 0
        return
    end
else
    return
end


load(filename)
if exist(varname,'var')
    if strcmp(filebase, 'bt')
        if exist('D_BT','var'), 
            data.depth_bt = D_BT; 
        end
        if exist('U_BT','var'), 
            data.umeas_bt = U_BT; 
        end
        if exist('V_BT','var'), 
            data.vmeas_bt = V_BT; 
        end
    elseif strcmp(filebase, 'other')
        %%%%%%%%%%%
        data.dday = DAYS';
        
        if exist('LAT_END')
            data.lon = LON_END';    
            data.lat = LAT_END';
        else
            data.lon = LON';        
            data.lat = LAT';
        end
        
        data.iblkprf = IBLKPRF';    
        data.time = TIME';          
        
        if exist('HEADING','var'), 
            data.heading = HEADING'; 
        end
        if exist('WATRK_HD_MISALIGN','var'); 
            data.head_misalign = WATRK_HD_MISALIGN';
        end
        if exist('WATRK_SCALE_FACTOR','var');
            data.scale_factor = WATRK_SCALE_FACTOR';
        end 
        if exist('LAST_GOOD_BIN','var');
            data.last_good_bin = LAST_GOOD_BIN';
        elseif exist('LGB','var');
            data.last_good_bin = LGB';
        end 
        if exist('TR_TEMP','var'), 
            data.tr_temp = TR_TEMP'; 
        end
        if exist('LAST_TEMP','var'), 
            data.last_temp = LAST_TEMP'; 
        end
        if exist('HEADING','var'), 
            data.heading = HEADING'; 
        end
    elseif strcmp(varname, 'U')
        onesdown = ones(size(U(:,1)));
        data.umeas = U;
        data.uship = U_SHIP;
        data.umean = U_MEAN + U_SHIP;
        data.u = U + onesdown*data.uship;
    elseif  strcmp(varname, 'V')
        onesdown = ones(size(V(:,1)));
        data.vmeas = V;
        data.vship = V_SHIP;
        data.vmean = V_MEAN + V_SHIP;
        data.v = V + onesdown*data.vship;
    elseif strcmp(varname, 'RAW_AMP')
        numbins = length(RAW_AMP(:,1))/4;
        % by beam
        data.amp1 = RAW_AMP(1:numbins,:);
        data.amp2 = RAW_AMP(numbins + (1:numbins),:);
        data.amp3 = RAW_AMP(2*numbins + (1:numbins),:);
        data.amp4 = RAW_AMP(3*numbins + (1:numbins),:);
    elseif strcmp(varname, 'RESID_STATS')
        numbins = length(RESID_STATS(:,1))/6;
        data.rvar_uu = RESID_STATS(0*numbins + (1:numbins),:);
        data.rvar_uv = RESID_STATS(1*numbins + (1:numbins),:);
        data.rvar_vv = RESID_STATS(2*numbins + (1:numbins),:);
        data.rvar_ff = RESID_STATS(3*numbins + (1:numbins),:);
        data.rvar_fp = RESID_STATS(4*numbins + (1:numbins),:);
        data.rvar_pp = RESID_STATS(5*numbins + (1:numbins),:);
    elseif strcmp(varname, 'TSERIES_STATS')
        data.tsvar_uu = TSERIES_STATS(1,:);
        data.tsvar_uv = TSERIES_STATS(2,:);
        data.tsvar_vv = TSERIES_STATS(3,:);
        data.tsvar_ff = TSERIES_STATS(4,:);
        data.tsvar_fp = TSERIES_STATS(5,:);
        data.tsvar_pp = TSERIES_STATS(6,:);
        data.tsvar_n  = TSERIES_STATS(7,:);
    else     
        eval(sprintf('%s=%s'';', varname, varname));
        eval(sprintf('data.%s = %s\'';', fieldname, varname))
    end
end


%---------------------------------

function data = fix_pflag(data, prefix)
% data = fix_pflag(data, prefix)

pf_filename = sprintf('%spf.mat', prefix);
other_filename = sprintf('%sother.mat', prefix);

if exist(pf_filename,'file'); 
    fileinfo = dir(pf_filename);
    if fileinfo.bytes == 0
        return
    end
else
    return
end

   
if exist(other_filename,'file');    
    fileinfo = dir(other_filename);
    if fileinfo.bytes == 0
        return
    end
else
    return
end


load(other_filename); 
load(pf_filename); 

if isfield(data,'pflag') 
    if isfield(data, 'last_good_bin')
        mask = (data.last_good_bin < 0);
        maskM = repmat(mask, length(data.pflag(:,1)),1);
        data.pflag = data.pflag + maskM*8; %new flag
        %% replicate dotmmask here (make this standalone)
        %% data.nanmask is suitable for dot-multiplication with velocity
        tmpmask = data.pflag;
        nani = find(tmpmask~=0);
        tmpmask(nani) = 1; %they will be converted back to NaN below
        data.nanmask = zeros(size(double(tmpmask)));
        data.nanmask(tmpmask == 0) = 1;            %these were not chosen as bad
        data.nanmask(tmpmask ~= 0) = NaN;          %these were chosen as bad
    else
        fprintf('cannot complete profile flag "nanmask" calculation.\n')
        fprintf('please update getmat executable and load_getmat.m\n')
        fprintf('  and try again\n')
    end
end
        
        
%--------------------------------------------

function data= more_vels(data);
% data= more_vels(data);

if isfield(data,'heading') &...
        isfield(data, 'umeas')&...
        isfield(data, 'vmeas')&...
        isfield(data, 'u')&...
        isfield(data, 'v')

    onesdown = ones(size(data.umeas(:,1)));
    %% rotate into forward and port (useful)
    % measured
    rads = (90-data.heading(:)')*pi/180;
    
    fp = (data.umeas + i*data.vmeas).*exp(-i*onesdown*rads);
    data.fmeas = real(fp);
    data.pmeas = imag(fp);
    % ocean
    fp =    (data.u + i*data.v).*exp(-i*onesdown*rads);
    data.fvel  = real(fp);
    data.pvel  = imag(fp);
    
    if isfield(data, 'uship') & isfield(data,'vship');
        data.mps = abs(data.uship + i*data.vship);
    end
end

%---------------------------------------------------------------------
function tf = isemptys(arg)
% tf = isemptys(arg)
% arg is structure, cellarray, double, or character
% tests if argument is empty (by whatever method is necessary)

if isstruct(arg)
   if length(fieldnames(arg)) == 0 | length(arg) == 0 | isempty(arg)
      tf = logical(1);
   else
      tf = logical(0);
   end
else
   if isempty(arg)
      tf = logical(1);
   else
      tf = logical(0);
   end
end

