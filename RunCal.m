% Use PsyCalibrator to get the LUT for calibrated displays

%% add toolbox to path
addpath(genpath('PsyCalibrator'));

%% Luminance and color measurement ======================================

%% Self calibrate SpyderX 
spyderCalibration_APL;

%% Measurement
RefreshRate = 60;
xyY = spyderRead_APL(RefreshRate);
% xyY matrix has 5 rows (5 measurements) and 3 columns (for xyY)

% get the mean of 5 samples
xyY_mean = mean(xyY,1);

%% Calibration measurement ==============================================
% This will return the LUTs you can use for gamma correction

%% Get hardware info
SPECS = inputdlg(...,
    {'Monitor brand','Model','Serial #','Brightness','Contrast',...
    'Color temp','Computer/Setup','OS','GPU'},...
    'Hardware Specs',1,...
    {'AOC','Q3279WG5B','xxx','90','50','9600',...
    'CK-HOME','Linux Mint 22','NVIDIA GeForce GTX 1660'});

%% Set measurement parameters
% Gamma = gammaMeasure_APL(...
%   deviceType,...
%   inputRects,...
%   whichScreen,...
%   outputFilename,...
%   beTestedCLUT,...
%   skipInputScreenInfo,...
%   skipCalibration,...
%   beTestedRGBs,...
%   LeaveTime,...
%   nMeasures)

% argins:
% deviceType: the type of the measure device (1,2,3,4,5 for Spyder 5, Spyder X, CRS's ColorCal MKII , PR670, and Spyder X2 respectively)
% inputRects: 4*n maxtrix for n Rects of the to be tested areas (default: 500*500 rect at the center of the last screen)
% whichScreen: index of the to be tested monitor [default max(Screen(''Screens''))]
% outputFilename: filename of the display calibration data file
% beTestedCLUT: to be tested Color Lookup Table (CLUT, default: linear line)
% skipInputScreenInfo: whether to skip the inputing of the monitor info (default: false)
% skipCalibration: whether to skip the calibration of the device (default: false)
% beTestedRGBs: to be tested RGBs, 1,2, or a n-row by 3-column matrix for gray, RGB channels, or customized RGBs respectively
% LeaveTime: how many seconds to leave the room (0-60): (default: 10)
% nMeasures: how many measures for each RGB
% ptbrect: select a subscreen (default = [] fullscreen)

deviceType = 2; % SpyderX
inputRects = [];
whichScreen = max(Screen('Screens'));
outputFilename = 'GammaCal'; % a timestamp getss added automatically
beTestedCLUT = [];
skipInputScreenInfo = SPECS; % boolean or prefilled cell array from above
skipCalibration = false;
beTestedRGBs = 2; % 1 = luminance full; 2 = RGB full
LeaveTime = 2;
nMeasures = 1;
ptbrect = [0 0 1080 800];

%% Do measurements
Gamma = gammaMeasure_APL(...
  deviceType,...
  inputRects,...
  whichScreen,...
  outputFilename,...
  beTestedCLUT,...
  skipInputScreenInfo,...
  skipCalibration,...
  beTestedRGBs,...
  LeaveTime,... 
  nMeasures,...
  ptbrect);

%% Fit the calibration data
Gamma = makeCorrectedGammaTab_APL([Gamma.fn_out '.mat']);

%% Verify calibration
gammaMeasure_APL(...
    deviceType,...
    inputRects,...
    whichScreen,...
    outputFilename,...
    Gamma.gammaTable,...
    skipInputScreenInfo,...
    skipCalibration,...
    beTestedRGBs,...
    LeaveTime,...
    nMeasures,...
    ptbrect);

%% Apply gamma correction ===============================================
%% apply the corrected gamma table
applyGammaCorrection_APL(...
    1,...
    Gamma.gammaTable,...
    whichScreen);

%% restore the default
applyGammaCorrection_APL(...
    0,...
    [],...
    whichScreen);

%% Other useful functions ===============================================

