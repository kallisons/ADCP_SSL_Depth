
 % Good cruises
 g1 = (logfile.flag==1);
 ig1 = find(g1);
 flag1.lon=[];
 flag1.lat=[];
 for indi=1: sum(g1)
    disp([num2str(indi) '/' num2str(sum(g1))])
    eval(['load /Users/danielebianchi/AOS/ZOOPLANKTON/ADCP/cruises/' logfile.names{ig1(indi)} ';']);
    eval(['cruise = ' logfile.names{ig1(indi)} ';']);
    eval(['clear  ' logfile.names{ig1(indi)} ';']);
    flag1.lon = [flag1.lon cruise.lon]; 
    flag1.lat = [flag1.lat cruise.lat]; 
 end

 % Good cruises
 g2 = (logfile.flag==3);
 ig2 = find(g2);
 flag2.lon=[];
 flag2.lat=[];
 for indi=1: sum(g2)
    disp([num2str(indi) '/' num2str(sum(g2))])
    eval(['load /Users/danielebianchi/AOS/ZOOPLANKTON/ADCP/cruises/' logfile.names{ig2(indi)} ';']);
    eval(['cruise = ' logfile.names{ig2(indi)} ';']);
    eval(['clear  ' logfile.names{ig2(indi)} ';']);
    flag2.lon = [flag2.lon cruise.lon]; 
    flag2.lat = [flag2.lat cruise.lat]; 
 end

 % Not Evident
 g3 = (logfile.flag==2);
 ig3 = find(g3);
 flag3.lon=[];
 flag3.lat=[];
 for indi=1: sum(g3)
    disp([num2str(indi) '/' num2str(sum(g3))])
    eval(['load /Users/danielebianchi/AOS/ZOOPLANKTON/ADCP/cruises/' logfile.names{ig3(indi)} ';']);
    eval(['cruise = ' logfile.names{ig3(indi)} ';']);
    eval(['clear  ' logfile.names{ig3(indi)} ';']);
    flag3.lon = [flag3.lon cruise.lon]; 
    flag3.lat = [flag3.lat cruise.lat]; 
 end

 % Surface only
 g4 = (logfile.flag==2);
 ig4 = find(g4);
 flag4.lon=[];
 flag4.lat=[];
 for indi=1: sum(g4)
    disp([num2str(indi) '/' num2str(sum(g4))])
    eval(['load /Users/danielebianchi/AOS/ZOOPLANKTON/ADCP/cruises/' logfile.names{ig4(indi)} ';']);
    eval(['cruise = ' logfile.names{ig4(indi)} ';']);
    eval(['clear  ' logfile.names{ig4(indi)} ';']);
    flag4.lon = [flag4.lon cruise.lon]; 
    flag4.lat = [flag4.lat cruise.lat]; 
 end


 figure
 plot_coast;
 hold on
 plot(flag4.lon,flag4.lat,'y.')
 plot(flag3.lon,flag3.lat,'g.')
 plot(flag2.lon,flag2.lat,'r.')
 plot(flag1.lon,flag1.lat,'b.')


