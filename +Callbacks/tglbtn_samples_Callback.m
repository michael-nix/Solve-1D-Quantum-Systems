function tglbtn_samples_Callback(btn_obj, ~, handles)

    toggled = btn_obj.Value;
    
    if toggled
        handles.tglbtn_draw.Value = 0;
        
        handles.qs_parameters.samples = [];
        
        handles.line_samples.XData = 0;
        handles.line_samples.YData = 0;
        handles.line_samples.Visible = 'off';
        
        btn_obj.UserData = [];
    end
end