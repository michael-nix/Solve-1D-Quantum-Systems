% MAINQUANTUMSOLVERUI   Run to launch the GUI to solve 1D quantum problems.
% 
% See also QUANTUMSOLVER1D, testQMSolver1D, QSParameters, QSResults.
function handles = MainQuantumSolverUI

app_name = 'Quantum Solver';
current_app = findall(0, 'Name', app_name);
app_open = ~isempty(current_app);

if app_open
    warning([app_name, ' application is already open!']);
    figure(current_app);
    if nargout == 1
        handles = current_app.UserData;
    end
    return;
end

warning('off', 'MATLAB:str2func:invalidFunctionName');

figure_main = figure( ...
    'Visible', 'off', ...
    'MenuBar', 'none', ...
    'Name', app_name, ...
    'Position', [100 300 610 655], ...
    'Resize', 'off');
handles.figure_main = figure_main;

uitabgroup_main = uitabgroup(figure_main);
handles.uitabgroup_main = uitabgroup_main;

%% SETUP tab: -------------------------------------------------------------
uitab_setup = uitab(uitabgroup_main, ...
    'Title', '     Setup     ');
handles.uitab_setup = uitab_setup;

axes_setup = axes(uitab_setup, ...
    'Units', 'pixels', ...
    'OuterPosition', [-25 175 635 475], ...
    'XLim', [-5 5], ...
    'XLimMode', 'manual', ...
    'YLim', [-15 15], ...
    'YLimMode', 'manual', ...
    'XGrid', 'on', ...
    'YGrid', 'on');
xlabel(axes_setup, 'x (a.u.)');
title(axes_setup, 'Potential, and Initial Wave Function');
yyaxis(axes_setup, 'right');
yyaxis(axes_setup, 'left');
handles.axes_setup = axes_setup;

% Make sure all table parameter descriptions and variable names make sense!
% If they don't match exactly what's defined in QSPARAMETERS, users are
% gonna have a bad time.
% 
% Also edit the CellEditCallback if you need to change them.
uitable_parameters = uitable(uitab_setup, ...
    'ColumnEditable', [false, true, false], ...
    'ColumnName', {}, ...
    'ColumnWidth', {175, 150, 40}, ...
    'Data', cell(9, 3), ...
    'FontName', 'monospaced', ...
    'Position', [10 15 367 164], ...
    'RowName', {});
parameter_descriptions = {
    '       Minimum X'; ...
    '       Maximum X'; ...
    ' Number of Grid Points'; ...
    '       Time Step'; ...
    ' Number of Time Steps'; ...
    '     Particle Mass'; ...
    ' Reduced Planck Constant'; ...
    '   Scalar Potential'; ...
    '     Magnetic Field'};
variable_names = {
    ' xmin', ...
    ' xmax', ...
    '    n', ...
    '   dt', ...
    ' tmax', ...
    '    m', ...
    'h_bar', ...
    '  pot', ...
    '  mag'};
uitable_parameters.Data(:,1) = parameter_descriptions;
uitable_parameters.Data(:,3) = variable_names;
handles.uitable_parameters = uitable_parameters;

text_parameters = uicontrol(uitab_setup, ...
    'FontSize', 8, ...
    'Style', 'Text', ...
    'String', 'Simulation Parameters:', ...
    'Position', [10 180 115 16]);
handles.text_parameters = text_parameters;

popupmenu_potentials = uicontrol(uitab_setup, ...
    'Position', [387 42 125 16], ...
    'Style','popupmenu');
potentials = what('Potentials');
potentials = potentials.m;
popupmenu_potentials.String = [{'Choose Potential'}; formatList(potentials)];
handles.popupmenu_potentials = popupmenu_potentials;

popupmenu_fields = uicontrol(uitab_setup, ...
    'Position', [387 21 125 16], ...
    'Style','popupmenu');
fields = what('Fields');
fields = fields.m;
popupmenu_fields.String = [{'Choose Field'}; formatList(fields)];
handles.popupmenu_fields = popupmenu_fields;

% --- Wavefunction Draw Panel ---------------------------------------------
uipanel_wavefunction = uipanel(uitab_setup, ...
    'Title', 'Initial Wave Function', ...
    'Units', 'Pixels', ...
    'Position', [387 65 125 121]);
handles.uipanel_wavefunction = uipanel_wavefunction;

text_position = uicontrol(uipanel_wavefunction, ...
    'Style', 'text', ...
    'String', 'position', ...
    'Position', [5 51 47 16]);
