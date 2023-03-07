function [count] = count_near_cells_y(i, j, ROWS, COLS, grid_array)
    count =0;
    if grid_array(i,j) == grid_array(ROWS,j)
        count = count + 1;
    end
    if grid_array(i,j) == grid_array(i,j-1)
        count = count + 1;
    end
    if grid_array(i,j) == grid_array(ROWS,j-1)
        count = count + 1;
    end
    if grid_array(i,j) == grid_array(mod(i,ROWS)+1,j)
        count = count + 1;
    end
    if grid_array(i,j) == grid_array(i,mod(j,COLS)+1)
        count = count + 1;
    end
    if grid_array(i,j) == grid_array(mod(i,ROWS)+1,mod(j,COLS)+1)
        count = count + 1;
    end
    if grid_array(i,j) == grid_array(mod(i,ROWS)+1,j-1)
        count = count + 1;
    end
    if grid_array(i,j) == grid_array(ROWS,mod(j,COLS)+1)
        count = count + 1;
    end
end