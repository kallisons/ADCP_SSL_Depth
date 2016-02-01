 function [cout cruise] = load_dvm_pattern2(indf) 

 indir  = '/Users/danielebianchi/AOS/ZOOPLANKTON/ADCP/scripts/analysis/dvm_output/output_flag1/';
 cindir = '/Users/danielebianchi/AOS/ZOOPLANKTON/ADCP/cruises/';

 indirinfo = dir(indir);

 allfiles = {indirinfo.name}'; 
 indb       =  ~strncmp(allfiles,'dvm',3);
 allfiles(indb) = [];

 nfiles = length(allfiles);

%indf=230;
 
 tmp =  load([indir allfiles{indf}]);
 tfield = fieldnames(tmp);
 tfield = tfield{1};
 cout = tmp.(tfield);
 
 tmp = load([cindir cout.name]);
 cruise = tmp.(cout.name);
 
% to find where in allfiles is a specific cruise
% indf = find(~cellfun('isempty',(strfind(allfiles,cruisename)))) 