handles.text_position = text_position;

text_momentum = uicontrol(uipanel_wavefunction, ...
    'Style', 'text', ...
    'String', 'momentum', ...
    'Position', [5 29 60 16]);
handles.text_momentum = text_momentum;

text_width = uicontrol(uipanel_wavefunction, ...
    'Style', 'text', ...
    'String', 'half-width', ...
    'Position', [5 4 57 16]);
handles.text_width = text_width;

edit_position = uicontrol(uipanel_wavefunction, ...
    'Style', 'edit', ...
    'Position', [81 53 30 16]);
handles.edit_position = edit_position;

edit_momentum = uicontrol(uipanel_wavefunction, ...
    'Style', 'edit', ...
    'Position', [81 30 30 16]);
handles.edit_momentum = edit_momentum;

edit_width = uicontrol(uipanel_wavefunction, ...
    'Style', 'edit', ...
    'Position', [81 5 30 16]);
handles.edit_width = edit_width;

pshbtn_even = uicontrol(uipanel_wavefunction, ...
    'Style', 'pushbutton', ...
    'String', 'even', ...
    'Position', [4 75 35 25]);
handles.pshbtn_even = pshbtn_even;

pshbtn_odd = uicontrol(uipanel_wavefunction, ...
    'Style', 'pushbutton', ...
    'String', 'odd', ...
    'Position', [43 75 35 25]);
handles.pshbtn_odd = pshbtn_odd;

pshbtn_clear_wavefunction = uicontrol(uipanel_wavefunction, ...
    'Style', 'pushbutton', ...
    'String', '<html><font color = #666666>clear</font></html>', ...
    'Position', [83 75 35 25]);
handles.pshbtn_reset = pshbtn_clear_wavefunction;
% --- ---------------------------------------------------------------------

% --- Potential Drawing Panel ---------------------------------------------
uipanel_potential = uipanel(uitab_setup, ...
    'Title', 'Potential', ...
    'Units', 'Pixels', ...
    'Position', [520 46 77 139]);
handles.uipanel_potential = uipanel_potential;

tglbtn_draw = uicontrol(uipanel_potential, ...
    'Style', 'togglebutton', ...
    'String', 'Draw', ...
    'Position', [5 94 63 25]);
handles.tglbtn_draw = tglbtn_draw;

pshbtn_invert = uicontrol(uipanel_potential, ...
    'Style', 'pushbutton', ...
    'String', 'flip', ...
    'Position', [5 64 30 25]);
handles.pshbtn_invert = pshbtn_invert;

pshbtn_clear_potential = uicontrol(uipanel_potential, ...
    'Style', 'pushbutton', ...
    'String', '<html><font color = #666666>clear</font></html>', ...
    'Position', [38 64 30 25]);
handles.pshbtn_clear = pshbtn_clear_potential;

text_vmax = uicontrol(uipanel_potential, ...
    'Style', 'text', ...
    'String', 'Vmax', ...
    'Position', [5 35 30 16]);
handles.text_vmax = text_vmax;

text_vmin = uicontrol(uipanel_potential, ...
    'Style', 'text', ...
    'String', 'Vmin', ...
    'Position', [5 10 27 16]);
handles.text_vmin = text_vmin;

edit_vmax = uicontrol(uipanel_potential, ...
    'Style', 'edit', ...
    'String', axes_setup.YLim(2), ...
    'Position', [45 35 25 16]);
handles.edit_vmax = edit_vmax;

edit_vmin = uicontrol(uipanel_potential, ...
    'Style', 'edit', ...
    'String', axes_setup.YLim(1), ...
    'Position', [45 10 25 16]);
handles.edit_vmin = edit_vmin;
% --- ---------------------------------------------------------------------

tglbtn_samples = uicontrol(uitab_setup, ...
    'Style', 'togglebutton', ...
    'String', 'Draw Samples', ...
    'Position', [519 14 78 25]);
handles.tglbtn_samples = tglbtn_samples;

qs_parameters = QSParameters(linspace(-5, 5, 1024), 0.01, ...
    @Potentials.harmonic_potential);
handles.qs_parameters = qs_parameters;

parameter_data = {'-5'; '5'; '1024'; '0.01'; '16384'; '1'; '1'; ...
    '@Potentials.harmonic_potential'; 'function_handle.empty'};
parameter_data = ...
    cellfun(@(x)UIFunctions.centerCellText(x, uitable_parameters), ...
    parameter_data, 'UniformOutput', false);
