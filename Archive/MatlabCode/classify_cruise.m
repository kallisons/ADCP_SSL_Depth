function logfile = classify_cruise(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots a dataset map in longitude-latitude space
% Usage:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% History:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default arguments:
A.wrkdir	= '/Users/danielebianchi/AOS/ZOOPLANKTON/ADCP/scripts/analysis/';
A.logname 	= 'logfile';
A.prefix	= ''; % Prefix for seletive loading cruise names
A.force 	= 0;
A.save		= 1; % (1) saves every change continuosly (0) don't save
% Parse required variables, substituting defaults where necessary
A = parse_pv_pairs(A, varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath /Users/danielebianchi/AOS/ZOOPLANKTON/ADCP/scripts

cd(A.wrkdir);

wrkdircontent 	= dir(A.wrkdir);
wrkdirfiles 		= {wrkdircontent.name};

clc

if any(strcmp(wrkdirfiles,[A.logname '.mat']))
   disp([' WARNING: loading ... ' A.wrkdir  A.logname '.mat']); 
   load([A.wrkdir A.logname '.mat']); 
else
   disp(['creating new logfile: ' A.wrkdir A.logname '.mat']);
   logfile.logname      = A.logname;
   logfile.names        = load_cruise_list('prefix',A.prefix);
   logfile.nfiles       = length(logfile.names);
   % Log file fields:
   logfile.processed    = zeros(logfile.nfiles,1);
   logfile.flag         = zeros(logfile.nfiles,1);
   logfile.comment      = repmat({''},size(logfile.names));
   logfile.date         = repmat({''},size(logfile.names));
end

 disp('Enter key to continue')
 pause

 % Available actions
 actions = lower({'f','c','r','n','x','p','m','s','q','h'});

 strflags{1} = 'Good dataset, no major problems - Use';
 strflags{2} = 'Good dataset, DVM signal is clear at surface but becomes too faint at depth - use with care';
 strflags{3} = 'Overall good but many gaps and care needed - Use with care';
 strflags{4} = 'Good, but surface only - Use surface';
 strflags{5} = 'Too many gaps, too noisy, hard to clean few event - Discard';
 strflags{6} = 'DVM signal too faint at depth, and too noisy or with gap make it hard to use - Discard';
 strflags{7} = 'Not good, unusable - Discard';

 % Existing comments
 ecomments = setdiff(unique(logfile.comment),{''});

 fform = 'nor2'; % default figure format

% Process each cruise that has not be processed
 for indn=1:logfile.nfiles
%for indn=1:5

    if logfile.processed(indn)==0 | A.force==1
       clc
       if logfile.processed(indn)==1
          disp(['Cruise ' logfile.names{indn} ' was processed on ' logfile.date{indn}]);
       end 

       % Loads the cruise
       disp(['Processing cruise ' logfile.names{indn}  ' ... # ' num2str(indn) '/' num2str(logfile.nfiles)]); 
       load(['/Users/danielebianchi/AOS/ZOOPLANKTON/ADCP/cruises/' logfile.names{indn} '.mat']);
       eval(['cruise = ' logfile.names{indn} ';']);
       cruise = adcp_preprocess(cruise);
       close all;
       fform = adcp_plot2(cruise);

       % Different actions
       taction = '';
       while ~any(strcmp(taction,'n'))
         %disp(['taction = ',taction]);
          while ~any(strcmp(taction,actions));
             taction  = input(['Input action ' [actions{:}] ' \n'],'s');
             if ~strcmp(taction,'');taction  = lower(taction(1));end
          end
          if ~strcmp(taction,'n')
             switch taction
             case 'f'
                tflag = ''; 
               %disp('resetting tflag')
                while ~any(strcmp(tflag,{'1','2','3','4','5','6','7','n'}));
                   % Adds a flag
                   tflag  = input(['Input flag (1-7, n to skip, l list flags) \n'],'s');
                   if ~strcmp(tflag,'');tflag  = tflag(1);end
                   if ~any(strcmp(tflag,{'l','n'})) & any(strcmp(tflag,{'1','2','3','4','5','6','7'}))
                  %disp(['tflag = ' tflag])
                      logfile.flag(indn) = str2num(tflag);
                      disp(['Flag for cruise ' cruise.name ' set to: ' tflag '  [' strflags{logfile.flag(indn)}  ']'])
                      logfile.processed(indn)=1;
                      logfile.date{indn}=datestr(clock,31);
                   elseif strcmp(tflag,'l')
                      disp('Flag options:');
                      for indsf=1:length(strflags)
                         disp(['(' num2str(indsf) ')  ' strflags{indsf}]);
                      end
                   end
                end
             case 'c'
                if ~isempty(logfile.comment{indn})
                   disp(['Existing comment for cruise # ' logfile.names{indn} ' : ']);
                   disp(logfile.comment{indn})
                end
                tcomment = input(['Input comment (0 to display existing) \n'],'s');
                if ~isempty(tcomment)
                   if strcmp(tcomment(1),'0')
                      disp(['Existing defined comments: ']);
                      for indc=1:length(ecomments)
                         disp(['(' num2str(indc) ') ' ecomments{indc}]);
                      end
                      tcomment = input(['Enter existing number or new comment \n'],'s');
                      if ~strcmp(tcomment,'');
                         tcomm  = str2num(tcomment);
                         if ~isempty(tcomm) 
                           %disp(['ecomment length ' num2str(length(ecomments))]);
                           %ecomments
                            if tcomm<=length(ecomments) & tcomm~=0
                               logfile.comment{indn} = ecomments{tcomm};
                            else 
                               disp(['Existing comment # ' tcomm ' not defined']);
                            end
                         else 
                            logfile.comment{indn} = tcomment;
                         end
                         ecomments = setdiff(unique([logfile.comment{indn};ecomments]),{''});
                         disp(['Comment fo cruise # ' logfile.names{indn} ' set to: ']);
                         disp(['--- ' logfile.comment{indn} ' ---']);
                      else
                         disp(['Skipping new comment fo cruise # ' logfile.names{indn}]);
                      end
                   else
                      logfile.comment{indn} = tcomment;
                      ecomments = setdiff(unique([logfile.comment{indn};ecomments]),{''});
                      disp(['Comment fo cruise # ' logfile.names{indn} ' set to: ']);
                      disp(['--- ' logfile.comment{indn} ' ---']);
                   end
                else
                   disp(['Skipping new comment fo cruise # ' logfile.names{indn}]);
                end
                tcomment = '';
             case 'r'
                fform = adcp_plot4(cruise);
             case 'n'
                % Moving to the next cruise 
             case 'x'
                disp(['Resetting log fields for cruise # ' logfile.names{indn}]);
                logfile.flag(indn) 	= 0;
                logfile.comment{indn} 	= '';
                logfile.processed(indn)	= 0;
                logfile.date{indn} 	= '';
             case 'p'
                fname = ['figure_' logfile.names{indn}];
                mprint_fig('name',fname,'for','jpeg','sty',fform);
             case 'm'
                disp(['Matching descriptors from previous cruise (' logfile.names{indn-1} ')']);
                if indn>1
                   logfile.flag(indn)      = logfile.flag(indn-1);
                   logfile.comment{indn}   = logfile.comment{indn-1}; 
                   logfile.processed(indn) = logfile.processed(indn-1);
                   logfile.date{indn}      = datestr(clock,31); 
                end
                disp(['flag : ' num2str(logfile.flag(indn)) '  [' strflags{logfile.flag(indn)}  ']']);
                disp(['comment : ' logfile.comment{indn}]);
             case 's'
                disp(['------------------------------------------------']);
                disp(['name : ' num2str(logfile.names{indn})]);
                disp(['processed : ' num2str(logfile.processed(indn))]);
                disp(['flag : ' num2str(logfile.flag(indn))]);
                disp(['comment : ' logfile.comment{indn}]);
                disp(['date : ' logfile.date{indn}]);
                disp(['------------------------------------------------']);
             case 'q'
                disp(['Saving and quitting']);
                eval(['save ' A.wrkdir logfile.logname '.mat logfile;']);
                return
             case 'h' 
                disp(['f : Flags the cruise']);
                disp(['c : adds a Comment to the cruise']);
                disp(['r : Replot with more panels/features']);
                disp(['n : skips/moves to Next cruise']);
                disp(['x : reset all fields for current cruise']);
                disp(['p : Prints figure as is']);
                disp(['m : Matches previous classification']);
                disp(['s : Shows current cruise classification']);
                disp(['q : Saves and Quits']);
                disp(['h : display this Help']);
             end
            %disp('resetting taction')
             taction = '';
          end
       end  
    end
    eval(['save ' A.wrkdir logfile.logname '.mat logfile;']);
 end



 

 
