function tglbtn_stop_Callback(btn_obj, ~, handles)

handles.text_progress.String = 'Progress: 0%';

ispaused = handles.tglbtn_pause.Value;
if ispaused
    qsp = handles.qs_parameters;
    qsp.wavefunction_time = [];
    
    table_obj = handles.uitable_parameters;
    row = find(cellfun(@(x) isequal(x, ' tmax'), table_obj.Data(:,3)), 1, 'last');
    tmax = str2double(table_obj.Data{row, 2});
    qsp.tmax = tmax;
    handles.pshbtn_start.UserData = [];
    
    btn_obj.Enable = 'off';
    btn_obj.Value = 0;
    handles.tglbtn_pause.Value = 0;
    
    UIFunctions.resetButtons(handles, false);
end