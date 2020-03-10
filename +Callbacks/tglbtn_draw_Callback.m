function tglbtn_draw_Callback(btn_obj, ~, handles)

    toggled = btn_obj.Value;
    
    if toggled
        handles.tglbtn_samples.Value = 0;
    end
    
    menu_obj = handles.popupmenu_potentials;
    menu_obj.Value = find( ...
        cellfun(@(x) isequal(x, 'Drawn Potential'), menu_obj.String), 1);
    
    table_obj = handles.uitable_parameters;
    row = find(cellfun(@(x) isequal(x, '  pot'), table_obj.Data(:,3)), 1, 'last');
    table_obj.Data{row, 2} = '@Potentials.drawn_potential';
    
    handles.qs_parameters.pot = @Potentials.drawn_potential;
    
end