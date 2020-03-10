function uitable_parameters_CellEditCallback(table_obj, data_obj, handles)
    import UIFunctions.*;
    msgid = 'CellEditCallback';
    
    row = data_obj.Indices(1);
    col = data_obj.Indices(2);
    
    % center the data in the cell:
    table_obj.Data{row, col} = ...
        UIFunctions.centerCellText(data_obj.EditData, table_obj);
    
    qsp = handles.qs_parameters;
    axes_obj = handles.axes_setup;
    line_obj = handles.line_potential;
    
    qsp.wavefunction = [];
    resetLine(handles.line_wavefunction);
    
    try
        variable = table_obj.Data{row, 3};
        variable(variable == ' ') = [];
        switch variable
            
            case 'xmin'
                xmin = str2double(data_obj.EditData);
                checkCommonErrors(xmin, msgid);
                
                x = linspace(xmin, qsp.x(end), qsp.n).';
                qsp.x = x;
                qsp.dx = abs(x(2) - x(1));
                axes_obj.XLim(1) = xmin;
                
                drawPotential(qsp, line_obj, handles);
                
            case 'xmax'
                xmax = str2double(data_obj.EditData);
                checkCommonErrors(xmax, msgid);
                
                x = linspace(qsp.x(1), xmax, qsp.n).';
                qsp.x = x;
                qsp.dx = abs(x(2) - x(1));
                axes_obj.XLim(2) = xmax;
                
                drawPotential(qsp, line_obj, handles);
                
            case 'n'
                n = round(str2double(data_obj.EditData));
                checkCommonErrors(n, msgid);
                if n < 2
                    error('CellEditCallback:InvalidInput','Two or more grid points are required.');
                end
                
                samples = qsp.samples;
                samples = floor(samples*n/qsp.n);
                qsp.samples = samples;
                
                x = linspace(qsp.x(1), qsp.x(end), n).';
                qsp.x = x;
                qsp.n = n;
                
                drawPotential(qsp, line_obj, handles);
                
            case 'dt'
                dt = str2double(data_obj.EditData);
                checkCommonErrors(dt, msgid);
                if dt < 0
                    error('CellEditCallback:InvalidInput', 'Time step has to be greater than zero.');
                end
                
                qsp.dt = dt;
                
            case 'tmax'
                tmax = round(str2double(data_obj.EditData));
                checkCommonErrors(tmax, msgid);
                if tmax < 1
                    error('CellEditCallback:InvalidInput', 'Number of sample points has to be greater than zero.');
                end
                
                qsp.tmax = tmax;
                
            case 'm'
                m = str2double(data_obj.EditData);
                checkCommonErrors(m, msgid);
                if m <= 0
                    error('CellEditCallback:InvalidInput', 'Mass has to be greater than zero.');
                end
                
                qsp.m = m;
                
            case 'h_bar'
                h_bar = str2double(data_obj.EditData);
                checkCommonErrors(h_bar, msgid);
                if h_bar <= 0
                    error('CellEditCallback:InvalidInput', 'Planck''s constant has to be greater than zero.');
                end
                
                qsp.h_bar = h_bar;
                
            case 'pot'
                pot = data_obj.EditData;
                pot(pot == ' ') = [];
                pot = str2func(pot);
                pot(1); % if this fails, it throws a MATLAB:UndefinedFunction exception.
                
                qsp.pot = pot;
                drawPotential(qsp, line_obj, handles);
                
            case 'mag'
                mag = data_obj.EditData;
                mag(mag == ' ') = [];
                mag = str2func(mag);
                mag(1); % if this fails, it throws a MATLAB:UndefinedFunction exception.
                
                qsp.mag = mag;
        end
        
    catch exception
        table_obj.Data{row, col} = [];
        
        switch exception.identifier
            case 'MATLAB:UndefinedFunction'
                warning('Only valid function handles allowed.  Resetting edited parameter.');
                if ~isempty(data_obj.PreviousData)
                    table_obj.Data{row, col} = data_obj.PreviousData;
                end
            case 'CellEditCallback:InvalidInput'
                warning(exception.message);
                if ~isempty(data_obj.PreviousData)
                    table_obj.Data{row, col} = data_obj.PreviousData;
                end
            otherwise
                warning(['Caught Exception: ', exception.identifier]);
                table_obj.Data{row, col} = data_obj.PreviousData;
        end
    end
end