 function [cout count_cruise count_dots] = make_figures_all_dvm_depth(varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default arguments:
A.indir1         = '/Users/danielebianchi/AOS/ZOOPLANKTON/ADCP/scripts/analysis/dvm_output/dvm_depth_data/';
A.indir2         = '/Users/danielebianchi/AOS/ZOOPLANKTON/ADCP/cruises/';
A.outdir         = '/Users/danielebianchi/AOS/ZOOPLANKTON/ADCP/scripts/figures/';
%A.indir         = '/Users/danielebianchi/AOS/ZOOPLANKTON/ADCP/scripts/analysis/dvm_output/dvm_depth_data_february/';
% Parse required variables, substituting defaults where necessary
 A = parse_pv_pairs(A, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 ccord = nan;

 indir1 = A.indir1;
 indir2 = A.indir2;

 D = dir(indir1);

 allfiles = {D.name}';

 indb       =  ~strncmp(allfiles,'dvm',3);
 allfiles(indb) = [];

 for indc=281:length(allfiles)
    tic

    disp(['Saving figure for cruise [' allfiles{indc}(11:end-4) '] ... ' num2str(indc) '/' num2str(length(allfiles))]);

    cin = load([indir2 allfiles{indc}(11:end)]);
    cruise = cin.(allfiles{indc}(11:end-4));
    cruise = adcp_preprocess(cruise);

    cin = load([indir1 allfiles{indc}]);
    cout = cin.cout;

    cout.zdvm_bksc_mean = nanmean([cout.zdvm_bksc_day ; cout.zdvm_bksc_diff]);

    adcp_plot_dvm_pattern(cruise,cout,'visible','off')
    mprint_fig('name',[A.outdir 'dvm_pattern_' allfiles{indc}(11:end-4)])

    clear cin cruise cout

    etime = toc;
    disp(['elapsed time: ' num2str(etime)]);

    close all

 end
 
 

