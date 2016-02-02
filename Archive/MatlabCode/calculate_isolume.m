

 % -------------------------------------------------------------------------
 % Estimates the depth of an visible light isolume globally
 % Assuming surface irradiance from climatology
 % Light absorption from water and chlorophyll
 % Using the 2 wavelength scheme of Manizza et al., 2005
 % -------------------------------------------------------------------------

 if (1)
 % -------------------------------------------------------------------------
 % Load monthly SeaWIFS chlorophyll

 SD = netcdf_read(['/Users/danielebianchi/AOS/DATA/GLODAP/GRIDDED/DUNNE/seawifs_chl_from_wga_199709200703.nc']);
 sdnames = {SD.VarArray.Str};
 sddata  = {SD.VarArray.Data};
 chl  = double(sddata{6});
 time = double(sddata{4});
 lon = double(sddata{1});
 lat = double(sddata{2});

 chl = squeeze(chl);
 chl(chl<0) = nan;
 % samples 9 years of chlorophyll
 nyears = 9;
 nlon = length(lon);
 nlat = length(lat);
 chl = chl(1:nyears*12,:,:);
 month = [1:108];

 % -------------------------------------------------------------------------
 % creates climatological monthly chlorophyll map
 chlclim = squeeze(nanmean(reshape(chl,12,nyears,180,360),2));

 % -------------------------------------------------------------------------
 % Reshape since chl data starts in September
 tempo = nan(size(chlclim));
 tempo(1:8,:,:) = chlclim(5:end,:,:,:);
 tempo(9:12,:,:) = chlclim(1:4,:,:,:);
 chlclim = tempo;

 data.lon = lon;
 data.lat = lat;
 data.time = time;
 data.chlclim = chlclim;

 % -------------------------------------------------------------------------
 % loads surface SW irradiance from CORE
 SD = netcdf_read(['/Users/danielebianchi/AOS/DATA/CORE/SWDN_MOD_ny.nc']);
 sdnames = {SD.VarArray.Str};
 sddata  = {SD.VarArray.Data};
 sw  = double(sddata{5});
 time = double(sddata{4});
 lon = double(sddata{1});
 lat = double(sddata{2});

 nlon = length(lon);
 nlat = length(lat);

 % -------------------------------------------------------------------------
 % interpolates sw climatology on standars 1x1 degree grid (from chl) 

 sw2 = nan(365,180,360);

 [xx  yy]  = meshgrid(lon,lat);
 [xx1 yy1] = meshgrid(data.lon,data.lat);
 for indd=1:365
    sw2(indd,:,:) = interp2(xx,yy,squeeze(sw(indd,:,:)),xx1,yy1); 
 end
 
 % -------------------------------------------------------------------------
 % Calculates the daytime mean irradiance
 % -------------------------------------------------------------------------
   
 % Estimates the daytime mean normalized irradiance  
 % for each day, for each latitude
 % This should multiply the 24 hr mean irradiance to obtain
 % the daily mean irradiance only for hours of light

 tstep = 24*60;
 houryear = [1/tstep:1/tstep:365];
 dayfact = nan(365,length(data.lat));
 lat = data.lat;
