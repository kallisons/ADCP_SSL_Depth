 function [cc hh ee] = plot_amplitude(sec,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Descrirpiton: 
% Usage:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% History:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default arguments:
A.var       = 'amp';
A.flag      = 1;
A.fact      = 1;
A.size      = 60;
A.mode      = 'pcolor';
A.xax       = 'day';
A.elev      = 1;
A.bott	    = 0;
A.blank	    = 1; % 0: no blank; 1 deepest 10% ; 2 minimum
A.fraction  = 0.1; % used for blanks, lowest fraction of amplitude to subtract
A.fig	    = 1;
A.cbar	    = 1;
A.palette   = 'jet';
A.sunsize   = 2;
A.sunstyle  = '-k';
A.clev      = 30;
A.ccol      = 'k';
A.flab      = 15;
A.ftitle    = 15;
% Parse required variables, substituting defaults where necessary
A = parse_pv_pairs(A, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 ldepth = -sec.depth(:,1);

 % Check whether depth changes over the cruise 
 ddepth = sec.depth - repmat(sec.depth(:,1),1,size(sec.depth,2));
 profddepth = find(sum(ddepth,1)~=0);
 if ~isempty(profddepth)
    disp(['WARNING : different depth or NaNs in # ' num2str(length(profddepth)) ' profiles']);
 end

 switch A.xax
 case 'day'
    lday = sec.dday;
    txlab = 'Day';
 case 'sample'
    lday = [1:length(sec.dday)];
    txlab = 'Sample #';
 otherwise
    lday = [1:length(sec.dday)];
    txlab = A.xax
 end

 switch A.var
 case 'amp'
   %plotvar = sec.amp - repmat(sec.amp(end,:),size(sec.amp,1),1);
   % Corrects each profile by subtracting a local value
    switch A.blank
    case 0
       plotvar = sec.amp;
    case 1
       % uses as blank the mean of last 10% lowest points
      %sortprof  = sort(sec.amp,1);
      %thisblank =repmat(nanmean(sortprof(1:ceil(length(ldepth)/10),:)),size(sec.amp,1),1);
      %thisblank =repmat(nanmean(sortprof(1:max((length(ldepth)-1),ceil(length(ldepth)/10)),:)),size(sec.amp,1),1); % WRONG BUT USED FOR A WHILE: USES TOP AMPLITUDE AS BLANK!!!
      %thisblank =repmat(nanmean(sortprof(1:min((length(ldepth)-1),ceil(length(ldepth)/10)),:)),size(sec.amp,1),1);
      %plotvar = sec.amp - thisblank;
      sec1 = adcp_deblank(sec,'fraction',A.fraction);
      plotvar = sec1.amp;
    case 2
       plotvar = sec.amp - repmat(min(sec.amp),size(sec.amp,1),1);
    end
    ttitle = [sec.name ' - ' A.var];
 case {'bksc','back','bs','backscatter'}
    if ~isfield(sec,'bksc')
       sec = adcp_calculate_backscatter(sec);
    end
    switch A.blank
    case 0
       plotvar = sec.bksc;
    otherwise
      sec1 = adcp_deblank(sec,'fraction',A.fraction);
      plotvar = sec1.bksc;
    end
    ttitle = [sec.name ' - ' A.var];
 otherwise
    plotvar = sec.(A.var);
    ttitle = [sec.name ' - ' A.var];
 end
 ttitle = [ttitle ' # profiles: ' num2str(length(sec.dday))]; 

 tylab = 'Depth';
 
 if A.flag==1
    disp(['Removing bad flags']);
    isbad = sec.pflag~=0;
    plotvar(isbad) = nan;
 end

 if A.fig==1
    figure
 end

 plotvar = plotvar .* A.fact;

 switch A.mode
 case 'contour'
    [cc hh] = contour(lday,ldepth,plotvar,A.clev);
    set(hh,'color',A.ccol);
    shading flat;
 case 'contourf'
    [cc hh] = contourf(lday,ldepth,plotvar,A.clev);
    set(hh,'edgecolor','none');
 case 'pcolor'
   %hh = pcolor(lday,ldepth,plotvar);
    hh = sanePColor(lday,ldepth,plotvar);
    cc = nan;
    shading flat;
 case 'scatter'
    sec.aday = repmat(sec.dday,size(sec.depth,1),1);
    tday = sec.aday(:);
    tdepth = sec.depth(:);
    hh = scatter(tday(:),-tdepth(:),A.size,plotvar(:),'filled');
    cc = nan;
 otherwise 
    error('Must supply a good plotting mode');
 end

%set(gca,'ydir','reverse');


 if ~strcmp(A.mode,'contour')
   %tcax = [nanmean(plotvar(end,:)) nanmean(plotvar(1,:))];
    tcax = [prctile(plotvar(:),5) prctile(plotvar(:),95)];
   %if any(isnan(tcax)) | strcmp(A.var,'backscatter')
    if any(isnan(tcax))
       tcax = [min(plotvar(:)) max(plotvar(:))];
    end
    if isnan(tcax(1));tcax(1)=0;end
    if isnan(tcax(end));tcax(end)=200;end
    tcax = sort(tcax);
    caxis(tcax);
   
    if A.cbar==1
       colorbarn('palette',A.palette);
    end
 end

 xlabel(txlab,'fontsize',A.flab);
 ylabel(tylab,'fontsize',A.flab);
 title(ttitle,'fontsize',A.ftitle,'interpreter','none');

 hold on
 if A.elev==1 & isfield(sec,'elevation')
   %disp(['CONTOUR: ' num2str(A.sunsize)]);
    plot([lday(1) lday(end)],[0 0],'-k','linewidth',2);
    ee = plot(lday,sec.elevation,A.sunstyle,'markersize',A.sunsize);
    tylim = get(gca,'ylim');
    tylim(2) = max(90,tylim(2));
    ylim(tylim);
 else
    tylim = get(gca,'ylim');
    tylim(2) = max(0,tylim(2));
    ylim(tylim);
 end

 if A.bott==1 & isfield(sec,'depth_bt')
    hold on
    plot(lday,-sec.depth_bt,'-k','linewidth',2);
    tylim = get(gca,'ylim');
    tylim(1) = min(min(-sec.depth_bt),tylim(1));
    ylim(tylim);
 end
    
 if ~strcmp(A.xax,'day') & ~strcmp(A.xax,'sample')
    txtick    = get(gca,'xtick');
   %txticklab = get(gca,'xticklabel');
    newticklab  = round(sec.(A.xax)(findin(txtick, lday)));
    newticklab = num2str(newticklab(:)) 
    set(gca,'xticklabel',newticklab);
 end




  