uitable_parameters.Data(:,2) = parameter_data;

% creating initial lines and placeholders.
line_potential = line(axes_setup, ...
    qs_parameters.x, qs_parameters.pot(qs_parameters.x), 'LineWidth', 1.5);
line_potential.HitTest = 'off';
line_potential.Tag = 'Potential';

line_drawn_potential = line(axes_setup, 0, 0);
line_drawn_potential.Tag = 'Drawn Potential';
line_drawn_potential.HitTest = 'off';
line_drawn_potential.Visible = 'off';

% Getting the axes properly set up on the right side...
yyaxis(axes_setup, 'right');
axes_setup.XLimMode = 'manual';
axes_setup.YLim = [0 1];

line_wavefunction = line(axes_setup, 0, 0); % placeholder line for wavefunction
line_wavefunction.Color = 'r';
line_wavefunction.LineWidth = 1.5;
line_wavefunction.HitTest = 'off';
line_wavefunction.PickableParts = 'none';
line_wavefunction.Tag = 'Wavefunction';

line_samples = line(axes_setup, 0, 0); % placeholder line for sample points
line_samples.Tag = 'Samples';
line_samples.HitTest = 'off';
line_samples.Visible = 'off';
yyaxis(axes_setup, 'left');

handles.line_potential = line_potential;
handles.line_wavefunction = line_wavefunction;
handles.line_samples = line_samples;
handles.line_drawn_potential = line_drawn_potential;

% Declared at the end because 'handles' is a struct that gets passed by
% value into the callback when it's declared. If handles was an object
% that is a child of @handle, we could pass by reference and declare
% callbacks that need access to 'handles' whenever we create UI objects.
uitable_parameters.CellEditCallback = ...
    @(src, event) Callbacks.uitable_parameters_CellEditCallback(src, event, handles);
axes_setup.ButtonDownFcn = ...
    @(src, event) Callbacks.axes_setup_ButtonDownFcn(src, event, handles);
popupmenu_potentials.Callback = ...
    @(src, event) Callbacks.popupmenu_potentials_Callback(src, event, handles);
popupmenu_fields.Callback = ...
    @(src, event) Callbacks.popupmenu_fields_Callback(src, event, handles);
pshbtn_even.Callback = ...
    @(src, event) Callbacks.pshbtn_even_Callback(src, event, handles);
pshbtn_odd.Callback = ...
    @(src, event) Callbacks.pshbtn_odd_Callback(src, event, handles);
pshbtn_clear_wavefunction.Callback = ...
    @(src, event) Callbacks.pshbtn_clear_wavefunction_Callback(src, event, handles);
tglbtn_samples.Callback = ...
    @(src, event) Callbacks.tglbtn_samples_Callback(src, event, handles);
tglbtn_draw.Callback = ...
    @(src, event) Callbacks.tglbtn_draw_Callback(src, event, handles);
pshbtn_invert.Callback = ...
    @(src, event) Callbacks.pshbtn_invert_Callback(src, event, handles);
pshbtn_clear_potential.Callback = ...
    @(src, event) Callbacks.pshbtn_clear_potential_Callback(src, event, handles);
edit_vmax.Callback = ...
    @(src, event) Callbacks.edit_vmax_Callback(src, event, handles);
edit_vmin.Callback = ...
    @(src, event) Callbacks.edit_vmin_Callback(src, event, handles);
% ------------------------------------------------------------------------

%% SIMULATE tab: ----------------------------------------------------------
uitab_simulate = uitab(uitabgroup_main, ...
    'Title', '     Simulate     ');
handles.uitab_simulate = uitab_simulate;

axes_simulate = axes(uitab_simulate, ...
    'Units', 'pixels', ...
    'OuterPosition', [-25 175 635 475], ...
    'XLim', [-5 5], ...
    'XLimMode', 'manual', ...
    'YLim', [-15 15], ...
    'YLimMode', 'manual', ...
    'XGrid', 'on', ...
    'YGrid', 'on');
handles.axes_simulate = axes_simulate;
xlabel(axes_simulate, 'x (a.u.)');
title(axes_simulate, 'Position or Momentum Amplitude');

yyaxis(axes_simulate, 'right');
yyaxis(axes_simulate, 'left');

% Start / pause / stop etc., control:
uipanel_simulation_controls = uipanel(uitab_simulate, ...
    'Title', 'Simulation Controls', ...
    'Units', 'pixels', ...
    'Position', [49 121 178 75]);
