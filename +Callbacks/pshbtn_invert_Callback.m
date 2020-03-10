function pshbtn_invert_Callback(~, ~, handles)

    handles.tglbtn_draw.Value = 0;
    handles.tglbtn_samples.Value = 0;

    line_obj = handles.line_drawn_potential;
    line_obj.YData = -line_obj.YData;
    
    menu_obj = handles.popupmenu_potentials;
    chosen_potential = menu_obj.Value;
    
    isdrawnpotential = isequal('Drawn Potential', ...
        menu_obj.String{chosen_potential});
    if isdrawnpotential
        line_obj = handles.line_potential;
        line_obj.YData = -line_obj.YData;
    end
end