 function sec = process_deblank(sec,varargin)
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 A.fraction	= 0.1;          % fraction of lowest amplitude to average as blank
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 A = parse_pv_pairs(A, varargin);
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 disp(['WARNING: Removing blanks in amp and bksc']);
 disp(['WARNING: Original AMP and BKSC saved']);

 disp(['WARNING - subtracting background amplitudes (amp)']);
 % cleans amplitude
 % by subtracting 10% smallest amplitudes
 sec.amp_org = sec.amp;
 amp0 	= sec.amp;

 ldepth = mode(sec.depth,2);

 % uses as blank the mean of last 10% lowest points
 sortprof  = sort(amp0,1);
 thisblank =repmat(nanmean(sortprof(1:max(2,min((length(ldepth)-1),ceil(length(ldepth)*A.fraction))),:)),size(amp0,1),1);
 amp = amp0 - thisblank;

 sec.amp = amp;

 if isfield(sec,'bksc')

    disp(['WARNING - subtracting background backscatter (bksc)']);
    % cleans backscatter
    % by subtracting 10% smallest amplitudes
    sec.bksc_org = sec.bksc;
    bksc0 	= sec.bksc;
   
    ldepth = mode(sec.depth,2);
   
    % uses as blank the mean of last 10% lowest points
    sortprof  = sort(bksc0,1);
    thisblank =repmat(nanmean(sortprof(1:max(2,min((length(ldepth)-1),ceil(length(ldepth)*A.fraction))),:)),size(bksc0,1),1);
    bksc = bksc0 - thisblank;

    sec.bksc = bksc;

 end 
 
