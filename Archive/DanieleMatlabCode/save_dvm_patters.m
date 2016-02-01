 function save_dvm_pattern2(cout,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 A.name          = 'dvm_depth';
 A.outdir        = '/Users/danielebianchi/AOS/ZOOPLANKTON/ADCP/scripts/analysis/dvm_output/dvm_depth_data/';
% Parse required variables, substituting defaults where necessary
 A = parse_pv_pairs(A, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 savename = [A.name '_' cout.name]; 

 disp(['saving ... ' A.outdir savename]);
 save([A.outdir savename],'cout');
 
