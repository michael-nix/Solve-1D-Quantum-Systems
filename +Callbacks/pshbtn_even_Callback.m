function pshbtn_even_Callback(~, ~, handles)
    import UIFunctions.*;
    import CommonFunctions.*;
    msgid = 'PshbtnCallback';

    handles.tglbtn_draw.Value = 0;
    handles.tglbtn_samples.Value = 0;
    
    qsp = handles.qs_parameters;
    x = qsp.x;
    wavefunction = qsp.wavefunction;
    if isempty(wavefunction) || (length(x) ~= length(wavefunction))
        wavefunction = zeros(size(x));
    end

    try
        x0 = str2double(handles.edit_position.String);
        if isnan(x0) && isempty(handles.edit_position.String)
            x0 = 0;
        else
            checkCommonErrors(x0, msgid);
        end

        p0 = str2double(handles.edit_momentum.String);
        if isnan(p0) && isempty(handles.edit_momentum.String)
            p0 = 0;
        else
            checkCommonErrors(p0, msgid);
        end
        
        sig = str2double(handles.edit_width.String);
        if isnan(sig) && isempty(handles.edit_width.String)
            sig = sqrt(2*log(2));
        else
            checkCommonErrors(sig, msgid);
        end
        
        if sig < 0.25
            sig = 0.25;
            handles.edit_width.String = '0.25';
        end
        
        wavefunction = wavefunction + initeven(x, x0, p0, sig/sqrt(2*log(2)));
        qsp.wavefunction = wavefunction;

    catch exception
        switch exception.identifier
            case 'PshbtnCallback:InvalidInput'
                warning(exception.message);
            otherwise
                disp(['Caught Exception: ', exception.identifier]);
        end

        handles.edit_position.String = [];
        handles.edit_momentum.String = [];
        handles.edit_width.String = [];
    end
    
    axes_obj = handles.axes_setup;

    yyaxis(axes_obj, 'right');
    axes_obj.YLimMode = 'auto';
    
    line_obj = handles.line_wavefunction;
    line_obj.XData = x;
    line_obj.YData = abs(wavefunction);
    
    yyaxis(axes_obj, 'left');
end