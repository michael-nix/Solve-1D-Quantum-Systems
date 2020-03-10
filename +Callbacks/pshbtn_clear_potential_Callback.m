function pshbtn_clear_potential_Callback(~, ~, handles)
    
    handles.tglbtn_draw.Value = 0;
    handles.tglbtn_draw.UserData = [];
    handles.tglbtn_samples.Value = 0;
    
    line_obj = handles.line_drawn_potential;
    UIFunctions.resetLine(line_obj);
    line_obj.Visible = 'off';
    
    qsp = handles.qs_parameters;
    x = qsp.x;
    
    potential = @Potentials.zero_potential;
    qsp.pot = potential;
        
    line_obj = handles.line_potential;
    line_obj.XData = x;
    line_obj.YData = zeros(size(x));
        
    menu_obj = handles.popupmenu_potentials;
    menu_obj.Value = find( ...
        cellfun(@(x) isequal(x, 'Zero Potential'), menu_obj.String), 1);
    
    table_obj = handles.uitable_parameters;
    row = find(cellfun(@(x) isequal(x, '  pot'), table_obj.Data(:,3)), 1, 'last');
    table_obj.Data{row, 2} = '@Potentials.zero_potential';

end