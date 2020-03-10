function resetButtons(handles, results)

handles.pshbtn_start.Enable = 'on';
handles.tglbtn_pause.Enable = 'off';
handles.tglbtn_stop.Enable = 'off';

handles.uitable_parameters.Enable = 'on';
handles.popupmenu_potentials.Enable = 'on';
handles.popupmenu_fields.Enable = 'on';
handles.tglbtn_samples.Enable = 'on';

arrayfun(@(x) set(x, 'Enable', 'on'), handles.uipanel_wavefunction.Children);
arrayfun(@(x) set(x, 'Enable', 'on'), handles.uipanel_potential.Children);

if nargin < 2
    results = false;
end
if results
    handles.pshbtn_spectrum.Enable = 'on';
    handles.pshbtn_modes.Enable = 'on';
    handles.pshbtn_export.Enable = 'on';
    handles.pshbtn_time.Enable = 'on';
end