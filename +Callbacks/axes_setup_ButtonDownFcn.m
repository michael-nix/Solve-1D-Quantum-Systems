function axes_setup_ButtonDownFcn(axes_obj, hit_obj, handles)    
    
    isdrawsamples = handles.tglbtn_samples.Value;
    isdrawpotential = handles.tglbtn_draw.Value;

    if ~(isdrawsamples || isdrawpotential)
        return;
    end
    
    x = hit_obj.IntersectionPoint(1);
    y = hit_obj.IntersectionPoint(2);
    
    qsp = handles.qs_parameters;
    
    yyaxis(axes_obj, 'left');
    
    ymin = axes_obj.YLim(1);
    ymax = axes_obj.YLim(2);
    if y > ymax
        return;
    elseif y < ymin
        y = ymin;
    end
    
    xmin = axes_obj.XLim(1);
    xmax = axes_obj.XLim(2);
    if x < xmin || x > xmax
        return;
    end
    
    if isdrawsamples
        yyaxis(axes_obj, 'right');
        line_obj = handles.line_samples;
        btn_obj = handles.tglbtn_samples;
        marker = 'x';
        
        y_dist = (y - ymin) / (ymax - ymin);
        ymin = axes_obj.YLim(1);
        ymax = axes_obj.YLim(2);
        y = y_dist * (ymax - ymin) + ymin;
        
    elseif isdrawpotential
        line_obj = handles.line_drawn_potential;
        btn_obj = handles.tglbtn_draw;
        marker = 'o';
    end
    line_obj.Visible = 'on';
    
    isnewline = isempty(btn_obj.UserData);
    if isnewline
        btn_obj.UserData = 1;
        
        line_obj.XData = x;
        line_obj.YData = y;
        
        line_obj.Color = 'k';
        line_obj.Marker = marker;
        line_obj.LineStyle = 'none';
    else
        line_obj.XData(end + 1) = x;
        line_obj.YData(end + 1) = y;
    end
    
    if isdrawpotential
        handles.line_potential.YData = ...
            Potentials.drawn_potential(qsp.x, line_obj);
    elseif isdrawsamples        
        x_dist = (line_obj.XData - xmin) / (xmax - xmin);
        qsp.samples = round(qsp.n * x_dist);
    end
    
    yyaxis(axes_obj, 'left');
end