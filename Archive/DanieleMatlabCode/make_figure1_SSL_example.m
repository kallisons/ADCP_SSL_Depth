
 load /Users/danielebianchi/AOS/ZOOPLANKTON/ADCP/scripts/analysis/dvm_output/dvm_depth_data/dvm_depth_cruise_01069.mat
 load /Users/danielebianchi/AOS/ZOOPLANKTON/ADCP/cruises/cruise_01069.mat

 cruise = cruise_01069;

 cruise = adcp_preprocess(cruise);
 cout.zdvm_bksc_mean = nanmean([cout.zdvm_bksc_day ; cout.zdvm_bksc_diff]);

%[A B C] = adcp_plot_dvm_pattern(cruise,cout,'depth','off');
 [A B C] = adcp_plot_dvm_pattern(cruise,cout,'depth','on');

 axes(C)
 set(C,'position', [0.630 0.150 0.14 0.14])
 axis([90 320 -45 45]);

 axes(B)
 colorbarn('palette','ferret')
 xlim([66.5 84.5])
 ylim([-700 90])
 title('Backscatter (db)','fontsize',18);


 mprint_fig('name','Figure1_SSL_example','sty','nor7')




