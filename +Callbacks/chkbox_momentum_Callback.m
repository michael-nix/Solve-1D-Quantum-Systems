function chkbox_momentum_Callback(chkbox_obj, ~, handles)

buttons = handles.btngrp_momentum.Children;

ischecked = chkbox_obj.Value;
if ischecked
    for i = 1:length(buttons)
        buttons(i).Enable = 'on';
    end
    handles.chkbox_position.Value = 0;
    
    buttons = handles.btngrp_position.Children;
    for i = 1:length(buttons)
        buttons(i).Enable = 'off';
    end
    
    handles.chkbox_potential.Enable = 'off';
    handles.chkbox_potential.Value = 0;
else
    for i = 1:length(buttons)
        buttons(i).Enable = 'off';
    end
end