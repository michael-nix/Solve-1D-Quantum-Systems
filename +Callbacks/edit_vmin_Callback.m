function edit_vmin_Callback(edit_obj, ~, handles)
    axes_obj = handles.axes_setup;
    msgid = 'EditCallback';
    
    vmin = str2double(edit_obj.String);
    
    try
        UIFunctions.checkCommonErrors(vmin, msgid);
        axes_obj.YLim(1) = vmin;
        
    catch exception
        switch exception.identifier
            case 'EditCallback:InvalidInput'
                warning(exception.message);
                edit_obj.String = axes_obj.YLim(1);
                
            case 'MATLAB:hg:shaped_arrays:LimitsWithInfsPredicate'
                warning('Maximum value can''t be the same or lower than the minimum value!');
                edit_obj.String = axes_obj.YLim(1);
            
            otherwise
                disp(['Caught Exception: ', exception.identifier]);
        end
    end
end