 function data = load_glodap  

 load('/Users/danielebianchi/AOS/DATA_ANALYSIS/WOA01_SUBOXIA/glocar1.mat')
%load('/wrk/meriel/dbianchi/datasets/glofinal.mat')

 data = glocar1;
 if isfield(data,'o2interp')
    data = rmfield(data,'o2interp');
 end

 varkeep = { 'lon','lat','depth','press','bottom', ... 
           'ustation','temp','salt','gamma', ... 
           'no3','o2','po4','sio2'};
          
 for ind=1:glocar1.nvar
     if ~any(strcmp(varkeep,glocar1.var{ind})) 
        disp(['removing field: ' glocar1.var{ind}]);
        data = woce2_rmvar(data,'var',glocar1.var{ind});
     end
 end

 data = woce2_clean(data,'var','o2','val',[0 500],'method','i');
 data = woce2_clean(data,'var','press','val',[0 10000],'method','i');
 data = woce2_clean(data,'var','depth','val',[0 10000],'method','i');



