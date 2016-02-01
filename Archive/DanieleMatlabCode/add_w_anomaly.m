 function secout = correct_w(sec)

% Adds a velocity anomaly field to the section 

 secout = sec;

 if isfield(sec,'w') & isfield(sec,'wmean');
    ntime =  size(sec.amp,1);
    ndepth = size(sec.amp,1);
    wmean = sec.wmean;
    wmean = repmat(wmean,ndepth,1);
    secout.wdev = sec.w - wmean; 
  end
  

