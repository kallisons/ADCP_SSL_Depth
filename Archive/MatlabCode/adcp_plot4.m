function format = adcp_plot4(cruise)

 figure
 s1 = subplot(2,2,1);
 adcp_map(cruise,'hold','on');

 s2 = subplot(2,2,2);
 adcp_contour(cruise,'hold','on','flag',1,'blank',1,'cbar','off');
 title(['Flags On, Blank=Deep'],'fontsize',16);

 s3 = subplot(2,2,3);
 adcp_contour(cruise,'hold','on','flag',0,'blank',1,'cbar','off');
 title(['Flags Off, Blank=Deep'],'fontsize',16);

 s4 = subplot(2,2,4);
 adcp_contour(cruise,'hold','on','flag',0,'blank',0,'bott',1,'cbar','off');
 title(['Flags off, Blank=Off'],'fontsize',16);

 
 format = 'nor1';

