function pshbtn_start_Callback(~, ~, handles)
import CommonFunctions.*;
import UIFunctions.*;

setButtons(handles);

axes_obj = handles.axes_simulate;
% Validate QSParameters object ---
qsp = handles.qs_parameters;

x = qsp.x;
invalid_x = isempty(qsp.x) || ~isnumeric(qsp.x) || ~isvector(qsp.x) || ...
    ~isreal(x) || any(~isfinite(x));
if invalid_x
    error('Callback:InvalidInput', ['Domain of QSParemeter object, x, must be a numeric vector.', newline]);
end

try
    if isequal(qsp.pot, @Potentials.electric_potential) && any(x == 0)
        error(['If you run this simulation, you''ll be dividing by zero, and you''re gonna get nonsense results.  Try adjusting parameters; spatial resolution or boundaries.', newline]);
    end
catch exception
    warning(exception.message);
    
    resetButtons(handles, false);
    return;
end

if isempty(qsp.wavefunction)
    qsp.wavefunction = initeven(x, 2) + initodd(x);
    warning(['No wavefunction created; using default.', newline]);
    
    yyaxis(handles.axes_setup, 'right');
    handles.axes_setup.YLimMode = 'auto';
    
    line_obj = handles.line_wavefunction;
    line_obj.XData = x;
    line_obj.YData = abs(qsp.wavefunction);
    yyaxis(handles.axes_setup, 'left');
end

dx = qsp.dx;
invalid_dx = isempty(dx) || ~isnumeric(dx) || ~isscalar(dx) || ...
    ~isreal(dx) || ~isfinite(dx);
if invalid_dx
    error('Callback:InvalidInput', ['QSParameter time step, dx, must be a real, scalar, number.', newline]);
end

dt = qsp.dt;
invalid_dt = isempty(dt) || ~isnumeric(dt) || ~isscalar(dt) || ...
    ~isreal(dt) || ~isfinite(dt);
if invalid_dt
    error('Callback:InvalidInput', ['QSParameter time step, dt, must be a real, scalar, number.', newline]);
