 function logfile = merge(log1,log2,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots a dataset map in longitude-latitude space
% Usage:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% History:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default arguments:
A.logname       = 'logfile_merged';
% Parse required variables, substituting defaults where necessary
A = parse_pv_pairs(A, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 logfile.logname  	= A.logname 
 logfile.names 		= [log1.names ; log2.names]; 
 logfile.nfiles 	= length(logfile.names);
 logfile.processed 	= [log1.processed ; log2.processed];
 logfile.flag 		= [log1.flag ; log2.flag];
 logfile.comment 	= [log1.comment ; log2.comment];
 logfile.date 		= [log1.date ; log2.date];

 
 % Checks for multiple
 % Will code some other time!!!! 

 [unames I J] = unique(logfile.names); 