handles.uipanel_simulation_controls = uipanel_simulation_controls;

pshbtn_start = uicontrol(uipanel_simulation_controls, ...
    'Style', 'pushbutton', ...
    'String', 'Start', ...
    'Position', [5 30 50 25]);
handles.pshbtn_start = pshbtn_start;

tglbtn_pause = uicontrol(uipanel_simulation_controls, ...
    'Style', 'togglebutton', ...
    'String', 'Pause', ...
    'Position', [60 30 50 25], ...
    'Enable', 'off');
handles.tglbtn_pause = tglbtn_pause;

tglbtn_stop = uicontrol(uipanel_simulation_controls, ...
    'Style', 'togglebutton', ...
    'String', 'Stop', ...
    'Position', [115 30 50 25], ...
    'Enable', 'off');
handles.tglbtn_stop = tglbtn_stop;

text_progress = uicontrol(uipanel_simulation_controls, ...
    'Style', 'text', ...
    'String', 'Progress: 0%', ...
    'Position', [5 4 100 20], ...
    'HorizontalAlignment', 'left');
handles.text_progress = text_progress;
% ---

% What to show on axes_simulate:
uipanel_plot_controls = uipanel(uitab_simulate, ...
    'Title', 'Wave Function Plot Controls', ...
    'Units', 'pixels', ...
    'Position', [234 31 165 165]);
handles.uipanel_plot_controls = uipanel_plot_controls;

chkbox_position = uicontrol(uipanel_plot_controls, ...
    'Style', 'checkbox', ...
    'Position', [5 125 70 20], ...
    'String', ' Position');
handles.chkbox_position = chkbox_position;

btngrp_position = uibuttongroup(uipanel_plot_controls, ...
    'Units', 'pixels', ...
    'Position', [10 40 60 80]);
handles.btngrp_position = btngrp_position;

rdobtn_pos_abs = uicontrol(btngrp_position, ...
    'Style', 'radiobutton', ...
    'Position', [5 55 55 20], ...
    'String', ' abs', ...
    'Enable', 'off');
handles.rdobtn_pos_abs = rdobtn_pos_abs;

rdobtn_pos_real = uicontrol(btngrp_position, ...
    'Style', 'radiobutton', ...
    'Position', [5 30 55 20], ...
    'String', ' real', ...
    'Enable', 'off');
handles.rdobtn_pos_real = rdobtn_pos_real;

rdobtn_pos_imag = uicontrol(btngrp_position, ...
    'Style', 'radiobutton', ...
    'Position', [5 5 55 20], ...
    'String', ' imag', ...
    'Enable', 'off');
handles.rdobtn_pos_imag = rdobtn_pos_imag;

chkbox_momentum = uicontrol(uipanel_plot_controls, ...
    'Style', 'checkbox', ...
    'Position', [80 125 75 20], ...
    'String', ' Momentum');
handles.chkbox_momentum = chkbox_momentum;

btngrp_momentum = uibuttongroup(uipanel_plot_controls, ...
    'Units', 'pixels', ...
    'Position', [85 40 60 80]);
handles.btngrp_momentum = btngrp_momentum;

rdobtn_mom_abs = uicontrol(btngrp_momentum, ...
    'Style', 'radiobutton', ...
    'Position', [5 55 55 20], ...
    'String', ' abs', ...
    'Enable', 'off');
handles.rdobtn_mom_abs = rdobtn_mom_abs;

rdobtn_mom_real = uicontrol(btngrp_momentum, ...
    'Style', 'radiobutton', ...
    'Position', [5 30 55 20], ...
    'String', ' real', ...
    'Enable', 'off');
handles.rdobtn_mom_real = rdobtn_mom_real;

rdobtn_mom_imag = uicontrol(btngrp_momentum, ...
    'Style', 'radiobutton', ...
    'Position', [5 5 55 20], ...
    'String', ' imag', ...
    'Enable', 'off');
handles.rdobtn_mom_imag = rdobtn_mom_imag;

chkbox_potential = uicontrol(uipanel_plot_controls, ...
    'Style', 'checkbox', ...
    'Position', [5 15 150 20], ...
    'String', ' Show Potential', ...
    'Enable', 'off');
handles.chkbox_potential = chkbox_potential;
% ---

uitable_energies = uitable(uitab_simulate, ...
    'ColumnEditable', [false, false], ...
    'ColumnName', {'Mode', 'Energy'}, ...
    'ColumnWidth', {50, 81}, ...
    'Data', cell(5, 2), ...
    'FontName', 'monospaced', ...
    'Position', [405 32 150 157], ...
    'RowName', {});
