 function [cout count_cruise count_dots] = load_dvm_pattern(varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default arguments:
A.indir          = '/Users/danielebianchi/AOS/ZOOPLANKTON/ADCP/scripts/analysis/dvm_output/dvm_depth_data/';
%A.indir          = '/Users/danielebianchi/AOS/ZOOPLANKTON/ADCP/scripts/analysis/dvm_output/dvm_depth_data_february/';
% Parse required variables, substituting defaults where necessary
 A = parse_pv_pairs(A, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 ccord = nan;

 indir = A.indir;

 D = dir(indir);

 allfiles = {D.name}';

 indb       =  ~strncmp(allfiles,'dvm',3);
 allfiles(indb) = [];

 rawin = load([indir allfiles{1}]);
 cadd  = rawin.cout;
 
 cout.lon = cadd.lon;
 cout.lat = cadd.lat;
 cout.time = cadd.time;
 cout.elevation = cadd.elevation;
 cout.zdvm_amp_day = cadd.zdvm_amp_day;
 cout.zdvm_bksc_day = cadd.zdvm_bksc_day;
 cout.zdvm_amp_diff = cadd.zdvm_amp_diff;
 cout.zdvm_bksc_diff = cadd.zdvm_bksc_diff;

 cout.indc = ones(size(cadd.lon)) * 1;

 count_cruise = 0;
 count_dots   = 0;
 
 % Counting!
 tmp_count = sum(  ~isnan(cadd.zdvm_amp_day) | ~isnan(cadd.zdvm_amp_diff) ); 
 if tmp_count~=0
    count_cruise = count_cruise+1;
    count_dots   = count_dots + tmp_count;
 end

 for indc=2:length(allfiles)

    disp(['Adding in cruise # ' num2str(indc) '/' num2str(length(allfiles)) ' - ' allfiles{indc}]);
    rawadd = load([indir allfiles{indc}]);
    cadd   = rawadd.cout;

   % Tests - find specific cruises
   %ccord = [165.2 166.4 47.4 48]; 
   %ccord = [188 192 -54 -50];
   %ccord = [146 150 35 45];
   %ccord = [110 118 -52 -48];
   %ccord = [195.4 195.8 18.4 18.9];
   %ccord = [173.1 173.3 -21.4 -21];
   %ccord = [46.95 47.1 -43.06 -42.96];
   %ccord = [49.6 49.66 -44.9 -44.85];
   %ccord = [294.96 295.04 -62.2 -62];
   %ccord = [307 308 30 38];
   %ccord = [132 138 32.5 34];
   %ccord = [207 207.3 14.75 14.9];
   %ccord = [225.6 225.8 33.5 33.6];
   %ccord = [166.4 166.6 -30.2 -30];
   %ccord = [164.3 164.4 -29.2 -29];
   %ccord = [256.9 257.2 -23 -20.4];
    if ~isnan(ccord)
       if any( (cadd.lon>ccord(1) & cadd.lon<ccord(2)) & (cadd.lat>ccord(3) & cadd.lat<ccord(4)) )
          disp(['Check found at: -------------------->' cadd.name])
       end
    end

    cout.lon = [cout.lon cadd.lon];
    cout.lat = [cout.lat cadd.lat];
    cout.time = [cout.time cadd.time];
    cout.elevation = [cout.elevation cadd.elevation];
    cout.zdvm_amp_day = [cout.zdvm_amp_day cadd.zdvm_amp_day];
    cout.zdvm_bksc_day = [cout.zdvm_bksc_day cadd.zdvm_bksc_day];
    cout.zdvm_amp_diff = [cout.zdvm_amp_diff cadd.zdvm_amp_diff];
    cout.zdvm_bksc_diff = [cout.zdvm_bksc_diff cadd.zdvm_bksc_diff];


    % Counting!
    tmp_count = sum(  ~isnan(cadd.zdvm_amp_day) | ~isnan(cadd.zdvm_amp_diff) ); 
    if tmp_count~=0
       count_cruise = count_cruise+1;
       count_dots   = count_dots + tmp_count;
    end

    % Negative vales! (there is 1 mistaken positive one - added by hand probabl
     cout.zdvm_amp_day = -abs(cout.zdvm_amp_day);
     cout.zdvm_bksc_day = -abs(cout.zdvm_bksc_day);
     cout.zdvm_amp_diff = -abs(cout.zdvm_amp_diff);
     cout.zdvm_bksc_diff = -abs(cout.zdvm_bksc_diff);
    
     cout.indc = [cout.indc ones(size(cadd.lon))*indc];
 end

 try
    cout.zdvm_bksc_mean = nanmean([cout.zdvm_bksc_day' cout.zdvm_amp_diff'],2)';
 end
 
 

