
%indf = 1;

%close all

cout = dvm_find_depth(cout,'var','ampday' ,'width',twidth,'depth',depths,'name','zdvm_amp_day','mode','max','day',days);
cout = dvm_find_depth(cout,'var','bkscday' ,'width',twidth,'depth',depths,'name','zdvm_bksc_day','mode','max','day',days);

cout = dvm_find_depth(cout,'var','bkscdiff','width',twidth,'depth',depths,'name','zdvm_bksc_diff','mode','max','day',days);
cout = dvm_find_depth(cout,'var','ampdiff','width',twidth,'depth',depths,'name','zdvm_amp_diff','mode','max','day',days);

cout.process.days = days;
cout.process.depths = depths;

%adcp_dvm_plot_points_backscatter(cruise,cout);
adcp_dvm_plot_points_backscatter(cruise,cout,'flag',0);

%save_dvm_patters(cout,'name','dvm_depth')
 
 
