function spyderCalibration_APL(printPromptInfo)
%    Written by Yang Zhang
%    2021-01-14 20:12:55
if ~exist('printPromptInfo','var')||isempty(printPromptInfo)
    printPromptInfo = 1;
end

if printPromptInfo
    cprintf([0 0 1],'Instruction:\nWe need to calibrate the device first by establishing the black level.\nNow make sure the lens cover of the photometer is fully closed. \nThen hit any key to proceed.\n');
    fprintf('Press any key to get started\n');
    pause;
end


if spyderXDependCheck_APL
    cFolder      = fileparts(mfilename('fullpath'));

    if IsWin
        commandStr = [fullfile(cFolder,'spotread.exe'),' -e -O -x'];
    elseif IsLinux
        commandStr = [fullfile(cFolder,'spotread'),' -e -O -x'];
    else % mac ox
        commandStr = [fullfile(cFolder,'spotreadsMac','spotread'),' -e -O -x'];
    end


    [status, results] = system(commandStr);

    if status
        error([results,char(13),'Calibration failed, see the infomation above for details']);
        fprintf('For a SpyderX this could mean the device is too cold.\n');
        fprintf('Warm it up a bit and try again\n');
    else
        fprintf('Calibration done!\n');
    end

else
    spyderXn('calibration');
    fprintf('Calibration done!\n');
end