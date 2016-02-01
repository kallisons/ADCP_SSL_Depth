 if (1)
    dx = 4;
    dy = 4;

    gout.zdvm_bksc_day = grid_dvm_dataset(mout,'var','zdvm_bksc_day','dx',dx,'dy',dy);
    gout.zdvm_bksc_diff = grid_dvm_dataset(mout,'var','zdvm_bksc_diff','dx',dx,'dy',dy);
    gout.zdvm_amp_diff = grid_dvm_dataset(mout,'var','zdvm_amp_diff','dx',dx,'dy',dy);
    gout.zdvm_bksc_mean = grid_dvm_dataset(mout,'var','zdvm_bksc_mean','dx',dx,'dy',dy);

 end

  varsave = {'zdvm_bksc_day','zdvm_bksc_diff','zdvm_bksc_mean'};

  filename = ['dvm_gridded_' num2str(dx) 'x' num2str(dy) ];
  badvalue = -1e34;
% badvalue = -999;
 
  for indi=1:length(varsave)
     if indi==1
        smode='clobber';
     else
        smode='append';
     end
     netcdf_save_2d(gout.(varsave{indi}).mean,gout.(varsave{indi}).lon,gout.(varsave{indi}).lat,'mode',smode,'name',[varsave{indi}],'filename',filename,'bad',badvalue)
     smode = 'append';
     netcdf_save_2d(gout.(varsave{indi}).std,gout.(varsave{indi}).lon,gout.(varsave{indi}).lat,'mode',smode,'name',[varsave{indi} '_std'],'filename',filename,'bad',badvalue)
     netcdf_save_2d(gout.(varsave{indi}).num,gout.(varsave{indi}).lon,gout.(varsave{indi}).lat,'mode',smode,'name',[varsave{indi} '_num'],'filename',filename,'bad',badvalue)
  end


