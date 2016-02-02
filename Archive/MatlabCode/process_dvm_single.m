function [cruise cout] = process_dvm_single(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Descrirpiton: 
% Usage:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default arguments:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 A.logfilename	= '/Users/danielebianchi/AOS/ZOOPLANKTON/ADCP/scripts/analysis/logfile_merged_march.mat';
 A.indir 	= '/Users/danielebianchi/AOS/ZOOPLANKTON/ADCP/cruises/'; 
 A.outdir 	= '/Users/danielebianchi/AOS/ZOOPLANKTON/ADCP/scripts/analysis/dvm_output/'; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 A.name 	= 'cruise_00725';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 A.useflag 	= 1;
 A.cflag 	= 1;
 A.cblank	= 1;
 A.cpreproc	= 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 A.tminres	= 60; % minutes - minimum resolution required for processing
 A.nhday 	= 2.0;  % hours - daytime interval (half-width)
 A.nhnig 	= 2.0;  % hours - nighttime interval (half-width)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 A.plotfig	= 0;
 A.closefig	= 0;
 A.savefig	= 0;
 A.saveout	= 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parse required variables, substituting defaults where necessary
 A = parse_pv_pairs(A, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Unwrap A
 Afields = fieldnames(A);
 for indf=1:length(Afields)
    eval([Afields{indf} ' = A.' Afields{indf} ';']);
 end

 load(logfilename);
   
 indb=[];
 for indc=1:logfile.nfiles
    if logfile.flag(indc)~=useflag
       indb = [indb indc];
    end
 end
 logfile.names(indb) 	= [];
 logfile.processed(indb) = [];
 logfile.flag(indb) 	= [];
 logfile.comment(indb) 	= [];
 logfile.date(indb) 	= [];
 logfile.nfiles = length(logfile.flag);

 indc = find(strcmp(logfile.names,name));

    disp(['-------------------------------------------------------']);
    disp(['Extracting DVM pattern in cruise  ... ' A.name ]);
    disp([logfile.comment{indc} ]);
    load([indir A.name]) 
    eval(['cruise = ' A.name ';']); 
    eval(['clear ' A.name ';']); 
    if cpreproc==1
       cruise = adcp_preprocess(cruise);
    end

    cout = analyze_cruise(cruise,'flag',cflag,'blank',cblank,'preprocess',0, ...
                                 'minres',tminres,'nhday',nhday,'nhnig',nhnig);

    if (1)
       % Adds the same calculation done with approximate backscatter to the one done for raw amplitude
       cout2 = analyze_cruise(cruise,'flag',cflag,'blank',cblank,'preprocess',0, ...
                                    'minres',tminres,'nhday',nhday,'nhnig',nhnig,'var','bksc');
       cout.bkscday = cout2.bkscday;
       cout.bkscdiff = cout2.bkscdiff;
    end

    if saveout==1
       eval(['dvm_'  A.name ' = cout;']);
       eval(['save ' outdir  'dvm_'  A.name ' dvm_'  A.name ';'])
       end

    if plotfig==1
          adcp_dvm_depth(cruise,cout,'flag',cflag);
          drawnow
    end

    if savefig==1
       sfname = ['dvm_' A.name];
       mprint_fig('name',[outdir sfname],'sty','nor7')
    end

    if closefig==1
       close all
    end
 

 

