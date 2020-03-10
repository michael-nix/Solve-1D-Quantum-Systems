function edit_vmax_Callback(edit_obj, ~, handles)
    axes_obj = handles.axes_setup;
    msgid = 'EditCallback';
    
    vmax = str2double(edit_obj.String);
    
    try
        UIFunctions.checkCommonErrors(vmax, msgid);
        axes_obj.YLim(2) = vmax;
        
    catch exception
        switch exception.identifier
            case 'EditCallback:InvalidInput'
                warning(exception.message);
                edit_obj.String = axes_obj.YLim(2);
                
            case 'MATLAB:hg:shaped_arrays:LimitsWithInfsPredicate'
                warning('Maximum value can''t be the same or lower than the minimum value!');
                edit_obj.String = axes_obj.YLim(2);
                
            otherwise
                disp(['Caught Exception: ', exception.identifier]);
        end
    end
end