end
[willalias, dt_check] = QuantumSolvers.willalias(qsp.wavefunction, qsp);
if willalias
    warning(['Recommend dt is set to less than ''', num2str(dt_check), ''' so that there isn''t any aliasing when you run your simulation.', newline]);
end
pmax = sqrt(2/dt*qsp.m);

pot = qsp.pot;
invalid_pot = false;
if ~isa(pot, 'function_handle')
    invalid_pot = isempty(pot) || ~isnumeric(pot) || ~isvector(pot) || any(~isfinite(pot));
end
if invalid_pot
    error('Callback:InvalidInput', ['Potentials need to be function handles or numeric, finite vectors.', newline]);
end

mag = qsp.mag;
invalid_mag = false;
if ~isempty(mag) && ~isa(mag, 'function_handle')
    invalid_mag = ~isnumeric(mag) || ~isvector(mag) || any(~isfinie(mag));
end
if invalid_mag
    error('Callback:InvalidInput', ['Fields need to be function handles or numeric, finite vectors.', newline]);
end

handles.line_wavefunction_pos.Visible = 'off';
handles.line_wavefunction_mom.Visible = 'off';

handles.line_potential_sim.XData = handles.line_potential.XData;
handles.line_potential_sim.YData = handles.line_potential.YData;
plotpotential = handles.chkbox_potential.Value;
if plotpotential
    handles.line_potential_sim.Visible = 'on';
else
    handles.line_potential_sim.Visible = 'off';
end

samples = qsp.samples;
if isempty(samples)
    samples = floor(qsp.n ./ ((1:5) + 1));
end

solver = QuantumSolver1D(qsp);

waspaused = handles.tglbtn_pause.Value;
if isempty(handles.pshbtn_start.UserData)
    tmax = qsp.tmax;
else
    tmax = handles.pshbtn_start.UserData;
end

if ~waspaused && tmax ~= 2^nextpow2(tmax)
    warning(['If tmax isn''t a power of two you''ll get weird results due to zero-padding before the FFT is calculated to give the spectrum.', newline]);
end

if waspaused
    ut0 = handles.line_wavefunction_pos.UserData(:,1);
    uts = qsp.wavefunction_time;
    handles.tglbtn_pause.Value = 0;
else
    uts = zeros(1, tmax);
    ut0 = qsp.wavefunction;
    text = handles.text_progress.String;
    handles.text_progress.String = [text(1:10), '... 0%'];
end

nospin = isempty(qsp.mag);
if ~nospin
    if ~waspaused
        ut1 = zeros(size(ut0));
    else
        ut1 = handles.line_wavefunction_pos.UserData(:,2);
    end
end

progress_counter = round(0.05*length(uts));

idx = length(uts) - tmax;

for t = 1:tmax
    uts(idx + t) = sum(ut0(samples));
    
    if nospin
        ut0 = solver.solve(ut0);
    else
        ut0 = solver.solve(ut0, ut1);
        ut1 = solver.solve(ut1, ut0);
    end
    
    if ~mod(t, 10)
        
        pause(0); % pause BRIEFLY to give time for handles to update.
        isstopped = handles.tglbtn_stop.Value;
        if isstopped
            qsp.wavefunction_time = [];
            handles.tglbtn_stop.Value = 0;
            handles.tglbtn_pause.Value = 0;
            
            resetButtons(handles, false);
            return;
        end
        
        ispaused = handles.tglbtn_pause.Value;
        if ispaused
            handles.tglbtn_pause.Enable = 'off';
            handles.pshbtn_start.Enable = 'on';
            
            handles.pshbtn_start.UserData = tmax - t;
            qsp.wavefunction_time = uts;
            
            if nospin
                handles.line_wavefunction_pos.UserData = ut0;
            else
                handles.line_wavefunction_pos.UserData = [ut0, ut1];
            end
            return;
        end
        
        plot_position = handles.chkbox_position.Value;
        plot_momentum = handles.chkbox_momentum.Value;
        plot_request = plot_position || plot_momentum;
        
        if plot_request
            if plot_position
                plotpotential = handles.chkbox_potential.Value;
                if plotpotential
                    handles.line_potential_sim.Visible = 'on';
                else
                    handles.line_potential_sim.Visible = 'off';
                end
                
                handles.line_wavefunction_mom.Visible = 'off';
                YData = ut0;
                XData = x;
                line_obj = handles.line_wavefunction_pos;
                
                yyaxis(axes_obj, 'right');
                axes_obj.XLim = [x(1), x(end)];
                xlabel(axes_obj, 'Position');
                
                plot_fcn = handles.btngrp_position.SelectedObject.String;
                
            elseif plot_momentum
                handles.line_wavefunction_pos.Visible = 'off';
                handles.line_potential_sim.Visible = 'off';
                [YData, XData] = getfft(ut0, dx);
                line_obj = handles.line_wavefunction_mom;
                
                yyaxis(axes_obj, 'right');
                axes_obj.XLim = [-pmax, pmax];
                xlabel(axes_obj, 'Momentum');
                
                plot_fcn = handles.btngrp_momentum.SelectedObject.String;
            end
            % radio button strings have a ' ' as first character, which 
            % would break feval since we're getting the function as the
            % string for the radio button.
            plot_fcn(1) = [];
            line_obj.YData = feval(plot_fcn, YData);
            line_obj.XData = XData;
            line_obj.Visible = 'on';
            
            if plot_momentum
                yyaxis(axes_obj, 'left');
            end
            drawnow;
        end
    end
    
    if ~mod(idx + t, progress_counter)
        text = handles.text_progress.String;
        handles.text_progress.String = [text(1:14), num2str(round((idx + t)/length(uts)*100)), '%'];
    end
end
resetButtons(handles, true);

handles.text_progress.String = 'Progress: ... done!';
handles.pshbtn_start.UserData = [];

qsr = QSResults(uts, dt, qsp);
handles.qs_results = handles.qs_results.copy(qsr);

nmodes = length(qsr.mode_energies);
mode_nums = mat2cell(num2str((1:nmodes)'), ones(nmodes, 1));
mode_energies = mat2cell(num2str(qsr.mode_energies'), ones(nmodes, 1));

table_obj = handles.uitable_energies;
table_obj.Data = cell(nmodes, 2);

table_obj.Data(:,1) = cellfun(@(txt) centerCellText(txt, table_obj, 1), mode_nums, 'UniformOutput', false);
table_obj.Data(:,2) = cellfun(@(txt) centerCellText(txt, table_obj, 2), mode_energies, 'UniformOutput', false);