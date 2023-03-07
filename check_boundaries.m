function [pos_x, pos_y] = check_boundaries(pos_x, pos_y, ROWS, COLS)
    if (pos_x < 1)
        pos_x = ROWS;
    elseif (pos_x > ROWS)
        pos_x = 1;
    end
    
    if (pos_y < 1)
        pos_y = COLS;
    elseif (pos_y > COLS)
        pos_y = 1;
    end
end