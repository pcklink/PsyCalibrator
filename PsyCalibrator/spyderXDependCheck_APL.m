function status = spyderXDependCheck_APL()
%    Check the dependences for spyderX via PsychHID equiped with bulk transfer
%    argout:
%    status  a double scale: 0,1,2 for spyderX with PsychHID, unsupported version of PsychHID, and wrong driver for spyderX, respectively
%
%    written by Yang Zhang
%    2022-12-22

persistent spyderXDependPsychHID_APL

if isempty(spyderXDependPsychHID_APL)
    status = 0;

    % Check PsychHID version
    v = PsychHID('Version');

    if v.build < 638479169 % mac 631740375/638479169 win 602983213/638515007 linux 603172579/640684315
        status = 1;

        spyderXDependPsychHID_APL = status;
        return
    end

    % Check spyderX driver
    if ~status
        try
            spyderXn('initial'); % to save the time
        catch
            % wrong driver or not spyderX
            status = 2;
        end
    end

     spyderXDependPsychHID_APL = status;
else
    status = spyderXDependPsychHID_APL;
end





