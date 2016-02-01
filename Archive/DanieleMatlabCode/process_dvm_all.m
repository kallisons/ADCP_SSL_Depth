%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 name_logfile 	= '/Users/danielebianchi/AOS/ZOOPLANKTON/ADCP/scripts/analysis/logfile_merged_march.mat';
 indir 		= '/Users/danielebianchi/AOS/ZOOPLANKTON/ADCP/cruises/'; 
 outdir 	= '/Users/danielebianchi/AOS/ZOOPLANKTON/ADCP/scripts/analysis/dvm_output/'; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 prefix 	= 'cruise_';
%prefix 	= 'cruise_900';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 useflag 	= 3;
 cflag 		= 1;
 cblank		= 1;
 cpreproc	= 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 minres		= 60; % minutes - minimum resolution required for processing
 nhday 		= 2.0;  % hours - daytime interval (half-width)
 nhnig 		= 2.0;  % hours - nighttime interval (half-width)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 plotfig	= 0;
 closefig	= 0;
 savefig	= 0;
 saveout	= 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 load(name_logfile);

 indb=[];
 lprefix = length(prefix);
 for indc=1:logfile.nfiles
    if ~strncmp(logfile.names(indc),prefix,lprefix) | logfile.flag(indc)~=useflag
        indb = [indb indc];
    end
 end
 logfile.names(indb) 	= [];
 logfile.processed(indb) = [];
 logfile.flag(indb) 	= [];
 logfile.comment(indb) 	= [];
 logfile.date(indb) 	= [];
 logfile.nfiles = length(logfile.flag);

 ncruises = logfile.nfiles;

 extractionlog.name 	= {};
 extractionlog.success 	= [];

%for indc=1:ncruises
 for indc=144:ncruises

    disp(['-------------------------------------------------------']);
    disp(['Extracting DVM pattern in cruise ' num2str(indc) '/' num2str(ncruises) ' ... ' logfile.names{indc} ]);
    disp([logfile.comment{indc} ]);
    load([indir logfile.names{indc}]) 
    eval(['cruise = ' logfile.names{indc} ';']); 
    eval(['clear ' logfile.names{indc} ';']); 
    if cpreproc==1
       cruise = adcp_preprocess(cruise);
    end
    extractionlog.name{indc}    = logfile.names{indc};
    extractionlog.success(indc) = 0;

    cout = analyze_cruise(cruise,'flag',cflag,'blank',cblank,'preprocess',0, ...
                                 'minres',minres,'nhday',nhday,'nhnig',nhnig);

    if (1)
       % Adds the same calculation done with approximate backscatter to the one done for raw amplitude
       cout2 = analyze_cruise(cruise,'flag',cflag,'blank',cblank,'preprocess',0, ...
                                    'minres',minres,'nhday',nhday,'nhnig',nhnig,'var','bksc');
       cout.bkscday = cout2.bkscday;
       cout.bkscdiff = cout2.bkscdiff;
    end

    if saveout==1
       eval(['dvm_'  logfile.names{indc} ' = cout;']);
       eval(['save ' outdir  'dvm_'  logfile.names{indc} ' dvm_'  logfile.names{indc} ';'])
       end

    if plotfig==1
       adcp_dvm_depth(cruise,cout);
       drawnow
    end

    if savefig==1
       sfname = ['dvm_' logfile.names{indc}];
       mprint_fig('name',[outdir sfname],'sty','nor7')
    end

    if closefig==1
       close all
    end

    extractionlog.success(indc) = 1;

    eval(['save ' outdir  'extractionlog extractionlog;'])

 end
 

 

