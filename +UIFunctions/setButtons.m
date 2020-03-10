function setButtons(handles)

handles.tglbtn_pause.Enable = 'on';
handles.tglbtn_stop.Enable = 'on';

handles.pshbtn_start.Enable = 'off';
handles.pshbtn_spectrum.Enable = 'off';
handles.pshbtn_modes.Enable = 'off';
handles.pshbtn_export.Enable = 'off';
handles.pshbtn_time.Enable = 'off';

handles.uitable_parameters.Enable = 'off';
handles.popupmenu_potentials.Enable = 'off';
handles.popupmenu_fields.Enable = 'off';
handles.tglbtn_samples.Enable = 'off';
handles.tglbtn_samples.Value = 0;

arrayfun(@(x) set(x, 'Enable', 'off'), handles.uipanel_wavefunction.Children);
arrayfun(@(x) set(x, 'Enable', 'off'), handles.uipanel_potential.Children);