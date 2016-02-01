 function [ielevmaxb ielevmaxf delt_elevmaxf delt_elevmaxb] = find_surrounding_indeces(ielevmax,dttimein,inthourday) 

 nindexes = length(dttimein);
 
 % Finds the indexes surrounding the Max Elevation
 % Breaks the loop when the total time is reached OR
 % when the last (first) index is reached (WARNING)
 % forward search
 ielevmaxf = ielevmax+1;
 delt_elevmaxf = dttimein(ielevmaxf);
 while (delt_elevmaxf<inthourday) & (ielevmaxf<nindexes);
    ielevmaxf = ielevmaxf + 1; 
    if (ielevmaxf==nindexes); 
       disp(['WARNING: in find_surrounding_indeces.m reached last index. Stopping search']); 
    end
    delt_elevmaxf = delt_elevmaxf + dttimein(ielevmaxf);
 end
 % backward search
 ielevmaxb = ielevmax-1;
 delt_elevmaxb = dttimein(ielevmaxb+1);
 while delt_elevmaxb<inthourday & (ielevmaxb>1);
    ielevmaxb = ielevmaxb - 1;
    if (ielevmaxb==1) 
       disp(['WARNING: in find_surrounding_indeces.m reached first index. Stopping search']); 
    end
    delt_elevmaxb = delt_elevmaxb + dttimein(ielevmaxb);
 end


