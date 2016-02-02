
 function ii = findin(val,vect)
 % usage: ii = findin(val,vect)
    dd = abs(vect-val);
    [mm ii] = min(dd);
 end

