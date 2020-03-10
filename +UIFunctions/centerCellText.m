% CENTERCELLTEXT  More or less centers Monospaced text in a uitable cell.
%
%   txt = CENTERCELLTEXT(text, table, col) adds spaces to the beginning of
%   text, based on the width of the given column, col, in the given table,
%   table.  This only works for a table where the FontName is 'Monospaced',
%   for other fonts, you'll have to figure out how to change the
%   total_chars variable so that it adds the right number of leading
%   spaces.
function cell_text = centerCellText(text, table, col)

    if ~isa(table, 'matlab.ui.control.Table')
        error('centerCellText:InvalidInput', 'Need to pass in a proper MATLAB uitable.');
    end
    
    if isequal(table.ColumnWidth, 'auto')
        error('centerCellText:InvalidInput', 'Table columns must not have automatic widths.');
    end

    if nargin < 3
        col = 2;
    end
    
    units = table.Units;
    if isequal(units, 'pixels')
        total_pixels = table.ColumnWidth{col};
    else
        table.Units = 'pixels';
        total_pixels = table.ColumnWidth{col};
        table.Units = units;
    end
    
    font_units = table.FontUnits;
    if isequal(font_units, 'points')
        total_chars = round(total_pixels / (table.FontSize - 1));
    else
        table.FontUnits = 'points';
        total_chars = round(total_pixels / (table.FontSize - 1));
        table.FontUnits = font_units;
    end
    
    idx = find(text ~= ' ', 1);
    text(1:(idx-1)) = [];
    
    idx = find(text ~= ' ', 1, 'last');
    text((idx+1):end) = [];
    
    data_length = length(text);
    
    if data_length < total_chars
        cell_text = [repmat(' ', 1, ... 
            round((total_chars -  data_length) / 2) - 1), text];
    else
        cell_text = text;
    end
end