 if (1)
    dx = 3;
    dy = 3;

%   daybound = [1 90 ; 91 181 ; 182 273 ; 274 365];
%   daybound = [1 31; 32 59; 60 90; 91 120; 121 151; 152 181; 182 212; 213 243; 244 273; 274 304; 305 334; 335 365];
    daybound =  [[0:364]',[1:365]']; % Daily resolution


    gout.zdvm_bksc_day 	= grid_dvm_dataset_time(mout,'var','zdvm_bksc_day','dx',dx,'dy',dy,'daybound',daybound);
    gout.zdvm_bksc_diff = grid_dvm_dataset_time(mout,'var','zdvm_bksc_diff','dx',dx,'dy',dy,'daybound',daybound);
    gout.zdvm_amp_diff 	= grid_dvm_dataset_time(mout,'var','zdvm_amp_diff','dx',dx,'dy',dy,'daybound',daybound);
    gout.zdvm_bksc_mean = grid_dvm_dataset_time(mout,'var','zdvm_bksc_mean','dx',dx,'dy',dy,'daybound',daybound);

 end

  varsave = {'zdvm_bksc_day','zdvm_bksc_diff','zdvm_bksc_mean'};

  filename = ['dvm_gridded_' num2str(dx) 'x' num2str(dy) 'x' num2str(size(daybound,1)) ];
  badvalue = -1e34;
% badvalue = -999;
 
  for indi=1:length(varsave)
     if indi==1
        smode='clobber';
     else
        smode='append';
     end
     netcdf_save_2d_time(gout.(varsave{indi}).mean,gout.(varsave{indi}).lon,gout.(varsave{indi}).lat,gout.(varsave{indi}).day, ...
                    'mode',smode,'name',[varsave{indi}],'filename',filename,'bad',badvalue)
     smode = 'append';
     netcdf_save_2d_time(gout.(varsave{indi}).std,gout.(varsave{indi}).lon,gout.(varsave{indi}).lat,gout.(varsave{indi}).day, ...
                    'mode',smode,'name',[varsave{indi} '_std'],'filename',filename,'bad',badvalue)
     netcdf_save_2d_time(gout.(varsave{indi}).num,gout.(varsave{indi}).lon,gout.(varsave{indi}).lat,gout.(varsave{indi}).day, ...
                    'mode',smode,'name',[varsave{indi} '_num'],'filename',filename,'bad',badvalue)
  end


