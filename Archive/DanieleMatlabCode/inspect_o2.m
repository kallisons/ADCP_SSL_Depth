 depthvar = {'zdvm_bksc_mean'};
 styles = {'--r'};
 lwdt = 3;

 if (0)
    glo = load_glodap;
    load dvm_depth_data
 end

 fig = woce2_mapvar(glo,'var','o2','sty','.k','hold','off','fig',100)
 hold on
 adcp_map(dvm_depth_data,'sty','go','fig',0,'var',depthvar{1})
 
 [sec cpoly] = woce2_selcruise(glo,'draw',0,'linecol','r');
 [dvm] = adcp_select_cruise(dvm_depth_data,'poly',cpoly,'draw',0);
 sprof = woce2_meanprof(sec,'mode','mean');
 adcp_map(dvm,'sty','mo','fig',0) 

 figure
 woce2_plot_profile(sprof,'var','o2','sty','-k','linewidth',3)
 woce2_plot_profile(sec,'var','o2','sty','b.','hold','on')

 fxlim = get(gca,'xlim');
 fylim = get(gca,'ylim');

 for indd=1:length(depthvar);
    for indp=1:dvm.ncast
       tdepth = dvm.(depthvar{indd})(indp);
       if ~isnan(tdepth)
          plot(fxlim,[tdepth tdepth],styles{indd},'linewidth',lwdt) 
       end
    end
 end
 
 woce2_plot_profile(sprof,'var','o2','sty','-k','linewidth',3,'hold','on')
 woce2_plot_profile(sec,'var','o2','sty','b.','hold','on')
 
 title(['o2 : [lon=',num2str(round(mean(sprof.lon))),',lat=',num2str(round(mean(sprof.lat))),']'],'fontsize',18)
