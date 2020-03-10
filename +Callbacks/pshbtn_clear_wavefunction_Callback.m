function pshbtn_clear_wavefunction_Callback(~, ~, handles)
    
    handles.tglbtn_draw.Value = 0;
    handles.tglbtn_samples.Value = 0;

    qsp = handles.qs_parameters;
    qsp.wavefunction = [];
    
    axes_obj = handles.axes_setup;
    axes(axes_obj);
    
    yyaxis(axes_obj, 'right');
    UIFunctions.resetLine(handles.line_wavefunction);
    axes_obj.YLim = [0 1];
    yyaxis(axes_obj, 'left');
end