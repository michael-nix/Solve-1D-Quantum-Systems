function popupmenu_fields_Callback(menu_obj, ~, handles)

    field = menu_obj.String{menu_obj.Value};
    table_obj = handles.uitable_parameters;
    row = find(cellfun(@(x) isequal(x, '  mag'), table_obj.Data(:,3)), 1, 'last');
    
    if ~isequal(field, 'Choose Field')
        field = lower(field);
        field(field == ' ') = '_';
        field = ['@Fields.', field];
        
        table_obj.Data{row, 2} = field;
        table_obj.UserData.mag = str2func(field);
        
        handles.qs_parameters.mag = str2func(field);
    end
end