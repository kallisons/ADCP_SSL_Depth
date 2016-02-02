
 mout = combine_all_dvm_depth;
 
 cout = mout;

 cout.name = 'global';

 % ---------------------------------------------------------------------------------------
 % Loads some variable
 addpath ../irradiance/
 prepare_isolume_calculation;
 
 % Loads Allison's light and elevation
 load -ascii locs_sun2.dat
 cout.dswrf 	= locs_sun2(:,11);
 cout.eph_elev 	= locs_sun2(:,10);
 cout.dswrf 	= cout.dswrf(:)';
 cout.eph_elev 	= cout.eph_elev(:)'; 

 % ---------------------------------------------------------------------------------------
 % Adds temperature and other oceanographic variables
 % Add oxygen sampled at month and depth of observation
 if (0)
 SD = netcdf_read(['/Users/danielebianchi/AOS/DATA_ANALYSIS/WOA01_SUBOXIA/netcdf/woce_monthly_linear.nc']);
    sdnames = {SD.VarArray.Str};
    sddata  = {SD.VarArray.Data};
    indd = 6;
    disp(['Loading ' sdnames{indd}]);
    oxyclim.o2= double(sddata{indd});
    oxyclim.o2(oxyclim.o2<0)=nan;
    oxyclim.lon   =  double(sddata{1});
    oxyclim.lat   =  double(sddata{2});
    oxyclim.depth =  double(sddata{3});
 end
 if (0)
    load(['/Users/danielebianchi/AOS/DATA/GLODAP/GRIDDED/merged_gridded.mat']); 
 end
 cout = adcp_add_variable_at_depth(cout,merged_gridded,'var2','temp','var1','zdvm_bksc_mean')
 cout = adcp_add_variable_at_depth(cout,merged_gridded,'var2','temp','var1','zdvm_bksc_day')
 cout = adcp_add_variable_at_depth(cout,merged_gridded,'var2','temp','var1','zdvm_bksc_diff')

 cout = adcp_add_variable_at_depth_monthly(cout,oxyclim,'var2','o2','var1','zdvm_bksc_mean')
 cout = adcp_add_variable_at_depth_monthly(cout,oxyclim,'var2','o2','var1','zdvm_bksc_day')
 cout = adcp_add_variable_at_depth_monthly(cout,oxyclim,'var2','o2','var1','zdvm_bksc_diff')
 % ---------------------------------------------------------------------------------------

 % Adds Isolume from global climatologies
 % (also adds in mld, swclim, swmax, chlclim - used hereafter for "unstructured" calculation, to avoid re-interpolation);
 cout = add_isolume(cout,chlclim,swclim,mldclim,'irrlevel',10^(-3.5),'delthour',2,'mode','uitz','name','iso_swclim_3p5_uitz');
 cout = add_isolume_unstructured(cout,cout.chlsurf,cout.swmax,cout.mld,'irrlevel',10^(-3.5),'delthour',2,'mode','constant','name','iso_swclim_3p5_const120');

 % Adds Isolume from Alison's in situ light
 cout = add_isolume_unstructured(cout,cout.chlsurf,cout.dswrf,cout.mld,'irrlevel',10^(-3.5),'delthour',2,'mode','uitz','name','iso_swobs_3p5_uitz');
 cout = add_isolume_unstructured(cout,cout.chlsurf,cout.dswrf,cout.mld,'irrlevel',10^(-3.5),'delthour',2,'mode','constant','name','iso_swobs_3p5_const120');

 % Adds Light at depth from global climatologies
 cout = add_irradiance_unstructured(cout,cout.swmax,cout.chlsurf,cout.mld,'depth','zdvm_bksc_mean','mode','uitz','name','irr_swclim_uitz');
 cout = add_irradiance_unstructured(cout,cout.swmax,cout.chlsurf,cout.mld,'depth','zdvm_bksc_day' ,'mode','uitz','name','irr_swclim_uitz');
 cout = add_irradiance_unstructured(cout,cout.swmax,cout.chlsurf,cout.mld,'depth','zdvm_bksc_diff','mode','uitz','name','irr_swclim_uitz');

 cout = add_irradiance_unstructured(cout,cout.swmax,cout.chlsurf,cout.mld,'depth','zdvm_bksc_mean','mode','constant','name','irr_swclim_const120');
 cout = add_irradiance_unstructured(cout,cout.swmax,cout.chlsurf,cout.mld,'depth','zdvm_bksc_day' ,'mode','constant','name','irr_swclim_const120');
 cout = add_irradiance_unstructured(cout,cout.swmax,cout.chlsurf,cout.mld,'depth','zdvm_bksc_diff','mode','constant','name','irr_swclim_const120');

 % Adds Light at depth from Allison's in situ light
 cout = add_irradiance_unstructured(cout,cout.dswrf,cout.chlsurf,cout.mld,'depth','zdvm_bksc_mean','mode','uitz','name','irr_swobs_uitz');
 cout = add_irradiance_unstructured(cout,cout.dswrf,cout.chlsurf,cout.mld,'depth','zdvm_bksc_day' ,'mode','uitz','name','irr_swobs_uitz');
 cout = add_irradiance_unstructured(cout,cout.dswrf,cout.chlsurf,cout.mld,'depth','zdvm_bksc_diff','mode','uitz','name','irr_swobs_uitz');

 cout = add_irradiance_unstructured(cout,cout.dswrf,cout.chlsurf,cout.mld,'depth','zdvm_bksc_mean','mode','constant','name','irr_swobs_const120');
 cout = add_irradiance_unstructured(cout,cout.dswrf,cout.chlsurf,cout.mld,'depth','zdvm_bksc_day' ,'mode','constant','name','irr_swobs_const120');
 cout = add_irradiance_unstructured(cout,cout.dswrf,cout.chlsurf,cout.mld,'depth','zdvm_bksc_diff','mode','constant','name','irr_swobs_const120');

 % ---------------------------------------------------------------------------------------
 % Some post-processing
 varnames = fieldnames(cout);
 nvar=0;
 cout.ncast 	= length(cout.lon);
 cout.var 	= {};
 cout.nvar 	= 0;
 cout.avar 	= {};
 cout.navar 	= 0;
 cout.ismeasurement = [];

 for indv=1:length(varnames) 
    if isnumeric(cout.(varnames{indv}))
       if size(cout.(varnames{indv}),2)==cout.ncast
          cout.nvar = cout.nvar+1;
          cout.var  = [cout.var varnames{indv}];
          if size(cout.(varnames{indv}),1)==1 & all(~strcmp({'lon','lat'},varnames{indv}))
             cout.ismeasurement = [cout.ismeasurement 1];
          else
             cout.ismeasurement = [cout.ismeasurement 0];
          end
       end
    end
 end

 if (0)
    % Saves out:
    dvm_depth_data2 = cout;
    save dvm_depth_data2 dvm_depth_data2
 end


