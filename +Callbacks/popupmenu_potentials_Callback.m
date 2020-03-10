function popupmenu_potentials_Callback(menu_obj, ~, handles)
    handles.tglbtn_draw.Value = 0;
    handles.tglbtn_samples.Value = 0;
    
    potential = menu_obj.String{menu_obj.Value};    
    table_obj = handles.uitable_parameters;
    qsp = handles.qs_parameters;
    
    row = find(cellfun(@(x) isequal(x, '  pot'), table_obj.Data(:,3)), 1, 'last');
    
    if ~isequal(potential, 'Choose Potential')
        potential = lower(potential);
        potential(potential == ' ') = '_';
        potential = ['@Potentials.', potential];
        
        table_obj.Data{row, 2} = potential;
        potential = str2func(potential);
        qsp.pot = potential;
        
        x = qsp.x;
        line_obj = handles.line_potential;
        line_obj.XData = x;
        
        UIFunctions.drawPotential(qsp, line_obj, handles);        
    end
end