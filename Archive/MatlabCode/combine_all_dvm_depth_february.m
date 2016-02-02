 function [cout] = load_dvm_pattern(varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default arguments:
%A.indir          = '/Users/danielebianchi/AOS/ZOOPLANKTON/ADCP/scripts/analysis/dvm_output/dvm_depth_data/';
A.indir          = '/Users/danielebianchi/AOS/ZOOPLANKTON/ADCP/scripts/analysis/dvm_output/dvm_depth_data_february/';
% Parse required variables, substituting defaults where necessary
 A = parse_pv_pairs(A, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
 cout.zdvm_amp = cadd.zdvm_amp;
 cout.zdvm_diff = cadd.zdvm_diff;
 
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
    ccord = [307 308 30 38]; %%%% IMPORTANT 00725 - Atlantic
    if any( (cadd.lon>ccord(1) & cadd.lon<ccord(2)) & (cadd.lat>ccord(3) & cadd.lat<ccord(4)) )
       disp(['Check found at: -------------------->' cadd.name])
    end

    cout.lon = [cout.lon cadd.lon];
    cout.lat = [cout.lat cadd.lat];
    cout.time = [cout.time cadd.time];
    cout.elevation = [cout.elevation cadd.elevation];
    cout.zdvm_amp = [cout.zdvm_amp cadd.zdvm_amp];
    cout.zdvm_diff = [cout.zdvm_diff cadd.zdvm_diff];

    % Negative vales! (there is 1 mistaken positive one - added by hand probabl
     cout.zdvm_amp = -abs(cout.zdvm_amp);
     cout.zdvm_diff = -abs(cout.zdvm_diff);
    
 end

 try
    cout.zdvm_mean = nanmean([cout.zdvm_amp' cout.zdvm_diff'],2)';
 end
 
 

