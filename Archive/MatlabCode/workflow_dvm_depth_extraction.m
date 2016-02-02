
%indf = 1;

[cout cruise] = load_dvm_pattern2(indf);

cruise = adcp_preprocess(cruise);
%close all

adcp_map(cruise);
%adcp_dvm_depth2(cruise,cout,'var','ampdiff')
%adcp_dvm_depth2(cruise,cout,'var','bkscday')

days = nan;
depths = [200 700];
twidth = 100;

cout = dvm_find_depth(cout,'var','ampday' ,'width',twidth,'depth',depths,'name','zdvm_amp_day','mode','max','day',days);
cout = dvm_find_depth(cout,'var','bkscday' ,'width',twidth,'depth',depths,'name','zdvm_bksc_day','mode','max','day',days);

cout = dvm_find_depth(cout,'var','bkscdiff','width',twidth,'depth',depths,'name','zdvm_bksc_diff','mode','max','day',days);
cout = dvm_find_depth(cout,'var','ampdiff','width',twidth,'depth',depths,'name','zdvm_amp_diff','mode','max','day',days);

cout.process.days = days;
cout.process.depths = depths;

adcp_dvm_plot_points_backscatter(cruise,cout);

%save_dvm_patters(cout,'name','dvm_depth')
 
 