%latcutoff = 66.5;
 latcutoff = 90;
 for indl = 1:length(lat);
    % Create a annual series of normalized irradiance
    if abs(lat(indl))<latcutoff
       sfact =  sun_normalized_diurnal_cycle(houryear,lat(indl));
       dayfactlat = nan(365,1);
       for indd=1:365
           hstart = (indd-1)*tstep+1;
           hend   =  indd*tstep;
           daysw = sfact(hstart:hend);
           daysw = daysw(daysw>0);
          %disp(indd);
           dayfactlat(indd) = mean(daysw);
          %disp(dayfactlat(indd));
       end
       dayfact(:,indl) = dayfactlat;
    end
 end
 
 % -------------------------------------------------------------------------
 % Corrects the 24hr sw climatology 
 % to get the daytime  mean sw
 sw3 = nan(size(sw2));
 for indl=1:360
     sw3(:,:,indl) = sw2(:,:,indl) .* dayfact;  
 end
 
 % -------------------------------------------------------------------------
 % creates monhtly climatological surface iradiance 
 % from daily climatology
 nlon = length(data.lon);
 nlat = length(data.lat);
 lmonth = [31 28 31 30 31 30 31 31 30 31 30 31];
 swdclim = nan(12,nlat,nlon);
 sday = 1;
 for indm = 1:12
   eday = sday + lmonth(indm) - 1;
   disp([num2str(sday) '  -  ' num2str(eday)]);
   swdclim(indm,:,:) =  squeeze(mean(sw3(sday:eday,:,:),1)); 
   sday = eday+1;
 end

 data.swdclim = swdclim;

 end % Creating input structure data

 % -------------------------------------------------------------------------
 % Calculates the isolume depth
 % Uses Manizza et al., 2005 parameterization
 % -------------------------------------------------------------------------
   
 isolume = 1e-3;	% Isolume in w/m2
 
 kw_red   = 0.225;
 kw_blu   = 0.0232;
 kchl_red = 0.037;
 kchl_blu = 0.074;
 exp_red  = 0.629;
 exp_blu  = 0.674;
 albedo   = 0.08;

 dz    = 10; 
 maxdepth = 1500;
 depth = [-maxdepth+dz/2:dz:-dz/2];
 bdepth = [-maxdepth:dz:0];
 
 % -------------------------------------------------------------------------
 % Simple vertical profile of chlorophyll - sigmoidal
 ichl = zeros(size(depth));
 %ichl(depth>=chlcutoff) = 1; 
 chlcutoff = -100;	% cutoff depth for chlorophyll - decreases to 0 below
 chlwidth  = 15;
 ichl = 1/2 * (1+erf((depth-chlcutoff)/(2*chlwidth)));
 % -------------------------------------------------------------------------

 % Flips depths and ichl
 depth  =  fliplr(depth);
 bdepth =  fliplr(bdepth);
 ichl   =  fliplr(ichl);
 nbz = length(bdepth);

 isodepth = nan(size(data.chlclim));

 oceanlight = nan(12,length(depth),180,360);
 oceanichl  = nan(12,length(depth),180,360);

 for indm=1:12
    for indla=1:180 
       for indlo=1:360 
         fprintf(['calculating isolume at : [' num2str(indm) ',' num2str(indla) ',' num2str(indlo) '] \r']);
         % Calculates the light profile with depth
         if ~isnan(data.chlclim(indm,indla,indlo)) & ~isnan(data.swdclim(indm,indla,indlo))
            lightz = nan(size(bdepth));
            lightz_red = nan(size(bdepth));
            lightz_blu = nan(size(bdepth));
            lightz(1) = (1-albedo)*data.swdclim(indm,indla,indlo);
            lightz_red(1) = lightz(1)/2;
            lightz_blu(1) = lightz(1)/2;
            chlz   = data.chlclim(indm,indla,indlo) * ichl;
            for indz=1:length(depth)
               k_red = kw_red + kchl_red * chlz(indz).^exp_red; 
               k_blu = kw_blu + kchl_blu * chlz(indz).^exp_blu; 
              %lightz_red(indz+1) = lightz_red(indz) * (1-k_red*dz)./(1+k_red*dz); 
              %lightz_blu(indz+1) = lightz_blu(indz) * (1-k_blu*dz)./(1+k_blu*dz); 
               lightz_red(indz+1) = lightz_red(indz) * exp(-k_red*dz); 
               lightz_blu(indz+1) = lightz_blu(indz) * exp(-k_blu*dz); 
               lightz(indz+1) = lightz_red(indz+1) + lightz_blu(indz+1);   
            end
            % slightly convoluted interpolation
            % just carried on by some sloppy coding 
            loglightz = log10(lightz);  
            iloglightz = interp1(bdepth,loglightz,depth,'linear');
            oceanlight(indm,:,indla,indlo) = iloglightz;
            oceanichl(indm,:,indla,indlo) = chlz;
            % Finds the position of the isolume with depth
            iz = sum((lightz>=isolume));
            if iz<nbz
               isodepth(indm,indla,indlo) = bdepth(iz);
            end
         end
       end
    end
 end
 disp(' ');
 disp(['End calculation - isolume : ' num2str(isolume)]);
 
 data.depth  	= depth(:);
 data.isolume  	= isolume;
 data.isodepth 	= isodepth;
 data.loglight 	= oceanlight;
 data.ichl 	= oceanichl;

 % netcdf_save_2d_time(data.isodepth_1em6,data.lon,data.lat,[1:12],'name','isodepth_1em6','filename','isolume_depth','mode','clobber')



