 function sec = plot_amplitude(sec,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Descrirpiton: 
% Usage:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% History:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default arguments:
% taken from Takikawa et al., 2008
A.scale_fact 	= 0.46;		% conversion from ADCP counts ("amp") to decibel (dB)
A.absorp 	= 0.009;	% average ocean sound absorption (dB m-1) according to Francois and Garrison (1982)
A.inoise	= 0;		% (1) noise=min(amp) (2) noise=deepest(amp). Default = 1
A.idev		= 0;		% (0) don't subtract mean surface backscatter (1) subtract mean surface backscatter
% Parse required variables, substituting defaults where necessary
Param = parse_pv_pairs(A, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% - Calculate a "deviation backscatter", by subtracting a reference backscatter
%   from the average surface backscatter over the deployment time
% - corrects for beam spreading and water absorption

 amp 	= sec.amp;
 depth 	= sec.depth; 

 nz = size(amp,1); 
 nt = size(amp,2); 

% (1) Corrects for noise, calculated as either the minimum (1) or the deepest (2) amp value
%     in each profile including values flagged as NaN
 switch Param.inoise
 case 0
    disp('WARNING: No noise subtracted');
 case 1
    amp = amp - repmat(min(amp),nz,1);   
 case 2
    amp = amp - repmat(amp(end,:),nz,1);   
 otherwise
    error('inoise not valid');
 end

% (2) Calculate the backscatter (dB) from the ADCP counts, using the scale factor

 bksc = Param.scale_fact * amp;

% (3) Corrects for water absorption and beam spreading using R, vertical distance from transducer
% Technically slanted distance should be used - but here angle is ignored
% This will bias absolute values
% Adds in the 1/4 mean bin thickness. Not sure about this, but definitely helps for the logarithm
 rdepth = depth - repmat(depth(1,:),nz,1); 
 zbin   = diff(depth,1); 
 zbin0  = repmat(zbin(1,:),nz,1)/2;		% Distance of transducer to first bin Center 
 zbin4  = nanmean(zbin(:))/4;			% 1/4 bin size (average)
 rdepth = rdepth + zbin0 + zbin4 +10;

 beam_spread = 20*log10(rdepth);
 beam_absorp = 2 * Param.absorp * rdepth;

 bksc = bksc + beam_spread + beam_absorp; 

% (4) If needed calculate the deviation from the mean surface value of de-noised backscatter
 if Param.idev==1
    bksc = bksc - nanmean(bksc(1,:)); 
 end

% NOTE: this calculation should include many other constants for backscatter that are not available for this dataset
% see Deines, 1999, IEEE report

 sec.bksc = bksc;
