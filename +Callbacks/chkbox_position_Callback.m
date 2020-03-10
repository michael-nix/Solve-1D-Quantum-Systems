function chkbox_position_Callback(chkbox_obj, ~, handles)

buttons = handles.btngrp_position.Children;

ischecked = chkbox_obj.Value;
if ischecked
    for i = 1:length(buttons)
        buttons(i).Enable = 'on';
    end
    handles.chkbox_momentum.Value = 0;
    
    buttons = handles.btngrp_momentum.Children;
    for i = 1:length(buttons)
        buttons(i).Enable = 'off';
    end
    
    handles.chkbox_potential.Enable = 'on';
else
    for i = 1:length(buttons)
        buttons(i).Enable = 'off';
    end
    
    handles.chkbox_potential.Enable = 'off';
    handles.chkbox_potential.Value = 0;
end
