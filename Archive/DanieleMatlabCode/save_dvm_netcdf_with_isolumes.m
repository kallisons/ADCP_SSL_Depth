 if (1)
    dx = 4;
    dy = 4;

    gout.zdvm_bksc_day = grid_dvm_dataset(mout,'var','zdvm_bksc_day','dx',dx,'dy',dy);
    gout.zdvm_bksc_diff = grid_dvm_dataset(mout,'var','zdvm_bksc_diff','dx',dx,'dy',dy);
    gout.zdvm_amp_diff = grid_dvm_dataset(mout,'var','zdvm_amp_diff','dx',dx,'dy',dy);
    gout.zdvm_bksc_mean = grid_dvm_dataset(mout,'var','zdvm_bksc_mean','dx',dx,'dy',dy);

    gout.irr_mean = grid_dvm_dataset(mout,'var','irr_swmax_uitz_on_zdvm_bksc_mean','dx',dx,'dy',dy);
    gout.irr_420  = grid_dvm_dataset(mout,'var','irr_swmax_420_on_zdvm_bksc_mean','dx',dx,'dy',dy);
    gout.irr_480  = grid_dvm_dataset(mout,'var','irr_swmax_480_on_zdvm_bksc_mean','dx',dx,'dy',dy);

 end

  varsave = {'zdvm_bksc_day','zdvm_bksc_diff','zdvm_bksc_mean','irr_mean','irr_420','irr_480'};

  filename = ['dvm_gridded_' num2str(dx) 'x' num2str(dy) '_isolumes' ];
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