handles.uitable_energies = uitable_energies;
% ---

uipanel_results = uipanel(uitab_simulate, ...
    'Title', 'Results', ...
    'Units', 'pixels', ...
    'Position', [49 31 178 80]);
handles.uipanel_results = uipanel_results;

pshbtn_spectrum = uicontrol(uipanel_results, ...
    'Style', 'pushbutton', ...
    'String', 'Plot Spectrum', ...
    'Position', [5 35 80 25]);
handles.pshbtn_spectrum = pshbtn_spectrum;
pshbtn_spectrum.Enable = 'off';

pshbtn_modes = uicontrol(uipanel_results, ...
    'Style', 'pushbutton', ...
    'String', 'Plot Modes', ...
    'Position', [90 35 80 25]);
handles.pshbtn_modes = pshbtn_modes;
pshbtn_modes.Enable = 'off';

pshbtn_time = uicontrol(uipanel_results, ...
    'Style', 'pushbutton', ...
    'String', 'Plot Time Signal', ...
    'Position', [5 5 80 25]);
handles.pshbtn_time = pshbtn_time;
pshbtn_time.Enable = 'off';

pshbtn_export = uicontrol(uipanel_results, ...
    'Style', 'pushbutton', ...
    'String', 'Export Results', ...
    'Position', [90 5 80 25]);
handles.pshbtn_export = pshbtn_export;
pshbtn_export.Enable = 'off';
% ---

handles.qs_results = QSResults.empty;

line_potential_sim = line(axes_simulate, 0, 0); % placeholder line
line_potential_sim.LineWidth = 1.5;
line_potential_sim.HitTest = 'off';
line_potential_sim.PickableParts = 'none';
line_potential_sim.Tag = 'Simulated Potential';
handles.line_potential_sim = line_potential_sim;

yyaxis(axes_simulate, 'right');
line_wavefunction_pos = line(axes_simulate, 0, 0); % placeholder line
line_wavefunction_pos.Color = 'r';
line_wavefunction_pos.LineWidth = 1.5;
line_wavefunction_pos.HitTest = 'off';
line_wavefunction_pos.PickableParts = 'none';
line_wavefunction_pos.Tag = 'Simulated Wavefunction, Position';
handles.line_wavefunction_pos = line_wavefunction_pos;

line_wavefunction_mom = line(axes_simulate, 0, 0); % placeholder line
line_wavefunction_mom.Color = 'r';
line_wavefunction_mom.LineWidth = 1.5;
line_wavefunction_mom.HitTest = 'off';
line_wavefunction_mom.PickableParts = 'none';
line_wavefunction_mom.Tag = 'Simulated Wavefunction, Momentum';
handles.line_wavefunction_mom = line_wavefunction_mom;
yyaxis(axes_simulate, 'left');

chkbox_position.Callback = ...
    @(src, event) Callbacks.chkbox_position_Callback(src, event, handles);
chkbox_momentum.Callback = ...
    @(src, event) Callbacks.chkbox_momentum_Callback(src, event, handles);
pshbtn_start.Callback = ...
    @(src, event) Callbacks.pshbtn_start_Callback(src, event, handles);
tglbtn_stop.Callback = ...
    @(src, event) Callbacks.tglbtn_stop_Callback(src, event, handles);
pshbtn_spectrum.Callback = ...
    @(src, event) Callbacks.pshbtn_spectrum_Callback(src, event, handles);
pshbtn_modes.Callback = ...
    @(src, event) Callbacks.pshbtn_modes_Callback(src, event, handles);
pshbtn_time.Callback = ...
    @(src, event) Callbacks.pshbtn_time_Callback(src, event, handles);
pshbtn_export.Callback = ...
    @(src, event) Callbacks.pshbtn_export_Callback(src, event, handles);
% ------------------------------------------------------------------------
%%

drawnow;
figure_main.Visible = 'on';
figure_main.UserData = handles;

if nargout < 1
    clear handles;
end

    %% Supporting Functions: ----------------------------------------------
    function formatted = formatList(list)
        formatted = cellfun(@(x) strrep(x, '_', ' '), list, 'UniformOutput', false);
        formatted = cellfun(@(x) x(1:end-2), formatted, 'UniformOutput', false);
        formatted = cellfun(@(x) regexprep(lower(x),'(\<[a-z])','${upper($1)}'), formatted, 'UniformOutput', false);
    end
end