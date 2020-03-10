function line_obj = drawPotential(qsp, line_obj, handles)
    line_obj.XData = qsp.x;

    if isequal(qsp.pot, @Potentials.drawn_potential)
        handles.line_drawn_potential.Visible = 'on';
        if isempty(handles.tglbtn_draw.UserData)
            warning('Haven''t drawn a potential yet!');
        end
        line_obj.YData = qsp.pot(qsp.x, handles.line_drawn_potential);
    else
        handles.line_drawn_potential.Visible = 'off';
        line_obj.YData = real(qsp.pot(qsp.x));
    end
end