
 function ii = findin(val,vect)
    ii = find(prod(sign(vect-val),2)<=0,1,'last');
 end

