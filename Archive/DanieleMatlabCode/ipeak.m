function P=ipeak(DataMatrix,PeakD,AmpT,SlopeT,SmoothW,FitW,xcenter,xrange,MaxError,positions,names)
% Version 3.8, Adds manual entry of AmpT after entering number of click
% points for background subtraction. Added '0' key: set minimin to zero.
% P=ipeak(DataMatrix,PeakD,AmpT,SlopeT,SmoothW,FitW,xcenter,xrange,MaxError,positions,names)
% P=ipeak(DataMatrix) where DataMatrix = x,y vectors or 2-column matrix, or ipeak(y)
% iPeak is a keyboard-operated Interactive Peak Finder for time series
% data, based on the "findpeaks.m" function. It accepts data in a single
% vector, a pair of vectors, or a matrix with the independent variable in
% the first column and the dependent variable in the second column:
%
% EXAMPLE 1:  Two input arguments; data in separate x and y vectors
%                >> x=[0:.1:100];y=(x.*sin(x)).^2;ipeak(x,y);
%
% EXAMPLE 2:  One input argument; data in two columns of a matrix
%                >> x=[0:.01:5]';y=x.*sin(x.^2).^2;M=[x y];ipeak(M);
%
% EXAMPLE 3:  One input argument; data in single vector
%                >> y=cos(.1:.1:100);ipeak(y)
%
% EXAMPLE 4:  Additional input argument (after the data) to control peak
% sensitivity.
%        >> x=[0:.1:100];y=5+5.*cos(x)+randn(size(x));ipeak(x,y,10);
%    or  >> ipeak([x;y],10); or  >> ipeak(humps(0:.01:2),3)
%    or  >> x=[0:.1:10];y=exp(-(x-5).^2);ipeak([x' y'],1)
%
% The additional argument is an estimate of the ratio of the typical peak
% width to the length of the entire data record (PeakD). Small values
% detect fewer peaks; larger values detect more peaks. It effects only the
% starting values for the peak detection parameters. (This is just a quick
% way to set reasonable initial values of the peak detection parameters,
% rather than specifying each one individually as in example 5.
%
% iPeak displays the entire signal in the lower half of the Figure window
% and an adjustable zoomed-in section in the upper window. (Press the Enter
% key to change the plot color.)  Adjust the peak detection parameters
% AmpThreshold (A/Z keys), SlopeThreshold (S/X), SmoothWidth (D/C),
% FitWidth (F/V) so that it detects the desired peaks and ignores those
% that are too small, too broad, or too narrow to be of interest. Detected
% peaks are numbered from left to right.  To detect valleys rather than 
% peaks, press "U" and adjust AmpT below the lowest valley. (U toggles 
% between peak and valley mode). Press P to display a table of detected
% peaks/valleys (#, Position, Height, Width).
%
% EXAMPLE 5: Six input arguments. As above, but input arguments 3 to 6
% directly specifies initial values of AmpThreshold (AmpT), SlopeThreshold
% (SlopeT), SmoothWidth (SmoothW), FitWidth (FitW) . PeakD is ignored in
% this case, so just type a '0' as the second argument after the data
% matrix).
%              >> x=[0:.01:5]';y=x.*sin(x.^2).^2;M=[x y];
%              >> ipeak(M,0,0,.0001,20,20);
%
% The cursor arrow kays allow you to pan and zoom the upper window,
% to inspect each peak in detail if desired.  You can set the initial
% values of pan andzoom in optional input arguments 7 ('xcenter') and 8
% ('xrange').  See example 6 below.
%
% The peak cloest to the center of the upper window is labeled in the upper
% left of the top window and it peak position, height, and width are
% listed. The Spacebar/Tab keys jump to the next/previous detected peak and
% displays it in the upper window at the current zoom setting (use the up
% and down cursor arrow keys to adjust the zoom range).  The Y key toggles
% between linear and log y-axis scale in the lower window (a log axis is
% good for inspecting signals with high dynamic range; it effects only the
% lower window display and has no effect on the peak detection or
% measurements).
%
% EXAMPLE 6: Eight input arguments. Line example 5, but input arguments 7
% and 8 specifiy the initial pan and zoom settings, 'xcenter' and 'xrange',
% respectively.  In this example, the x-axis data are wavelengths in
% nanometers (nm), and the upper window zooms in on a very small 0.4 nm
% region centered on 249.7 nm. (These data, provided in the ZIP file, are
% from a high-resolution atomic spectrum).
%
%         >> load ipeakdata.mat 
%         >> ipeak(Sample1,0,110,0.06,3,4,249.7,0.4);
%
% Autozero mode. The T key toggles the autozero mode off and on.  When
% autozero is OFF, peak heights are measured relative to zero.  (If the
% peaks are superimpored on a background, use the baseline subtract keys -
% B and G - first to subtract the background).  When autozero is ON, peak
% heights are automatically measured relative to the local baseline on
% either side of the peak; use the zoom controls to isolate the peaks so
% that the signal returns to the local baseline between the peaks as
% displayed in the upper window.  When autozero is ON, the peak heights,
% widths, and areas in the peak table (R or P keys) will be automatically
% corrected for the baseline.  (Autozero OFF will give better results when
% the baseline is zero, or has been subtracted using the B key, even if the
% peaks are partly overlapped. Autozero ON will work best if the peaks are
% well separated so that the signal returns to the local baseline between
% the peaks.  If the peaks are highly overlapped, or if they are not
% Gaussian in shape, the best results will be obtained by using the curve
% fitting function - the N or M keys). 
%
% EXAMPLE 7:  Nine input arguments. As example 6, but the 9th 
% input argument turns ON the autozero mode (equivalent to 
% pressing the T key). If not specified, autozero is initially OFF.
%
%        >> ipeak(Sample1,0,110,0.06,3,4,249.7,0.4,1);
%
% Normal and Multiple Curve fitting: The N key applies variable-shape
% iterative curve fittingto the detected peaks that are displayed in the
% upper window (referred to a "Normal" curve fitting).  If the peaks are
% superimposed on a background, turn on the Autozero mode (T key). Then use
% the pan and zoom keys to select a peak or a group of overlapping peaks in
% the upper window, with the signal returning all the way to the local
% baseline at the ends of the upper window.  Make sure that AmpThreshold,
% SlopeThreshold, SmoothWidth are adjusted so that each peak is numbered
% once.  Then press the N key, type a number for the desired peak shape at
% the prompt in the Command window and press Enter (1=Gaussian (default);
% 2=Lorentzian; 3=logistic, 4=Pearson; 5=exponentionally broadened
% Gaussian, 6=equal-width Gaussians; 7=Equal-width Lorentzians;
% 8=exponentionally broadened equal-width Gaussian), then type in a number
% of repeat trial fits and press Enter (the default is 1; start with that
% and then increase if necessary).  The program will perform the fit,
% display the results graphically in Figure window 2, and print out a table
% of results in the command window, e.g.:
%
% Peak shape (1-8): 2 
% Number of trials: 1
% Least-squares fit to Lorentzian peak model 
% Fitting Error 1.1581e-006%
%           Peak#     Position     Height      Width       Area
%             1          100         1          50        71.652 
%             2          350         1          100       146.13 
%             3          700         1          200       267.77
%
% The use of the iterative least-squares function can result in more
% accurate peak parameter measurements that the normal peak table (R or P
% keys), especially if the peaks are non-Gaussian in shape or are highly
% overlapped.
%
% There is also an experimental "Multiple" peak fit function (M key) that
% will attempt to apply non-linear iterative curve fitting to to all the
% detected peaks in the signal automatically.  Before using this function,
% use the baseline correction function first (B key) to remove the
% background signal.  Then press M and proceed as for the normal curve fit.
% With some signals, this function may not work as well as using the normal
% (N-key) curve fitting function on each group of peaks separately.  Note:
% The N and M key fitting functions perform non-linear iterative curve
% fitting using the peakfit.m function. The number of peaks and the
% starting values of peak positions and widths for the curve fit function
% are automatically supplied by the the findpeaks function, so it is
% essential that the peak detection variables in iPeak be adjust so that
% all the peaks in the selected ragion are detected and numbered once.
% (For more flexible curve fitting, use ipf.m).
%
% Peak identification. There is an optional "peak identification" function
% if optional input arguments 9 ('MaxError'), 10 ('Positions'), and 11
% ('Names') are included. The "i" key toggles this function ON and OFF.
% This function compares the found peak positions (maximum x-values) to a
% database of known peaks, in the form of an array of known peak maximum
% positions ('Positions') and matching cell array of names ('Names'). If
% the position of a found peak in the signal is closer to one of the known
% peaks by less than the specified maximun error ('MaxError'), then that
% peak is considered a match and its name is displayed next to the peak in
% the upper window. When when the 'o' key is pressed, the peak positions,
% names, errors, and amplitudes are printed out in a table in the command
% window.
%
% EXAMPLE 8: Eleven input arguments. As above, but also specifies
% 'MaxError', 'Positions', and 'Names' in optional input arguments 9, 10,
% and 11, for peak identification function. Pressing the 'I' key toggles
% off and on the peak identification labels in the upper window. Pressing
% "o" prints the peak positions, names, errors, and amplitudes in a table
% in the command window. These data (provided in the ZIP file) are from a
% high-resolution atomic spectrum (x-axis in nanometers).
%
%     >> load ipeakdata.mat
%     >> ipeak(Sample1,0,100,0.05,3,6,296,5,0.1,Positions,Names);
%
% Note: The ZIP file contains the latest version of the iPeak function as
% well as some sample data to demonstrate peak identification (Example 7).
% Obviously for your own applications, it's up to you to provide your own
% array of known peak maximum positions ('Positions') and matching cell
% array of names ('Names') for your particular types of signals.

% Keyboard Controls:
% Pan signal left and right...Coarse pan: < and >   
%                             Fine pan: left and right cursor arrow keys
% Zoom in and out.............Coarse zoom: / and '   
%                             Fine zoom: up and down cursor arrow keys
% Resets pan and zoom.........ESC
% Change plot color...........Enter
% Adjust AmpThreshold.........A,Z  (A increases, Z decreases)
% Adjust SlopeThreshold.......S,X  (S increases, X decreases)
% Adjust SmoothWidth..........D,C  (D increases, C decreases)
% Adjust FitWidth.............F,V  (F increases, Z decreases)
% Baseline correction:        B, enter # points, then click baseline 
% Restore original signal:    G  to cancel previous background subtraction
% Invert signal...............-  Invert (negate) the signal (flip + and -)
% Set minimum to zero.........0  (Zero) Sets minumun signal to zero 
% Toggle log y mode OFF/ON....Y  Plot log Y axis on lower graph  
% Toggle autozero OFF/ON......T  Auto background subtraction on upper graph
% Toggle valley mode OFF/ON...U  Switch to valley mode
% Print peak table............P  Prints Peak #, Position, Height, Width
% Step through peaks..........Space/Tab  Jumps to next/previous peak
% Normal peak fit.............N  Fit peaks in upper window with peakfit.m
% Multiple peak fit...........M  Fit all peaks in signal with peakfit.m
% Print keyboard commands.....K  Prints this list
% Print findpeaks arguments...Q  Prints findpeaks function with arguments.
% Print ipeak arguments.......W  Prints ipeak function with all arguments.
% Print report................R  Prints Peak table and parameters
% Peak labels ON/OFF......... L  Displays peak parameters in upper window.
% Peak ID ON/OFF..............I  Identifies closest peaks in 'Names' database.
% Print peak IDs..............O  Prints table of peaks IDs

global X Y xo dx SlopeThreshold AmpThreshold SmoothWidth FitWidth AUTOZERO valleymode
global PeakLabels PeakID Names Positions maxerror logplot plotcolor P showpeak

format short g
format compact
warning off all
switch nargin
    % 'nargin' is the number of arguments
    case 1  % One argument only
      % Assumne that the argument must be a matrix of data.
      % If DataMatrix is in the wrong transposition, fix it.
      datasize=size(DataMatrix);
      if datasize(1)<datasize(2),DataMatrix=DataMatrix';end
      datasize=size(DataMatrix);
      if datasize(2)==1, %  Must be ipeak(Y-vector)
         X=[1:length(DataMatrix)]'; % Create an independent variable vector
         Y=DataMatrix;
      else
         % Must be ipeak(DataMatrix)
         X=DataMatrix(:,1); % Split matrix argument 
         Y=DataMatrix(:,2);
      end
      % Calculate default values of peak detection parameters
      PeakDensity=20;   
      % Estimate approx number of points in a peak half-width
      WidthPoints=length(Y)/PeakDensity;  
      SlopeThreshold=WidthPoints^-2;  
      AmpThreshold=abs(min(Y)+0.1*(max(Y)-min(Y))); 
      SmoothWidth=round(WidthPoints/3);  
      FitWidth=round(WidthPoints/3);
      if FitWidth>100,FitWidth=100;end   % Keep FitWidth below 100
      if SmoothWidth>100,SmoothWidth=100;end   % Keep SmoothWidth below 100
      xo=length(Y)/2; % Initial Pan setting
      dx=length(Y)/4; % Initial Zoom setting
      AUTOZERO=0;
    case 2
      % Two arguments; might be separate x and y data vectors, 
      % data matrix + number, or y vector + number (peak density estimate)
      if isscalar(PeakD)
         % Must be one data matrix and a peak density estimate.
         % If DataMatrix is in the wrong transposition, fix it.
          datasize=size(DataMatrix);
         if datasize(1)<datasize(2),DataMatrix=DataMatrix';end
         datasize=size(DataMatrix);
         if datasize(2)==1, %  Must be ipeak(Y-vector)
            X=[1:length(DataMatrix)]'; % Create an independent variable vector
            Y=DataMatrix;
         else
            % Must be ipeak(DataMatrix)
            X=DataMatrix(:,1); % Split matrix argument 
            Y=DataMatrix(:,2);
         end
         % Calculate values of peak detection parameters
         % arguments based on the peak density, PeakD
         PeakDensity=PeakD;    
         % Estimate approx number of points in a peak half-width
         WidthPoints=length(Y)/PeakDensity;  
         SlopeThreshold=WidthPoints^-2;  
         AmpThreshold=abs(min(Y)+0.1*(max(Y)-min(Y)));  
         SmoothWidth=round(WidthPoints/3);  
         FitWidth=round(WidthPoints/3);
         if FitWidth>100,FitWidth=100;end   % Keep FitWidth below 100
         if SmoothWidth>100,SmoothWidth=100;end   % Keep SmoothWidth below      xo=length(Y)/2; % Initial Pan setting
         xo=length(Y)/2; % Initial Pan setting
         dx=length(Y)/4; % Initial Zoom setting
         AUTOZERO=0;
      else % if not isscalar
        % Must be separate x and y data vectors
        X=DataMatrix;
        Y=PeakD;
        PeakDensity=20;   
        % Estimate approx number of points in a peak half-width
        WidthPoints=length(Y)/PeakDensity;  
        SlopeThreshold=WidthPoints^-2;  
        AmpThreshold=abs(min(Y)+0.1*(max(Y)-min(Y))); 
        SmoothWidth=round(WidthPoints/3);  
        FitWidth=round(WidthPoints/3); 
        if FitWidth>100,FitWidth=100;end   % Keep FitWidth below 100
        if SmoothWidth>100,SmoothWidth=100;end   % Keep SmoothWidth below 100
        xo=length(Y)/2; % Initial Pan setting
        dx=length(Y)/4; % Initial Zoom setting
      end  % if isscalar
      AUTOZERO=0;
    case 3
      % Must be separate x and y data vectors plus a peak density estimate. 
      X=DataMatrix;
      Y=PeakD;
      % Calculate values of peak detection parameters
      % arguments based on the peak density, PeakD
      PeakDensity=AmpT;    
      % Estimate approx number of points in a peak half-width
      WidthPoints=length(Y)/PeakDensity;  
      SlopeThreshold=WidthPoints^-2;  
      AmpThreshold=abs(min(Y)+0.02*(max(Y)-min(Y)));  
      SmoothWidth=round(WidthPoints/3);  
      FitWidth=round(WidthPoints/3); 
      if FitWidth>100,FitWidth=100;end   % Keep FitWidth below 100
      if SmoothWidth>100,SmoothWidth=100;end   % Keep SmoothWidth below 100
      xo=length(Y)/2; % Initial Pan setting
      dx=length(Y)/4; % Initial Zoom setting
      AUTOZERO=0;
    case 6 
      % Must be one data matrix and all peak detection parameters 
      % specified in arguments 
      % If DataMatrix is in the wrong transposition, fix it.
      datasize=size(DataMatrix);
      if datasize(1)<datasize(2),DataMatrix=DataMatrix';end
      X=DataMatrix(:,1); % Split matrix argument 
      Y=DataMatrix(:,2);
      SlopeThreshold=SlopeT;
      AmpThreshold=AmpT;
      SmoothWidth=SmoothW;
      FitWidth=FitW;
      xo=length(Y)/2; % Initial Pan setting
      dx=length(Y)/4; % Initial Zoom setting
      AUTOZERO=0;
    case 8
      % One data matrix, all peak detection parameters specified
      % in arguments, initial values of xcenter and xrange specified.
      % If DataMatrix is in the wrong transposition, fix it.
      datasize=size(DataMatrix);
      if datasize(1)<datasize(2),DataMatrix=DataMatrix';end
      X=DataMatrix(:,1); % Split matrix argument 
      Y=DataMatrix(:,2);
      SlopeThreshold=SlopeT;
      AmpThreshold=AmpT;
      SmoothWidth=SmoothW;
      FitWidth=FitW;
      if xcenter<min(X),
          disp(['Lowest X value is ' num2str(min(X)) ]),
          xcenter=min(X)+xrange;
      end
      if xcenter>max(X),
          disp(['Highest X value is ' num2str(max(X)) ]),
          xcenter=max(X)-xrange;
      end
      xo=val2ind(X,xcenter);
      hirange=val2ind(X,xcenter+xrange./2);
      lorange=val2ind(X,xcenter-xrange./2);
      dx=(hirange-lorange);
      AUTOZERO=0;
    case 9
      % Like case 9, except initial AUTOZERO mode is specified
      % in arguments, initial values of xcenter and xrange specified.
      % If DataMatrix is in the wrong transposition, fix it.
      datasize=size(DataMatrix);
      if datasize(1)<datasize(2),DataMatrix=DataMatrix';end
      X=DataMatrix(:,1); % Split matrix argument 
      Y=DataMatrix(:,2);
      SlopeThreshold=SlopeT;
      AmpThreshold=AmpT;
      SmoothWidth=SmoothW;
      FitWidth=FitW;
      xo=val2ind(X,xcenter);
      hirange=val2ind(X,xcenter+xrange./2);
      lorange=val2ind(X,xcenter-xrange./2);
      dx=(hirange-lorange);
      if xcenter<min(X),
          disp(['Lowest X value is ' num2str(min(X)) ]),
          xcenter=min(X)+xrange;
      end
      if xcenter>max(X),
          disp(['Highest X value is ' num2str(max(X)) ]),
          xcenter=max(X)-xrange;
      end
      AUTOZERO=MaxError;
    case 11 % last 3 options arguments provided
      datasize=size(DataMatrix);
      if datasize(1)<datasize(2),DataMatrix=DataMatrix';end
      X=DataMatrix(:,1); % Split matrix argument 
      Y=DataMatrix(:,2);
      SlopeThreshold=SlopeT;
      AmpThreshold=AmpT;
      SmoothWidth=SmoothW;
      FitWidth=FitW;
      xo=val2ind(X,xcenter);
      hirange=val2ind(X,xcenter+xrange./2);
      lorange=val2ind(X,xcenter-xrange./2);
      dx=(hirange-lorange);
      if xcenter<min(X),
          disp(['Lowest X value is ' num2str(min(X)) ]),
          xcenter=min(X)+xrange;
      end
      if xcenter>max(X),
          disp(['Highest X value is ' num2str(max(X)) ]),
          xcenter=max(X)-xrange;
      end
        maxerror=MaxError;
        Positions=positions;
        Names=names;
        AUTOZERO=0;
    otherwise
      disp('Invalid number of arguments')
      disp('Expected forms are:')
      disp('ipeak(y);  % Data in single y vector')
      disp('ipeak(x,y);  % Data in separate x and y vectors')
      disp('ipeak(DataMatrix); % Data in two columns of DataMatrix')
      disp('ipeak(x,y,10), ipeak([x;y],10) or ipeak(y,10), specifying peak density')
      disp('ipeak(DataMatrix,0,.5,.0001,33,33);  specifying peak density, AmpT, SlopeT, SmoothW, FitW')
      disp('ipeak(DataMatrix,PeakD,AmpT,SlopeT,SmoothW,FitW,xcenter,xrange)')
      disp('ipeak(DataMatrix,PeakD,AmpT,SlopeT,SmoothW,FitW,xcenter,xrange,MaxError,positions,names)')
      beep
      return
end % switch nargin
% If necessary, flip the data vectors so that X increases
if X(1)>X(length(X)),
    disp('X-axis flipped.')
    X=fliplr(X);
    Y=fliplr(Y);
end
if FitWidth<3,FitWidth=3;end   % Keep FitWidth above 2 
PeakLabels=0; % Peak numbers only, no parameter labels, in upper window
PeakID=0; % Start with PeakID off
logplot=0; % Start with linear mode
plotcolor=0;  % Start with blue plot color
showpeak=1;  % Start with first peak under green cursor
valleymode=0;
P=[0 0 0 0 0];
% Plot the signal
P=findpeaks(X,Y,SlopeThreshold,AmpThreshold,SmoothWidth,FitWidth);
[xx,yy]=RedrawSignal(X,Y,xo,dx);
% Attaches KeyPress test function to the figure.
set(gcf,'KeyPressFcn',@ReadKey)
uicontrol('Style','text')
% end of outer function
% ----------------------------SUBFUNCTIONS--------------------------------
function ReadKey(obj,eventdata)
% Interprets key presses from the Figure window. When a key is pressed, 
% executes the code in the corresponding section in the SWITCH statement.
% Note: If you don't like my key assignments, you can change the numbers
% in the case statements here to re-assign that function to any other key.
% If you press a key that has not yet been assigned to a function, it
% displays the key code number in the command window so you can easily
% add that to the SWITCH statement to add your own custom functions.
global X Y xx yy xo dx SlopeThreshold AmpThreshold SmoothWidth FitWidth plotcolor
global PeakLabels PeakID Names Positions maxerror SavedSignal oldAmpThreshold
global logplot P AUTOZERO showpeak valleymode
key=get(gcf,'CurrentCharacter');
if isscalar(key),
  ly=length(Y);
  switch double(key),
    case 29
        % Pans down when left arrow pressed.
        xo=xo+dx/10;
        if xo>ly,xo=ly;end
        [xx,yy]=RedrawSignal(X,Y,xo,dx);
    case 28
        % Pans up when right arrow pressed. 
         xo=xo-dx/10;
         if xo<1,xo=1;end
         [xx,yy]=RedrawSignal(X,Y,xo,dx);
    case 91
        % Nudge down 1 point when [ pressed.
         xo=xo-1;
         if xo<1,xo=1;end
         [xx,yy]=RedrawSignal(X,Y,xo,dx); 
    case 93
        % Nudge up 1 point when ] pressed.    
        xo=xo+1;
        if xo>ly,xo=ly;end
        [xx,yy]=RedrawSignal(X,Y,xo,dx);
    case 46
        % Pans down when < key pressed.
        xo=xo+dx/2;
        if xo>ly,xo=ly;end
        [xx,yy]=RedrawSignal(X,Y,xo,dx);
    case 44
        % Pans up when > key pressed.
        xo=xo-dx/2;
        if xo<1,xo=1;end
        [xx,yy]=RedrawSignal(X,Y,xo,dx);
    case 31
        % Zooms out when up arrow pressed.
        dx=dx+dx/10;
        [xx,yy]=RedrawSignal(X,Y,xo,dx);
    case 30
        % Zooms in when down arrow pressed.
        dx=dx-dx/10;
        if dx<2,dx=2;end
        [xx,yy]=RedrawSignal(X,Y,xo,dx);
    case 47
        % Zooms out when / pressed.
        dx=dx+ly/50;
        [xx,yy]=RedrawSignal(X,Y,xo,dx);
    case 39
        % Zooms in when ' pressed.
        dx=dx-ly/50;
        if dx<2,dx=2;end
        [xx,yy]=RedrawSignal(X,Y,xo,dx);      
     case 27 % When 'ESC' key is pressed, resets pan and zoom
         xo=length(Y)/2; % Initial Pan setting
         dx=length(Y)/4; % Initial Zoom setting
         [xx,yy]=RedrawSignal(X,Y,xo,dx);
     case 13     % Change plot color when Return key pressed
         plotcolor=plotcolor+1;
         if plotcolor==6, plotcolor=0;end
         [xx,yy]=RedrawSignal(X,Y,xo,dx);
     case 98
        % When 'b' key is pressed, user clicks graph 
        % to enter background points, then graph re-drawn.
        SavedSignal=Y;
        oldAmpThreshold=AmpThreshold;
        BaselinePoints=input('Number of baseline points to click: ');
        if isempty(BaselinePoints),BaselinePoints=8;end
        AmpThreshold=input('Amplitude Threshold: ');
        if isempty(AmpThreshold),AmpThreshold=oldAmpThreshold;end
        % Acquire background points from user mouse clicks
        subplot(2,1,2)
        title(['Click on ' num2str(BaselinePoints) ' points on the baseline between the peaks.'])
        bX=[];bY=[];
        for g=1:BaselinePoints;
           [clickX,clickY] = ginput(1);
           bX(g)=clickX;
           bY(g)=clickY;
           xlabel(['Baseline point '  num2str(g) ' / ' num2str(BaselinePoints) ])
        end
        yy=Y;
        for k=1:length(bX)-1,
           fp=val2ind(X,bX(k)); % First point in segment
           lp=val2ind(X,bX(k+1));  % Last point in segment
           % Subtract piecewise linear background from Y
           yy(fp:lp)=Y(fp:lp)-((bY(k+1)-bY(k))/(bX(k+1)-bX(k))*(X(fp:lp)-bX(k))+bY(k));
        end
        Y=yy;
        [xx,yy]=RedrawSignal(X,Y,xo,dx);  
    case 103
          % When 'g' key is pressed, restores signal background and AmpThreshold. 
          Y=SavedSignal;
          AmpThreshold=oldAmpThreshold;
          [xx,yy]=RedrawSignal(X,Y,xo,dx);
    case 97
        % When 'a' key is pressed, increases "AmpThreshold" by 10%
        AmpThreshold=AmpThreshold+.1*AmpThreshold;
        [xx,yy]=RedrawSignal(X,Y,xo,dx);      
    case 122
        % When 'z' key is pressed, decreases "AmpThreshold" by 10%
        AmpThreshold=AmpThreshold-.1*AmpThreshold;
        [xx,yy]=RedrawSignal(X,Y,xo,dx);      
    case 115 % When 's' key is pressed, increases "SlopeThreshold" by 10%
         SlopeThreshold=SlopeThreshold+.1*SlopeThreshold;
        [xx,yy]=RedrawSignal(X,Y,xo,dx);   
    case 120 % When 'x' key is pressed, decreases "SlopeThreshold" by 10%
         SlopeThreshold=SlopeThreshold-.1*SlopeThreshold;
        [xx,yy]=RedrawSignal(X,Y,xo,dx);   
    case 100
        % When 'd' key is pressed, increases "SmoothWidth" by 1 or 10%
        if SmoothWidth>20,
            SmoothWidth=round(SmoothWidth+.1.*SmoothWidth);
        else
            SmoothWidth=SmoothWidth+1;
        end
        [xx,yy]=RedrawSignal(X,Y,xo,dx);   
    case 99
        % When 'c' key is pressed, decreases "SmoothWidth" by 1 or 10%
        if SmoothWidth>20,
            SmoothWidth=round(SmoothWidth-.1.*SmoothWidth);
        else
            SmoothWidth=SmoothWidth-1;
        end
        if SmoothWidth<1, SmoothWidth=1;end
        [xx,yy]=RedrawSignal(X,Y,xo,dx);   
    case 102
        % When 'f' key is pressed, increases "FitWidth" by 1 or 10%
        if FitWidth>20,
            FitWidth=round(FitWidth+.1.*FitWidth);
        else
            FitWidth=FitWidth+1;
        end
        [xx,yy]=RedrawSignal(X,Y,xo,dx);   
    case 118
        % When 'v' key is pressed, decreases "FitWidth" by 1 or 10%
        if FitWidth>20,
            FitWidth=round(FitWidth-.1.*FitWidth);
        else
            FitWidth=FitWidth-1;
        end
         if FitWidth<3, FitWidth=3;end
        [xx,yy]=RedrawSignal(X,Y,xo,dx); 
    case 45
         % When '-' key is pressed, invert the signal
          Y=-Y;
          [xx,yy]=RedrawSignal(X,Y,xo,dx); 
          disp('Signal was inverted.')
    case 48
    % When '0' (zero) key is pressed, subtracts minimum from entire signal
    % (to remove positive or negative offset).
          Y=Y-min(Y);
          [xx,yy]=RedrawSignal(X,Y,xo,dx); 
          disp('Mininum signal set to zero.')
    case 114
        % When 'r' key is pressed, prints a report listing current 
        % settings and peak table.
        disp('--------------------------------------------------------')
        disp(['Amplitude Threshold (AmpT) = ' num2str(AmpThreshold) ] )
        disp(['Slope Threshold (SlopeT) = ' num2str(SlopeThreshold) ] )
        disp(['Smooth Width (SmoothW) = ' num2str(SmoothWidth) ' points' ] )
        disp(['Fit Width (FitW) = ' num2str(FitWidth) ' points' ] )
        sizeP=size(P);
        NumPeaks=sizeP(1);
        window=max(xx)-min(xx);
        if AUTOZERO,
            disp('Autozero ON')
            disp([ 'Window span: ' num2str(window) ]);
        else
            disp('Autozero OFF')
        end
          if valleymode,
              disp('        Valley#     Position     Height      Width          Area')
          else
              disp('          Peak#     Position     Height      Width          Area')
          end
        PP=MeasurePeaks(NumPeaks,X,Y,P,dx,SmoothWidth,FitWidth,AUTOZERO,valleymode);
        disp(PP)
     case 112
          % When 'p' key is pressed, prints out peak table
          disp('--------------------------------------------------------')
          sizeP=size(P);
          NumPeaks=sizeP(1);
          window=max(xx)-min(xx);
          if AUTOZERO,
              disp('Autozero ON')
              disp([ 'Window span: ' num2str(window) ' units'])
          else
              disp('Autozero OFF')
          end
          if valleymode,
              disp('        Valley#     Position     Height      Width          Area')
          else
              disp('          Peak#     Position     Height      Width          Area')
          end
          PP=MeasurePeaks(NumPeaks,X,Y,P,dx,SmoothWidth,FitWidth,AUTOZERO,valleymode);
          disp(PP)
    case 107
        % When 'k' key is pressed, prints out table of keyboard commands
        disp('KEYBOARD CONTROLS:')
        disp(' Pan left and right..........Coarse pan: < and >')   
        disp('                             Fine pan: left and right cursor arrows')
        disp('                             Nudge: [ ] ')
        disp(' Zoom in and out.............Coarse zoom: / and "  ') 
        disp('                             Fine zoom: up and down cursor arrows')
        disp(' Resets pan and zoom.........ESC')
        disp(' Change plot color...........Enter  (cycles through standard colors)')
        disp(' Adjust AmpThreshold.........A,Z (Larger values ignore short peaks)')
        disp(' Adjust SlopeThreshold.......S,X (Larger values ignore broad peaks)')
        disp(' Adjust SmoothWidth..........D,C (Larger values ignore sharp peaks}')
        disp(' Adjust FitWidth.............F,V (Adjust to cover just top part of peaks')
        disp(' Baseline correction:        B, enter # points, then click baseline ')
        disp(' Restore original signal.....G  to cancel previous background subtraction')
        disp(' Invert signal...............-  Invert (negate) the signal (flip + and -)')
        disp(' Set minimum to zero.........0  (Zero) Sets minumun signal to zero') 
        disp(' Toggle log y mode OFF/ON....Y  Plot log Y axis on lower graph')        
        disp(' Toggle autozero OFF/ON......T  Auto background subtraction on upper graph')  
        disp(' Toggle valley mode OFF/ON...U  Switch to valley mode')          
        disp(' Print report................R  prints Peak table and parameters')        
        disp(' Step through peaks..........Space/Tab  Jumps to next/previous peak')
        disp(' Print peak table............P  Peak #, Position, Height, Width, Area')
        disp(' Normal peak fit.............N  Fit peaks in upper window with peakfit.m')
        disp(' Multiple peak fit...........M  Fit all peaks in signal with peakfit.m')
        disp(' Print keyboard commands.....K  prints this list')
        disp(' Print findpeaks arguments...Q  prints findpeaks function with arguments')
        disp(' Print ipeak arguments.......W  prints ipeak function with all arguments')    
        disp(' Peak labels ON/OFF..........L  displays peak parameters on upper graph')
        disp(' Peak ID ON/OFF..............I  Identifies closest peaks in Names database.')
        disp(' Print table of peak IDs.....O  Prints Name, Position, Error, Amplitude')
    case 113
        % When 'Q' is pressed, prints findpeaks function with arguments    
        disp(['findpeaks(x,y,'  num2str(SlopeThreshold) ',' num2str(AmpThreshold)  ',' num2str(SmoothWidth)  ',' num2str(FitWidth) ')'] )
    case 119
        % When 'W' is pressed, prints ipeak function with arguments   
          center=(max(xx)+min(xx))/2;
          window=max(xx)-min(xx); 
        disp(['ipeak(DataMatrix,0,'  num2str(AmpThreshold) ',' num2str(SlopeThreshold)  ',' num2str(SmoothWidth)  ',' num2str(FitWidth) ',' num2str(center) ',' num2str(window) ')'] )
    case 105
        % When 'I' is pressed, toggles on/off PeakID in upper panel
        if PeakID==0,
            PeakID=1;
            % load DataTable
            % disp([ 'Loaded "DataTable" from disk. Number of Names:' num2str(length(Positions)) ] )
            % disp(['Position range: ' num2str(min(Positions)) '-' num2str(max(Positions)) ] )
        else
            PeakID=0;
        end
        [xx,yy]=RedrawSignal(X,Y,xo,dx); 
    case 108
         % When 'L' is pressed, toggles on/off peak labels in upper panel
        if PeakLabels==0,
            PeakLabels=1;
        else
            PeakLabels=0;
        end
        [xx,yy]=RedrawSignal(X,Y,xo,dx); 
    case 121
         % When 'Y' is pressed, toggles on/off log plot mode
        if logplot==0,
            logplot=1;
        else
            logplot=0;
        end
        [xx,yy]=RedrawSignal(X,Y,xo,dx); 
     case 117
         % When 'U' is pressed, toggles valleymode on/off 
        if valleymode==0,
            valleymode=1;
        else
            valleymode=0;
        end
        [xx,yy]=RedrawSignal(X,Y,xo,dx); 
    case 111
          % When 'o' is pressed, prints table of identified peaks
          if PeakID,
              disp('      Name          Position      Error         Amplitude')  %  Print out column lables for table
              for n=1:length(P(:,2)),
                  % m=index of the cloest match in Positions
                  m=val2ind(Positions,P(n,2));
                  % Error=difference between detected peak and nearest
                  % peak in table
                  Error=abs(P(n,2)-Positions(m));
                  if Error<maxerror, % Only identify the peaks if the error is less than MaxError
                      disp([Names(m) Positions(m) Error P(n,3)]); % Print out one line of Positions and Errors table
                  end % if error
              end  % for n
          end  % if PeakID

    case 110
         % When 'N' is pressed, applies peakfit function only to peaks in
         % the upper window (up to 6 peaks).
         % [xx,yy]=RedrawSignal(X,Y,xo,dx); 
         sizeP=size(P);
         NumPeaksUW=sizeP(1);
         if NumPeaksUW>1,
             PUW=[]; % PUW=table of peaks in upper window
             for peak=1:NumPeaksUW, % NumPeaksUW=number of peaks in upper window
                 if P(peak,2)>min(xx),
                     if P(peak,2)<max(xx),
                         PUW=[PUW;P(peak,:)];
                     end %  if P(peak,2)<max(xx),
                 end %  if P(peak,2)>min(xx),
             end % for peak=1:length(P),
         else
             PUW=P;
         end
          sizePUW=size(PUW);
          NumPeaksUW=sizePUW(1);
          center=(max(xx)+min(xx))/2;
          window=max(xx)-min(xx); 
          extra=1;
          disp('1=Gaussian (default), 2=Lorentzian, 3=logistic, 4=Pearson'); 
          disp('5=exponentionally broadened Gaussian, 6=equal-width Gaussians');
          disp('7=Equal-width Lorentzians, 8=exponentionally broadened equal-width Gaussian');
          Shape=input('Peak shape (1-8): ');
          if isempty(Shape),Shape=1;end
          NumTrials=input('Number of trials: ');
          if isempty(NumTrials),NumTrials=1;end
          if Shape==4||Shape==5||Shape==8,
             extra=input('Extra parameter: ');
          end % if Shape==4||Shape==5||Shape==8,
          if NumTrials>1,disp(['Best of ' num2str(NumTrials) ' trial fits.' ]), end       
          switch NumPeaksUW
            case 1
              startvector=[PUW(1,2) PUW(1,4)];
            case 2
              startvector=[PUW(1,2) PUW(1,4) PUW(2,2) PUW(2,4)];    
            case 3
              startvector=[PUW(1,2) PUW(1,4) PUW(2,2) PUW(2,4) PUW(3,2) PUW(3,4)];    
            case 4
              startvector=[PUW(1,2) PUW(1,4) PUW(2,2) PUW(2,4) PUW(3,2) PUW(3,4) PUW(4,2) PUW(4,4)];
            case 5
              startvector=[PUW(1,2) PUW(1,4) PUW(2,2) PUW(2,4) PUW(3,2) PUW(3,4) PUW(4,2) PUW(4,4) PUW(5,2) PUW(5,4)];        
            case 6
              startvector=[PUW(1,2) PUW(1,4) PUW(2,2) PUW(2,4) PUW(3,2) PUW(3,4) PUW(4,2) PUW(4,4) PUW(5,2) PUW(5,4) PUW(6,2) PUW(6,4)];        
          end % switch NumPeaksUW
          [FitResults,MeanFitError]=peakfit([xx,yy],center,window,NumPeaksUW,Shape,extra,NumTrials,startvector,AUTOZERO);
          switch Shape
              case 1
                  ShapeString='Gaussian';
              case 2
                  ShapeString='Lorentzian';
              case 3
                  ShapeString='logistic';
              case 4
                  ShapeString='Pearson7';
              case 5
                  ShapeString='ExpGaussian';
              case 6
                  ShapeString='Equal width Gaussians';
              case 7
                  ShapeString='Equal width Lorentzians';
              case 8
                  ShapeString='Equal-width ExpGauss.';
              otherwise
                  ShapeString='';
          end % switch Shape
        disp(['Least-squares fit to ' ShapeString ' peak model' ])
          disp(['Fitting Error ' num2str(MeanFitError) '%'])
        disp('          Peak#     Position     Height      Width         Area  ') 
        for peak=1:NumPeaksUW,FitResults(peak,1)=PUW(peak,1);end
        disp(FitResults(:,1:5))
     case 116
        % When 't' key is pressed, toggles AUTOZERO mode
        if AUTOZERO,
           AUTOZERO=0;
           [xx,yy]=RedrawSignal(X,Y,xo,dx); 
        else
           AUTOZERO=1;
           [xx,yy]=RedrawSignal(X,Y,xo,dx); 
        end
      case 101
          % When 'e' is pressed,
          disp('-------------------------------------------------------------')
    case 109
        % When 'M' is pressed, applies peakfit function to all peaks
        AllFitResults=[];
        [xx,yy]=RedrawSignal(X,Y,xo,dx);
        sizeP=size(P);
        NumPeaks=sizeP(1);
        if NumPeaks>2,
            center=(max(xx)+min(xx))/2;
            window=max(xx)-min(xx);
            extra=1;
            disp('1=Gaussian (default), 2=Lorentzian, 3=logistic, 4=Pearson');
            disp('5=exponentionally broadened Gaussian, 6=equal-width Gaussians');
            disp('7=Equal-width Lorentzians, 8=exponentionally broadened equal-width Gaussian');
            Shape=input('Peak shape (1-8): ');
            if isempty(Shape),Shape=1;end
            NumTrials=input('Number of trials (1-100): ');
            if isempty(NumTrials),NumTrials=1;end
            if Shape==4||Shape==5||Shape==8,
                extra=input('Extra parameter: ');
            end
            switch Shape
                case 1
                    ShapeString='Gaussian';
                case 2
                    ShapeString='Lorentzian';
                case 3
                    ShapeString='logistic';
                case 4
                    ShapeString='Pearson7';
                case 5
                    ShapeString='ExpGaussian';
                case 6
                    ShapeString='Equal width Gaussians';
                case 7
                    ShapeString='Equal width Lorentzians';
                case 8
                    ShapeString='Equal-width ExpGauss.';
                otherwise
                    ShapeString='';
            end % switch Shape
            disp(['Multiple Least-squares fit to ' ShapeString ' peak model' ]);
            disp('          Peak#     Position     Height      Width         Area          Error')
            for peak=1:NumPeaks-1,
                center=P(peak,2);
                window=8*P(peak,4);
                xo=val2ind(X,center);
      hirange=val2ind(X,xcenter+xrange./2);
      lorange=val2ind(X,xcenter-xrange./2);
                dx=(hirange-lorange);
                [xx,yy]=RedrawSignal(X,Y,xo,dx);
                PP=findpeaks(xx,yy,SlopeThreshold,AmpThreshold,SmoothWidth,FitWidth);
                sizeP=size(PP);
                NumPeaksUW=sizeP(1);% Number of peaks in Upper Window
                switch NumPeaksUW
                    case 1
                        startvector=[PP(1,2) PP(1,4)];
                    case 2
                        startvector=[PP(1,2) PP(1,4) PP(2,2) PP(2,4)];
                    case 3
                        startvector=[PP(1,2) PP(1,4) PP(2,2) PP(2,4) PP(3,2) PP(3,4)];
                    case 4
                        startvector=[PP(1,2) PP(1,4) PP(2,2) PP(2,4) PP(3,2) PP(3,4) PP(4,2) PP(4,4)];
                    case 5
                        startvector=[PP(1,2) PP(1,4) PP(2,2) PP(2,4) PP(3,2) PP(3,4) PP(4,2) PP(4,4) PP(5,2) PP(5,4)];
                    case 6
                        startvector=[PP(1,2) PP(1,4) PP(2,2) PP(2,4) PP(3,2) PP(3,4) PP(4,2) PP(4,4) PP(5,2) PP(5,4) PP(6,2) PP(6,4)];
                end % switch NumPeaksUW
                
                [FitResults,MeanFitError]=peakfit([xx,yy],center,window,NumPeaksUW,Shape,extra,NumTrials,startvector,0);
                % for peak=1:NumPeaks,FitResults(peak,1)=PUW(peak,1);end
                for fittrial=1:NumPeaksUW,  % Number of peaks in Upper Window
                    AllFitResults=[AllFitResults;[val2ind(P(:,2),FitResults(fittrial,2)) FitResults(fittrial,2:5) MeanFitError]];
                end % for fittrial
            end % peak=1:NumPeaks-1,
            % Select the best for for each peak
            SortedResults=sortrows(AllFitResults,2); % Sort AllFitResults by position (column 2)
            SizeAllFitResults=size(AllFitResults);
            NumFits=SizeAllFitResults(1);
            BestFits=[];
            for FitNumber=1:NumPeaks,
                FirstColumn=min(val2ind(SortedResults(:,1),FitNumber));
                LastColumn=max(val2ind(SortedResults(:,1),FitNumber));
                SelectedSection=SortedResults(FirstColumn:LastColumn,:);
                SortedSection=sortrows(SelectedSection,6);
                BestRow=SortedSection(1,:);
                BestFits=[BestFits;BestRow];
            end
            disp(BestFits)
        else disp('Too few peaks detected; use the Normal curve fit instead.')
        end % if  NumPeaks>2,
      case 32
          % When Spacebar is pressed, jumps to next peak
          if valleymode,
              P=findvalleys(X,Y,SlopeThreshold,AmpThreshold,SmoothWidth,FitWidth);
          else
              P=findpeaks(X,Y,SlopeThreshold,AmpThreshold,SmoothWidth,FitWidth);
          end
          sizeP=size(P);
          NumPeaks=sizeP(1);
          showpeak=showpeak+1;
          if showpeak>NumPeaks,showpeak=1;end
          center=P(showpeak,2);
          xo=val2ind(X,center);
          [xx,yy]=RedrawSignal(X,Y,xo,dx);
      case 9
          % When Tab is pressed, jumps to previous peak
          if valleymode,
              P=findvalleys(X,Y,SlopeThreshold,AmpThreshold,SmoothWidth,FitWidth);
          else
              P=findpeaks(X,Y,SlopeThreshold,AmpThreshold,SmoothWidth,FitWidth);
          end
          sizeP=size(P);
          NumPeaks=sizeP(1);
          showpeak=showpeak-1;
          if showpeak>NumPeaks,showpeak=1;end
          if showpeak<1,showpeak=NumPeaks;end
          center=P(showpeak,2);
          xo=val2ind(X,center);
          [xx,yy]=RedrawSignal(X,Y,xo,dx);
      otherwise  
         UnassignedKey=double(key)
       disp('Press k to print out list of keyboard commands')
   end % switch double(key),
end % if ischar(key),
% ----------------------------------------------------------------------    
function [xx,yy]=RedrawSignal(X,Y,xo,dx)
% Plots the entire signal (X,Y) in the lower half of the plot window and an
% isolated segment (xx,yy) in the upper half, controlled by Pan and Zoom
% keys.
global SlopeThreshold AmpThreshold SmoothWidth FitWidth PeakLabels valleymode
global PeakID Names Positions maxerror P plotcolor logplot AUTOZERO 
Startx=round(xo-(dx/2));
Endx=abs(round(xo+(dx/2)-1));
if (Endx-Startx)<SmoothWidth,Endx=Startx+SmoothWidth;end
if Endx>length(Y),Endx=length(Y);end
if Startx<1,Startx=1;end
PlotRange=Startx:Endx;
if (Endx-Startx)<5, PlotRange=xo:xo+5;end
xx=X(PlotRange);
yy=Y(PlotRange);
hold off
% clf
% Plots isolated segment (xx,yy) in the upper half
switch plotcolor
    case 0
        color='b.';
    case 1
        color='g.';
    case 2
        color='r.';
    case 3
        color='c.';
    case 4
        color='m.';
    case 5
        color='k.';
end
% auto-zero operation
if AUTOZERO==1,
    X1=min(xx);
    X2=max(xx);
    Y1=mean(yy(1:length(xx)/20));
    Y2=mean(yy((length(xx)-length(xx)/20):length(xx)));
    yy=yy-((Y2-Y1)/(X2-X1)*(xx-X1)+Y1);
end % if
figure(1);subplot(2,1,1);plot(xx,yy,color);
hold off
if AUTOZERO==1
    if valleymode
         title('iPeak 3.8.   Valley mode. Autozero ON.  Press K for keyboard commands')
    else
         title('iPeak 3.8.   Peak mode.   Autozero ON.  Press K for keyboard commands')
    end
else
    if valleymode
         title('iPeak 3.8.   Valley mode. Autozero OFF.  Press K for keyboard commands')
    else
         title('iPeak 3.8.   Peak mode.   Autozero OFF.  Press K for keyboard commands')
    end
end

axis([X(Startx) X(Endx) min(yy) max(yy)+(max(yy)-min(yy))/10]);
xlabel('Space/Tab: next/previous peak.  Mode: U  Autozero: T   Log/linear: Y  Report: R')

% Bottom half of the figure shows full signal
subplot(2,1,2);cla
switch plotcolor
    case 0; color='b';
    case 1; color='g';
    case 2; color='r';
    case 3; color='c';
    case 4; color='m';
    case 5; color='k';
end
hold off
if logplot,
    semilogy(X,abs(Y),color)  % Graph the signal with linear Y axis
else
    plot(X,Y,color)  % Graph the signal with linear Y axis
end
if valleymode,
  P=findvalleys(X,Y,SlopeThreshold,AmpThreshold,SmoothWidth,FitWidth);
else
  P=findpeaks(X,Y,SlopeThreshold,AmpThreshold,SmoothWidth,FitWidth);   
end
title('AmpT: A/Z   SlopeT: S/X   SmoothW: D/C    FitW: F/V   Background: B'  )
if logplot,
    ylabel('Log y mode')
    xlabel(['    AmpT: ' num2str(AmpThreshold) '     SlopeT: ' num2str(SlopeThreshold) '    SmoothW: ' num2str(SmoothWidth) '    FitW: ' num2str(FitWidth) ])
    axis([X(1) X(length(X)) min(abs(Y)) max(Y)]); % Update plot
else
    ylabel('Linear mode')
    xlabel(['    AmpT: ' num2str(AmpThreshold) '     SlopeT: ' num2str(SlopeThreshold) '    SmoothW: ' num2str(SmoothWidth) '    FitW: ' num2str(FitWidth) ])
    axis([X(1) X(length(X)) min(Y) max(Y)]); % Update plot
end

text(P(:,2),P(:,3),num2str(P(:,1)))  % Number the peaks found on the lower graph
hold on
% Mark the zoom range on the full signal with two magenta dotted vertical lines
center=X(round(xo));
checkzero=abs(Y);
checkzero(~checkzero)=NaN; % Find smallest non-zero value
plot([min(xx) min(xx)],[min(checkzero) max(Y)],'m--')
plot([max(xx) max(xx)],[min(checkzero) max(Y)],'m--')
plot([center center],[min(checkzero) max(Y)],'g-')
% Number the peaks found on the upper graph
subplot(2,1,1);
if valleymode,
  PP=findvalleys(xx,yy,SlopeThreshold,AmpThreshold,SmoothWidth,FitWidth);
else
  PP=findpeaks(xx,yy,SlopeThreshold,AmpThreshold,SmoothWidth,FitWidth);   
end
if PeakLabels,
    % Label the peaks on the upper graph with number, position, height, and
    % width
    % auto-zero operation
    if AUTOZERO==1,
        X1=min(xx);
        X2=max(xx);
        Y1=mean(yy(1:length(xx)/20));
        Y2=mean(yy((length(xx)-length(xx)/20):length(xx)));
        yy=yy-((Y2-Y1)/(X2-X1)*(xx-X1)+Y1);
    end % if AUTOZERO
    topaxis=axis;
    yrange=topaxis(4)-topaxis(3);
    pos1=.1*yrange;
    pos2=.2*yrange;
    pos3=.3*yrange;
    pos4=.4*yrange;
    text(P(:,2),P(:,3)-pos1,num2str(P(:,1)))
    text(PP(:,2),PP(:,3)-pos2,num2str(PP(:,2)))
    text(PP(:,2),PP(:,3)-pos3,num2str(PP(:,3)))
    text(PP(:,2),PP(:,3)-pos4,num2str(PP(:,4)))
else
    topaxis=axis;
    yrange=topaxis(4)-topaxis(3);
    pos1=.1*yrange;
    % Number the peaks on the upper graph
    text(P(:,2),P(:,3)-pos1,num2str(P(:,1)))
end
hold on
lyy=min(yy);
uyy=max(yy)+(max(yy)-min(yy))/10;
if lyy<uyy;
    axis([X(Startx) X(Endx) lyy uyy ]);
end
center=X(round(xo));
hold on;plot([center center],[lyy uyy],'g-')
% Draw red best-fit line through peak tops in upper windows.
if PP(1)>0, % if any peaks are detected
    sizePP=size(PP);
    lengthPP=sizePP(1);
    for PeakNumber=1:lengthPP,
        subplot(2,1,1);
        if PeakNumber>lengthPP,PeakNumber=lengthPP;end
        n1=round(val2ind(xx,PP(PeakNumber,2))-FitWidth/2);
        n2=round(val2ind(xx,PP(PeakNumber,2))+FitWidth/2);
        if n1<1, n1=1;end
        if n2>length(yy), n2=length(yy);end
        PlotRange=n1:n2;
        xxx=xx(PlotRange);
        yyy=yy(PlotRange);
        if valleymode,
            [coef,S]=polyfit(xxx,yyy,2);  % Fit parabola to sub-group with centering and scaling
            c1=coef(3);c2=coef(2);c3=coef(1);
            subplot(2,1,1);
            plotspace=linspace(min(xxx),max(xxx));
            plot(plotspace,c3*plotspace.^2+c2*plotspace+c1,'r');
        else
            % Fit parabola to log10 of sub-group
            [coef,S,MU]=polyfit(xxx,log(abs(yyy)),2);
            c1=coef(3);c2=coef(2);c3=coef(1);
            % Compute peak position and height or fitted parabola
            PeakX=-((MU(2).*c2/(2*c3))-MU(1));
            PeakY=exp(c1-c3*(c2/(2*c3))^2);
            MeasuredWidth=norm(MU(2).*2.35477/(sqrt(2)*sqrt(-1*c3)));
            subplot(2,1,1);
            plotspace=linspace(min(xxx),max(xxx));
            plot(plotspace,PeakY.*gaussian(plotspace,PeakX,MeasuredWidth),'r');
        end
    end   % for PeakNumber
    % Place a label in the upper left corner with peak number, position,
    % height, and width of the peak closest to the center of the window.
    PeakAtCenter=val2ind(P(:,2),center);
    % auto-zero operation
    if AUTOZERO==1,
        X1=min(xx);
        X2=max(xx);
        Y1=mean(yy(1:length(xx)/20));
        Y2=mean(yy((length(xx)-length(xx)/20):length(xx)));
        yy=yy-((Y2-Y1)/(X2-X1)*(xx-X1)+Y1);
    end % if AUTOZERO
    n1=round(val2ind(xx,P(PeakAtCenter,2))-FitWidth/2);
    n2=round(val2ind(xx,P(PeakAtCenter,2))+FitWidth/2);
    if n1<1, n1=1;end
    if n2>length(yy), n2=length(yy);end
    FitRange=n1:n2;
    xxx=xx(FitRange);
    yyy=yy(FitRange);
    if valleymode,
        [coef]=polyfit(xxx,yyy,2);  % Fit parabola to sub-group with centering and scaling
        c1=coef(3);c2=coef(2);c3=coef(1);
        PeakX=-c2/(2*c3);
        PeakY=(c1-(c2*c2/(4*c3)));
        MeasuredWidth=norm(2.35703/(sqrt(2)*sqrt(-1*c3)));
    else
        % Fit parabola to log10 of sub-group
        [coef,S,MU]=polyfit(xxx,log(abs(yyy)),2);
        c1=coef(3);c2=coef(2);c3=coef(1);
        % Compute peak position and height or fitted parabola
        PeakX=-((MU(2).*c2/(2*c3))-MU(1));
        PeakY=exp(c1-c3*(c2/(2*c3))^2);
        MeasuredWidth=norm(MU(2).*2.35477/(sqrt(2)*sqrt(-1*c3)));
    end
    startx=min(xx)+(max(xx)-min(xx))./20;
    dyy=(max(yy)-min(yy))./10;
    starty=max(yy)-dyy;
    if valleymode,
        text(startx,starty+dyy/2,['Valley ' num2str(PeakAtCenter) ] );
    else
        text(startx,starty+dyy/2,['Peak ' num2str(PeakAtCenter) ] );
    end
    topaxis=axis;
    yrange=topaxis(4)-topaxis(3);
    pos1=.1*yrange;
    pos2=.2*yrange;
    pos3=.3*yrange;
    text(startx,starty+dyy/2-pos1,['Position: ' num2str(PeakX)])
    text(startx,starty+dyy/2-pos2,['Height: ' num2str(PeakY)])
    text(startx,starty+dyy/2-pos3,['Width: ' num2str(MeasuredWidth)])
    % Add peak identification if peak identification mode is ON and
    % information provided in arguments 9, 10, and 11.
    if PeakID, % If peak identification mode is ON
        for n=1:length(PP(:,2)),
            %      [PP(n,2) Positions(n)]
            m=val2ind(Positions,PP(n,2)); % m=index of the cloest match in Positions
            Error=abs(PP(n,2)-Positions(m)); % Error=difference between detected peak and nearest peak in table
            if Error<maxerror, % Only identify the peaks if the error is less than MaxError
                text(PP(n,2),PP(n,3),Names(m)); % Label the graph peaks with element names
            end % if error
        end  % for n
    end  % if PeakID
end  % if any peaks are detected
hold off
sizeP=size(P);
NumPeaks=sizeP(1);
P=MeasurePeaks(NumPeaks,X,Y,P,dx,SmoothWidth,FitWidth,AUTOZERO,valleymode);
%-----------------------------------------------------------------
function PP=MeasurePeaks(NumPeaks,X,Y,P,dx,SmoothWidth,FitWidth,AUTOZERO,valleymode)
PP=zeros(size(P));
for PeakNumber=1:NumPeaks,
    center=P(PeakNumber,2);
    xo=val2ind(X,center);
    Startx=round(xo-(dx/2));
    Endx=abs(round(xo+(dx/2)-1));
    if (Endx-Startx)<SmoothWidth,Endx=Startx+SmoothWidth;end
    if Endx>length(Y),Endx=length(Y);end
    if Startx<1,Startx=1;end
    PlotRange=Startx:Endx;
    if (Endx-Startx)<5, PlotRange=xo:xo+5;end
    xx=X(PlotRange);
    yy=Y(PlotRange);
    if AUTOZERO==1,
        X1=min(xx);
        X2=max(xx);
        Y1=mean(yy(1:length(xx)/20));
        Y2=mean(yy((length(xx)-length(xx)/20):length(xx)));
        yy=yy-((Y2-Y1)/(X2-X1)*(xx-X1)+Y1);
    end % if AUTOZERO
    n1=round(val2ind(xx,P(PeakNumber,2))-FitWidth/2);
    n2=round(val2ind(xx,P(PeakNumber,2))+FitWidth/2);
    if n1<1, n1=1;end
    if n2>length(yy), n2=length(yy);end
    FitRange=n1:n2;
    xxx=xx(FitRange);
    yyy=yy(FitRange);
    if valleymode,
        [coef]=polyfit(xxx,yyy,2);  % Fit parabola to sub-group with centering and scaling
        c1=coef(3);c2=coef(2);c3=coef(1);
        PeakX=-c2/(2*c3);
        PeakY=(c1-(c2*c2/(4*c3)));
        MeasuredWidth=norm(2.35703/(sqrt(2)*sqrt(-1*c3)));
        EstimatedArea=0;
    else
        [coef,S,MU]=polyfit(xxx,log(abs(yyy)),2);   % Fit parabola to log10 of sub-group
        c1=coef(3);c2=coef(2);c3=coef(1);
        % Compute peak position and height or fitted parabola
        PeakX=-((MU(2).*c2/(2*c3))-MU(1));
        PeakY=exp(c1-c3*(c2/(2*c3))^2);
        MeasuredWidth=norm(MU(2).*2.35477/(sqrt(2)*sqrt(-1*c3)));
        EstimatedArea=1.0646.*PeakY*MeasuredWidth;
    end
    PP(PeakNumber,:)=[PeakNumber PeakX PeakY MeasuredWidth EstimatedArea];
end   % for PeakNumber
% ----------------------------------------------------------------------
function P=findpeaks(x,y,SlopeThreshold,AmpThreshold,smoothwidth,peakgroup)
% function P=findpeaks(x,y,SlopeThreshold,AmpThreshold,smoothwidth,peakgroup)
% Function to locate the positive peaks in a noisy x-y data
% set.  Detects peaks by looking for downward zero-crossings
% in the first derivative that exceed SlopeThreshold.
% Returns list (P) containing peak number and the position, 
% height, width, and area of each peak. SlopeThreshold,
% AmpThreshold, and smoothwidth control sensitivity
% Higher values will neglect smaller features. Peakgroup
% is the number of points around the "top part" of the peak.
% T. C. O'Haver, 1995.  Version 3; revised June 7, 2011, Smooth type=3
smoothwidth=round(smoothwidth);
peakgroup=round(peakgroup);
d=fastsmooth(deriv(y),smoothwidth,3);
n=round(peakgroup/2+1);
P=[0 0 0 0 0];
vectorlength=length(y);
peak=1;
AmpTest=AmpThreshold;
for j=smoothwidth:length(y)-smoothwidth,
   if sign(d(j)) > sign (d(j+1)), % Detects zero-crossing
       % if slope of derivative is larger than SlopeThreshold
     if d(j)-d(j+1) > SlopeThreshold*y(j), 
        if y(j) > AmpTest,  % if height of peak is larger than AmpThreshold
            xx=zeros(size(peakgroup));yy=zeros(size(peakgroup));
            for k=1:peakgroup, % Create sub-group of points near peak
                groupindex=j+k-n+1;
                if groupindex<1, groupindex=1;end
                if groupindex>vectorlength, groupindex=vectorlength;end
                xx(k)=x(groupindex);yy(k)=y(groupindex);
            end % Fit parabola to log10 of sub-group with centering and scaling
          [coef,S,MU]=polyfit(xx,log(abs(yy)),2);  
          c1=coef(3);c2=coef(2);c3=coef(1);
          % Compute peak position and height of fitted parabola
          PeakX=-((MU(2).*c2/(2*c3))-MU(1));   
          PeakY=exp(c1-c3*(c2/(2*c3))^2);
          MeasuredWidth=norm(MU(2).*2.35477/(sqrt(2)*sqrt(-1*c3)));
          P(peak,:) = [round(peak) PeakX PeakY MeasuredWidth 1.0646.*PeakY*MeasuredWidth];
          peak=peak+1;
        end
      end
   end
end
% ----------------------------------------------------------------------
function V=findvalleys(x,y,SlopeThreshold,AmpThreshold,smoothwidth,peakgroup,smoothtype)
% function P=findvalleys(x,y,SlopeThreshold,AmpThreshold,smoothwidth,peakgroup,smoothtype)
% Function to locate the valleys (mimnima) in a noisy x-y time series data
% set.  Detects valleys by looking for upward zero-crossings
% in the first derivative that exceed SlopeThreshold.
% Returns list (V) containing valley number and position, 
% depth, and width of each valley. Arguments "slopeThreshold",
% "ampThreshold" and "smoothwidth" control sensitivity.
% Higher values will neglect smaller features. "Smoothwidth" is
% the width of the smooth applied before valley detection; larger
% values ignore narrow features. "Peakgroup" is the number points 
% around the bottom part of the valley that are fit to a parabola to
% determine the valley vertex (x and y at lowest point) and width.
% The argument "smoothtype" determines the smooth algorithm:
%   If smoothtype=1, rectangular (sliding-average or boxcar) 
%   If smoothtype=2, triangular (2 passes of sliding-average)
%   If smoothtype=3, pseudo-Gaussian (3 passes of sliding-average)
% See http://terpconnect.umd.edu/~toh/spectrum/Smoothing.html and 
% http://terpconnect.umd.edu/~toh/spectrum/PeakFindingandMeasurement.htm
% T. C. O'Haver, Version 2=1, September, 2011
if nargin~=7;smoothtype=1;end  % smoothtype=1 if not specified in argument
if smoothtype>3;smoothtype=3;end
if smoothtype<1;smoothtype=1;end 
smoothwidth=round(smoothwidth);
peakgroup=round(peakgroup);
d=fastsmooth(deriv(y),smoothwidth,smoothtype);
n=round(peakgroup/2+1);
V=[0 0 0 0 0];
vectorlength=length(y);
peak=1;
AmpTest=AmpThreshold;
for j=smoothwidth:length(y)-smoothwidth,
    if sign(d(j)) < sign (d(j+1)), % Detects zero-crossing
        if d(j+1)-d(j) > SlopeThreshold*y(j), % if slope of derivative is larger than SlopeThreshold
            if y(j) > AmpTest,  % if height of valley is larger than AmpThreshold
                xx=zeros(size(peakgroup));yy=zeros(size(peakgroup));
                for k=1:peakgroup, % Create sub-group of points near valley
                    groupindex=j+k-n+1;
                    if groupindex<1, groupindex=1;end
                    if groupindex>vectorlength, groupindex=vectorlength;end
                    xx(k)=x(groupindex);yy(k)=y(groupindex);
                end
                [coef,S]=polyfit(xx,yy,2);  % Fit parabola to sub-group with centering and scaling
                c1=coef(3);c2=coef(2);c3=coef(1);
                valleyX=-c2/(2*c3);   % Compute valley position and height of fitted parabola
                valleyY=(c1-(c2*c2/(4*c3)));
                MeasuredWidth=norm(2.35703/(sqrt(2)*sqrt(-1*c3)));
                % if the valley is too narrow for least-squares technique to work
                % well, just use the min value of y in the sub-group of points near valley.
                if peakgroup<5,
                    valleyY=min(yy);
                    pindex=val2ind(yy,valleyY);
                    valleyX=xx(pindex(1));
                end
                % Construct matrix P. One row for each valley
                % detected, containing the valley number, valley
                % position (x-value) and valley depth (y-value).
                % Area is not measured for valleys, so put a zero
                V(peak,:) = [round(peak) valleyX valleyY MeasuredWidth 0];
                peak=peak+1;
            end
        end
    end
end
% ----------------------------------------------------------------------
function d=deriv(a)
% First derivative of vector using 2-point central difference.
%  T. C. O'Haver, 1988.
n=length(a);
d=zeros(size(a));
d(1)=a(2)-a(1);
d(n)=a(n)-a(n-1);
for j = 2:n-1;
  d(j)=(a(j+1)-a(j-1)) ./ 2;
end
% ----------------------------------------------------------------------
function SmoothY=fastsmooth(Y,w,type,ends)
% fastsmooth(Y,w,type,ends) smooths vector Y with smooth 
%  of width w. Version 2.0, May 2008.
% The argument "type" determines the smooth type:
%   If type=1, rectangular (sliding-average or boxcar) 
%   If type=2, triangular (2 passes of sliding-average)
%   If type=3, pseudo-Gaussian (3 passes of sliding-average)
% The argument "ends" controls how the "ends" of the signal 
% (the first w/2 points and the last w/2 points) are handled.
%   If ends=0, the ends are zero.  (In this mode the elapsed 
%     time is independent of the smooth width). The fastest.
%   If ends=1, the ends are smoothed with progressively 
%     smaller smooths the closer to the end. (In this mode the  
%     elapsed time increases with increasing smooth widths).
% fastsmooth(Y,w,type) smooths with ends=0.
% fastsmooth(Y,w) smooths with type=1 and ends=0.
% Example:
% fastsmooth([1 1 1 10 10 10 1 1 1 1],3)= [0 1 4 7 10 7 4 1 1 0]
% fastsmooth([1 1 1 10 10 10 1 1 1 1],3,1,1)= [1 1 4 7 10 7 4 1 1 1]
%  T. C. O'Haver, May, 2008.
if nargin==2, ends=0; type=1; end
if nargin==3, ends=0; end
  switch type
    case 1
       SmoothY=sa(Y,w,ends);
    case 2   
       SmoothY=sa(sa(Y,w,ends),w,ends);
    case 3
       SmoothY=sa(sa(sa(Y,w,ends),w,ends),w,ends);
  end

function SmoothY=sa(Y,smoothwidth,ends)
w=round(smoothwidth);
SumPoints=sum(Y(1:w));
s=zeros(size(Y));
halfw=round(w/2);
L=length(Y);
for k=1:L-w,
   s(k+halfw-1)=SumPoints;
   SumPoints=SumPoints-Y(k);
   SumPoints=SumPoints+Y(k+w);
end
s(k+halfw)=sum(Y(L-w+1:L));
SmoothY=s./w;
% Taper the ends of the signal if ends=1.
  if ends==1,
    startpoint=(smoothwidth + 1)/2;
    SmoothY(1)=(Y(1)+Y(2))./2;
    for k=2:startpoint,
       SmoothY(k)=mean(Y(1:(2*k-1)));
       SmoothY(L-k+1)=mean(Y(L-2*k+2:L));
    end
    SmoothY(L)=(Y(L)+Y(L-1))./2;
  end
% ----------------------------------------------------------------------
function [FitResults,LowestError,BestStart,xi,yi]=peakfit(signal,center,window,NumPeaks,peakshape,extra,NumTrials,start,AUTOZERO)
% Version 2: Aug, 2011. For details, see
% http://terpconnect.umd.edu/~toh/spectrum/InteractivePeakFitter.htm

global AA xxx PEAKHEIGHTS

format short g
format compact
warning off all

datasize=size(signal);
if datasize(1)<datasize(2),signal=signal';end
datasize=size(signal);
if datasize(2)==1, %  Must be isignal(Y-vector)
    X=1:length(signal); % Create an independent variable vector
    Y=signal;
else
    % Must be isignal(DataMatrix)
    X=signal(:,1); % Split matrix argument 
    Y=signal(:,2);
end
X=reshape(X,1,length(X)); % Adjust X and Y vector shape to 1 x n (rather than n x 1)
Y=reshape(Y,1,length(Y));
% If necessary, flip the data vectors so that X increases
if X(1)>X(length(X)),
    disp('X-axis flipped.')
    X=fliplr(X);
    Y=fliplr(Y);
end
% Y=Y-min(Y);  % Remove excess offset from data
% Isolate desired segment from data set for curve fitting
if nargin==1 || nargin==2,center=(max(X)-min(X))/2;window=max(X)-min(X);end
xoffset=center-window/2;
n1=val2ind(X,center-window/2);
n2=val2ind(X,center+window/2);
if window==0,n1=1;n2=length(X);end
xx=X(n1:n2)-xoffset;
yy=Y(n1:n2);
ShapeString='Gaussian';

% Remove linear baseline from data segment
if AUTOZERO==1,
  X1=min(xx);
  X2=max(xx);
  lengthxx=length(xx);
  avgback=round(length(xx)/20);
  lengthyy=length(yy);
  Y1=mean(yy(1:avgback));
  Y2=mean(yy((length(xx)-avgback):length(xx)));
  yy=yy-((Y2-Y1)/(X2-X1)*(xx-X1)+Y1);
end % if

PEAKHEIGHTS=zeros(1,NumPeaks);
n=length(xx);
newstart=start;
switch NumPeaks
    case 1
        newstart(1)=start(1)-xoffset;
    case 2
        newstart(1)=start(1)-xoffset;
        newstart(3)=start(3)-xoffset;
    case 3
        newstart(1)=start(1)-xoffset;
        newstart(3)=start(3)-xoffset;
        newstart(5)=start(5)-xoffset;
    case 4
        newstart(1)=start(1)-xoffset;
        newstart(3)=start(3)-xoffset;
        newstart(5)=start(5)-xoffset;
        newstart(7)=start(7)-xoffset;
     case 5
        newstart(1)=start(1)-xoffset;
        newstart(3)=start(3)-xoffset;
        newstart(5)=start(5)-xoffset;
        newstart(7)=start(7)-xoffset;        
        newstart(9)=start(9)-xoffset;
     case 6
        newstart(1)=start(1)-xoffset;
        newstart(3)=start(3)-xoffset;
        newstart(5)=start(5)-xoffset;
        newstart(7)=start(7)-xoffset;        
        newstart(9)=start(9)-xoffset;
        newstart(11)=start(11)-xoffset;
    otherwise       
end % switch NumPeaks

% Perform peak fitting for selected peak shape using fminsearch function
options = optimset('TolX',.00001,'Display','off' );
LowestError=1000; % or any big number greater than largest error expected
FitParameters=zeros(1,NumPeaks.*2); 
BestStart=zeros(1,NumPeaks.*2); 
height=zeros(1,NumPeaks); 
bestmodel=zeros(size(yy));
for k=1:NumTrials, 
    % disp(k) % optionally prints the current trial number as progress indicator
  switch peakshape
    case 1
        TrialParameters=fminsearch(@fitgaussian,newstart,options,xx,yy);
        ShapeString='Gaussian';
    case 2
        TrialParameters=fminsearch(@fitlorentzian,newstart,options,xx,yy);
        ShapeString='Lorentzian';    
    case 3
        TrialParameters=fminsearch(@fitlogistic,newstart,options,xx,yy);
        ShapeString='Logistic';
    case 4
        TrialParameters=fminsearch(@fitpearson,newstart,options,xx,yy,extra);
        ShapeString='Pearson';
    case 5
        TrialParameters=fminsearch(@fitexpgaussian,newstart,options,xx,yy,-extra);
        ShapeString='ExpGaussian';
    case 6
        cwnewstart(1)=newstart(1);
        for pc=2:NumPeaks,
            cwnewstart(pc)=newstart(2.*pc-1);  
        end
        cwnewstart(NumPeaks+1)=(max(xx)-min(xx))/5;
        TrialParameters=fminsearch(@fitewgaussian,cwnewstart,options,xx,yy);
        ShapeString='Equal width Gaussians';
    case 7
        cwnewstart(1)=newstart(1);
        for pc=2:NumPeaks,
            cwnewstart(pc)=newstart(2.*pc-1);  
        end
        cwnewstart(NumPeaks+1)=(max(xx)-min(xx))/5;
        TrialParameters=fminsearch(@fitlorentziancw,cwnewstart,options,xx,yy);
        ShapeString='Equal width Lorentzians';
    case 8
        cwnewstart(1)=newstart(1);
        for pc=2:NumPeaks,
            cwnewstart(pc)=newstart(2.*pc-1);  
        end
        cwnewstart(NumPeaks+1)=(max(xx)-min(xx))/5;
        TrialParameters=fminsearch(@fitexpewgaussian,cwnewstart,options,xx,yy,-extra);
        ShapeString='Exp. equal width Gaussians';
      otherwise
  end % switch peakshape
  
% Construct model from Trial parameters
A=zeros(NumPeaks,n);
for m=1:NumPeaks,
   switch peakshape
    case 1
        A(m,:)=gaussian(xx,TrialParameters(2*m-1),TrialParameters(2*m));
    case 2
        A(m,:)=lorentzian(xx,TrialParameters(2*m-1),TrialParameters(2*m));
    case 3
        A(m,:)=logistic(xx,TrialParameters(2*m-1),TrialParameters(2*m));
    case 4
        A(m,:)=pearson(xx,TrialParameters(2*m-1),TrialParameters(2*m),extra);
    case 5
        A(m,:)=expgaussian(xx,TrialParameters(2*m-1),TrialParameters(2*m),-extra)';
    case 6
        A(m,:)=gaussian(xx,TrialParameters(m),TrialParameters(NumPeaks+1));
    case 7
        A(m,:)=lorentzian(xx,TrialParameters(m),TrialParameters(NumPeaks+1));  
    case 8
        A(m,:)=expgaussian(xx,TrialParameters(m),TrialParameters(NumPeaks+1),-extra)';    
    otherwise
  end % switch
      switch NumPeaks % adds random variation to non-linear parameters
       case 1
          newstart=[newstart(1)*(1+randn/50) newstart(2)*(1+randn/10)]; 
       case 2
          newstart=[newstart(1)*(1+randn/50) newstart(2)*(1+randn/10) newstart(3)*(1+randn/50) newstart(4)*(1+randn/10)]; 
       case 3
          newstart=[newstart(1)*(1+randn/50) newstart(2)*(1+randn/10) newstart(3)*(1+randn/50) newstart(4)*(1+randn/10) newstart(5)*(1+randn/50) newstart(6)*(1+randn/10)]; 
       case 4
          newstart=[newstart(1)*(1+randn/50) newstart(2)*(1+randn/10) newstart(3)*(1+randn/50) newstart(4)*(1+randn/10) newstart(5)*(1+randn/50) newstart(6)*(1+randn/10)  newstart(7)*(1+randn/50) newstart(8)*(1+randn/10)]; 
       case 5
          newstart=[newstart(1)*(1+randn/50) newstart(2)*(1+randn/10) newstart(3)*(1+randn/50) newstart(4)*(1+randn/10) newstart(5)*(1+randn/50) newstart(6)*(1+randn/10)  newstart(7)*(1+randn/50) newstart(8)*(1+randn/10)  newstart(9)*(1+randn/50) newstart(10)*(1+randn/10)]; 
       otherwise       
     end % switch NumPeaks
end % for
% Multiplies each row by the corresponding amplitude and adds them up
model=PEAKHEIGHTS'*A;

% Compare trial model to data segment and compute the fit error
  MeanFitError=100*norm(yy-model)./(sqrt(n)*max(yy));
  % Take only the single fit that has the lowest MeanFitError
  if MeanFitError<LowestError, 
      if min(PEAKHEIGHTS)>0,  % Consider only fits with positive peak heights
        LowestError=MeanFitError;  % Assign LowestError to the lowest MeanFitError
        FitParameters=TrialParameters;  % Assign FitParameters to the fit with the lowest MeanFitError
        BestStart=newstart; % Assign BestStart to the start with the lowest MeanFitError
        height=PEAKHEIGHTS; % Assign height to the PEAKHEIGHTS with the lowest MeanFitError
        bestmodel=model; % Assign bestmodel to the model with the lowest MeanFitError
      end % if min(PEAKHEIGHTS)>0
  end % if MeanFitError<LowestError
end % for k (NumTrials)
%
% Construct model from best-fit parameters
AA=zeros(NumPeaks,100);
xxx=linspace(min(xx),max(xx));
for m=1:NumPeaks,
   switch peakshape
    case 1
        AA(m,:)=gaussian(xxx,FitParameters(2*m-1),FitParameters(2*m));
    case 2
        AA(m,:)=lorentzian(xxx,FitParameters(2*m-1),FitParameters(2*m));
    case 3
        AA(m,:)=logistic(xxx,FitParameters(2*m-1),FitParameters(2*m));
    case 4
        AA(m,:)=pearson(xxx,FitParameters(2*m-1),FitParameters(2*m),extra);
    case 5
        AA(m,:)=expgaussian(xxx,FitParameters(2*m-1),FitParameters(2*m),-extra*length(xxx)./length(xx))';
    case 6
        AA(m,:)=gaussian(xxx,FitParameters(m),FitParameters(NumPeaks+1));
    case 7
        AA(m,:)=lorentzian(xxx,FitParameters(m),FitParameters(NumPeaks+1));
    case 8
        AA(m,:)=expgaussian(xxx,FitParameters(m),FitParameters(NumPeaks+1),-extra*length(xxx)./length(xx))';
       otherwise
  end % switch
end % for

% Multiplies each row by the corresponding amplitude and adds them up
heightsize=size(height');
AAsize=size(AA);
if heightsize(2)==AAsize(1),
   mmodel=height'*AA;
else
    mmodel=height*AA;
end
% Top half of the figure shows original signal and the fitted model.
figure(2)
subplot(2,1,1);plot(xx+xoffset,yy,'b.'); % Plot the original signal in blue dots
hold on
for m=1:NumPeaks,
    plot(xxx+xoffset,height(m)*AA(m,:),'g')  % Plot the individual component peaks in green lines
    area(m)=trapz(xxx+xoffset,height(m)*AA(m,:)); % Compute the area of each component peak using trapezoidal method
    yi(m,:)=height(m)*AA(m,:); % (NEW) Place y values of individual model peaks into matrix yi
end
xi=xxx+xoffset; % (NEW) Place the x-values of the individual model peaks into xi

plot(xxx+xoffset,mmodel,'r');  % Plot the total model (sum of component peaks) in red lines
hold off;
axis([min(xx)+xoffset max(xx)+xoffset 0 max(yy)]);
title('Iterative Least-squares Peak Fit')
xlabel(['Peaks = ' num2str(NumPeaks) '     Shape = ' ShapeString '     Error = ' num2str(round(100*LowestError)/100) '%    Extra = ' num2str(extra) ] )

% Bottom half of the figure shows the residuals and displays RMS error
% between original signal and model
residual=yy-bestmodel;
subplot(2,1,2);plot(xx+xoffset,residual,'b.')
axis([min(xx)+xoffset max(xx)+xoffset min(residual) max(residual)]);
xlabel('Residual Plot')

% Put results into a matrix, one row for each peak, showing peak index number,
% position, amplitude, and width.
for m=1:NumPeaks,
    if m==1,
        if peakshape==6||peakshape==7||peakshape==8,
           FitResults=[[round(m) FitParameters(m)+xoffset height(m) abs(FitParameters(NumPeaks+1)) area(m)]];
        else
           FitResults=[[round(m) FitParameters(2*m-1)+xoffset height(m) abs(FitParameters(2*m)) area(m)]];
        end % if peakshape
    else
        if peakshape==6||peakshape==7||peakshape==8,
           FitResults=[FitResults ; [round(m) FitParameters(m)+xoffset height(m) abs(FitParameters(NumPeaks+1)) area(m)]];
        else
           FitResults=[FitResults ; [round(m) FitParameters(2*m-1)+xoffset height(m) abs(FitParameters(2*m)) area(m)]];
        end % if peakshape
     end % m==1
end % for m=1:NumPeaks

% Display Fit Results on upper graph
subplot(2,1,1);
startx=min(xx)+xoffset+(max(xx)-min(xx))./20;
dxx=(max(xx)-min(xx))./10;
dyy=(max(yy)-min(yy))./10;
starty=max(yy)-dyy;
FigureSize=get(gcf,'Position');
text(startx,starty+dyy/2,['                  Position        Height         Width             Area'] );
% Alternative method of printing FitResults using sprintf
 for peaknumber=1:NumPeaks,
    for column=2:5,
        itemstring=sprintf('%0.4g',FitResults(peaknumber,column));
        xposition=startx+(1.7.*dxx.*(column-1).*(600./FigureSize(3)));
        yposition=starty-peaknumber.*dyy.*(400./FigureSize(4));
        text(xposition,yposition,itemstring);
    end
 end
 figure(1)
% ----------------------------------------------------------------------
function start=calcstart(xx,NumPeaks,xoffset)
  n=max(xx)-min(xx);
  start=[];
  startpos=[n/(NumPeaks+1):n/(NumPeaks+1):n-(n/(NumPeaks+1))]+min(xx);
  for marker=1:NumPeaks,
      markx=startpos(marker)+ xoffset;
      start=[start markx n/5];
  end % for marker
% ----------------------------------------------------------------------
function [index,closestval]=val2ind(x,val)
% Returns the index and the value of the element of vector x that is closest to val
% If more than one element is equally close, returns vectors of indicies and values
% Tom O'Haver (toh@umd.edu) October 2006
% Examples: If x=[1 2 4 3 5 9 6 4 5 3 1], then val2ind(x,6)=7 and val2ind(x,5.1)=[5 9]
% [indices values]=val2ind(x,3.3) returns indices = [4 10] and values = [3 3]
dif=abs(x-val);
index=find((dif-min(dif))==0);
closestval=x(index);
% ----------------------------------------------------------------------
function err = fitgaussian(lambda,t,y)
% Fitting function for a Gaussian band signal.
global PEAKHEIGHTS
numpeaks=round(length(lambda)/2);
A = zeros(length(t),numpeaks);
for j = 1:numpeaks,
    A(:,j) = gaussian(t,lambda(2*j-1),lambda(2*j))';
end
PEAKHEIGHTS = abs(A\y');
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function err = fitewgaussian(lambda,t,y)
% Fitting function for a Gaussian band signal with equal peak widths.
global PEAKHEIGHTS
numpeaks=round(length(lambda)-1);
A = zeros(length(t),numpeaks);
for j = 1:numpeaks,
    A(:,j) = gaussian(t,lambda(j),lambda(numpeaks+1))';
end
PEAKHEIGHTS = abs(A\y');
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function err = fitlorentziancw(lambda,t,y)
% Fitting function for a Lorentzian band signal with equal peak widths.
global PEAKHEIGHTS
numpeaks=round(length(lambda)-1);
A = zeros(length(t),numpeaks);
for j = 1:numpeaks,
    A(:,j) = lorentzian(t,lambda(j),lambda(numpeaks+1))';
end
PEAKHEIGHTS = abs(A\y');
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function g = gaussian(x,pos,wid)
%  gaussian(X,pos,wid) = gaussian peak centered on pos, half-width=wid
%  X may be scalar, vector, or matrix, pos and wid both scalar
% Examples: gaussian([0 1 2],1,2) gives result [0.5000    1.0000    0.5000]
% plot(gaussian([1:100],50,20)) displays gaussian band centered at 50 with width 20.
g = exp(-((x-pos)./(0.6005615.*wid)) .^2);
% ----------------------------------------------------------------------
function err = fitlorentzian(lambda,t,y)
%	Fitting function for single lorentzian, lambda(1)=position, lambda(2)=width
%	Fitgauss assumes a lorentzian function 
global PEAKHEIGHTS
A = zeros(length(t),round(length(lambda)/2));
for j = 1:length(lambda)/2,
    A(:,j) = lorentzian(t,lambda(2*j-1),lambda(2*j))';
end
PEAKHEIGHTS = A\y';
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function g = lorentzian(x,position,width)
% lorentzian(x,position,width) Lorentzian function.
% where x may be scalar, vector, or matrix
% position and width scalar
% T. C. O'Haver, 1988
% Example: lorentzian([1 2 3],2,2) gives result [0.5 1 0.5]
g=ones(size(x))./(1+((x-position)./(0.5.*width)).^2);
% ----------------------------------------------------------------------
function err = fitlogistic(lambda,t,y)
%	Fitting function for logistic, lambda(1)=position, lambda(2)=width
%	between the data and the values computed by the current
%	function of lambda.  Fitlogistic assumes a logistic function 
%  T. C. O'Haver, May 2006
global PEAKHEIGHTS
A = zeros(length(t),round(length(lambda)/2));
for j = 1:length(lambda)/2,
    A(:,j) = logistic(t,lambda(2*j-1),lambda(2*j))';
end
PEAKHEIGHTS = A\y';
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function g = logistic(x,pos,wid)
% logistic function.  pos=position; wid=half-width (both scalar)
% logistic(x,pos,wid), where x may be scalar, vector, or matrix
% pos=position; wid=half-width (both scalar)
% T. C. O'Haver, 1991 
n = exp(-((x-pos)/(.477.*wid)) .^2);
g = (2.*n)./(1+n);
% ----------------------------------------------------------------------
function err = fitlognormal(lambda,t,y)
%	Fitting function for lognormal, lambda(1)=position, lambda(2)=width
%	between the data and the values computed by the current
%	function of lambda.  Fitlognormal assumes a lognormal function 
%  T. C. O'Haver, May 2006
global PEAKHEIGHTS
A = zeros(length(t),round(length(lambda)/2));
for j = 1:length(lambda)/2,
    A(:,j) = lognormal(t,lambda(2*j-1),lambda(2*j))';
end
PEAKHEIGHTS = A\y';
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function g = lognormal(x,pos,wid)
% lognormal function.  pos=position; wid=half-width (both scalar)
% lognormal(x,pos,wid), where x may be scalar, vector, or matrix
% pos=position; wid=half-width (both scalar)
% T. C. O'Haver, 1991  
g = exp(-(log(x/pos)/(0.01.*wid)) .^2);
% ----------------------------------------------------------------------
function err = fitpearson(lambda,t,y,shapeconstant)
%   Fitting functions for a Pearson 7 band signal.
% T. C. O'Haver (toh@umd.edu),   Version 1.3, October 23, 2006.
global PEAKHEIGHTS
A = zeros(length(t),round(length(lambda)/2));
for j = 1:length(lambda)/2,
    A(:,j) = pearson(t,lambda(2*j-1),lambda(2*j),shapeconstant)';
end
PEAKHEIGHTS = A\y';
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function g = pearson(x,pos,wid,m)
% Pearson VII function. 
% g = pearson7(x,pos,wid,m) where x may be scalar, vector, or matrix
% pos=position; wid=half-width (both scalar)
% m=some number
%  T. C. O'Haver, 1990  
g=ones(size(x))./(1+((x-pos)./((0.5.^(2/m)).*wid)).^2).^m;
% ----------------------------------------------------------------------
function err = fitexpgaussian(lambda,t,y,timeconstant)
%   Fitting functions for a exponentially-broadened Gaussian band signal.
%  T. C. O'Haver, October 23, 2006.
global PEAKHEIGHTS
A = zeros(length(t),round(length(lambda)/2));
for j = 1:length(lambda)/2,
    A(:,j) = expgaussian(t,lambda(2*j-1),lambda(2*j),timeconstant);
end
PEAKHEIGHTS = A\y';
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function err = fitexpewgaussian(lambda,t,y,timeconstant)
% Fitting function for exponentially-broadened Gaussian bands with equal peak widths.
global PEAKHEIGHTS
numpeaks=round(length(lambda)-1);
A = zeros(length(t),numpeaks);
for j = 1:numpeaks,
    A(:,j) = expgaussian(t,lambda(j),lambda(numpeaks+1),timeconstant);
end
PEAKHEIGHTS = abs(A\y');
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function g = expgaussian(x,pos,wid,timeconstant)
%  Exponentially-broadened gaussian(x,pos,wid) = gaussian peak centered on pos, half-width=wid
%  x may be scalar, vector, or matrix, pos and wid both scalar
%  T. C. O'Haver, 2006
g = exp(-((x-pos)./(0.6005615.*wid)) .^2);
g = ExpBroaden(g',timeconstant);
% ----------------------------------------------------------------------
function yb = ExpBroaden(y,t)
% ExpBroaden(y,t) convolutes y by an exponential decay of time constant t
% by multiplying Fourier transforms and inverse transforming the result.
fy=fft(y);
a=exp(-[1:length(y)]./t);
fa=fft(a);
fy1=fy.*fa';           
yb=real(ifft(fy1))./sum(a);  
% ----------------------------------------------------------------------
function err = fitNewPeakShape(lambda,x,y)
% Replace "NewPeakShape" with the peak function of your choice.
%  T. C. O'Haver, 2006   
global PEAKHEIGHTS
A = zeros(length(x),round(length(lambda)/2));
for j = 1:length(lambda)/2,
    A(:,j) = NewPeakShape(x,lambda(2*j-1),lambda(2*j))';
end
PEAKHEIGHTS = A\y';
z = A*PEAKHEIGHTS;
err = norm(z-y');
% ----------------------------------------------------------------------
function g = NewPeakShape(x,a,b)
% Replace this with the peak function of your choice.
% a and b are the two non-linear parameters.
g=sin(a.*x+b);
