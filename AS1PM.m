candidates = [0,1,2];
weights = [0.45, 0.45, 0.10];

grid = [];

count_0 = 0;
count_1 = 0;
count_2 = 0;
RANDOM = logical(input("Random search or not (press 0 or 1): "));

ROWS = 100;
COLS= 100;
H = input("Insert value for H: ");

for i = 1:ROWS
row = randsample(candidates, COLS, true, weights);
count_0 = count_0 + sum(row == 0);
count_1 = count_1 + sum(row == 1);
count_2 = count_2 + sum(row == 2);
disp(row)
grid(i, :) = row;
end

h=imagesc(grid);

% set the color map to display 0s as black, 1s as red, and 2s as green
colormap([1 0 0; 0 1 0;0 0 0]);

% add a colorbar to show the mapping of values to colors
colorbar;
disp(['number of reds: ', num2str(count_0)]);
disp(['number of blue: ', num2str(count_1)]);
disp(['number of empty: ', num2str(count_2)]);

happy_array=[];
for i = 1:ROWS
    for j = 1:COLS

        happy_array(i, j) = false;
    end
end


counter =0;
results_dict = struct('Random', [], 'iterations', [], 'H', []);
while true
    
    if mod(counter, 1000) == 0 % every x iterations, show the grid
        disp(['iteration # ', num2str(counter)]);
    end
    % for each row and column
    for i = 1:ROWS
        for j = 1:COLS
            if grid(i,j) ~= 2 % if the cell is happy, skip it
                count_same_race = 0; % counter for counting number of same race neighbors
                % conditions if the cell is on the edge of the grid
                if i==1 && j==1
                    count_same_race = count_same_race+count_near_cells(i, j, ROWS, COLS, grid);
                elseif i==1

                    count_same_race = count_same_race+count_near_cells_y(i, j, ROWS, COLS, grid);
                elseif j==1
                    count_same_race = count_same_race+count_near_cells_x(i, j, ROWS, COLS, grid);
                else

                    if grid(i,j) == grid(i-1,j)
                        count_same_race = count_same_race + 1;
                    end
                    if grid(i,j) == grid(i,j-1)
                        count_same_race = count_same_race + 1;
                    end
                    if grid(i,j) == grid(i-1,j-1)
                        count_same_race = count_same_race + 1;
                    end
                    if grid(i,j) == grid(mod(i,ROWS)+1,j)
                        count_same_race = count_same_race + 1;
                    end
                    if grid(i,j) == grid(i,mod(j,COLS)+1)
                        count_same_race = count_same_race + 1;
                    end
                    if grid(i,j) == grid(mod(i,ROWS)+1,mod(j,COLS)+1)
                        count_same_race = count_same_race + 1;
                    end
                    if grid(i,j) == grid(mod(i,ROWS)+1,j-1)
                        count_same_race = count_same_race + 1;
                    end
                    if grid(i,j) == grid(i-1,mod(j,COLS)+1)
                        count_same_race = count_same_race + 1;
                    end
                end
                % check if the cell is happy
                happy_array(i,j) = count_same_race >= H; % updating happy matrix
            end
        end
    end
    happy_agents = sum(happy_array & (grid ~= 2), 'all');

    if (happy_agents == (count_0 + count_1))
        fprintf('iterations needed to converge: %d\n', counter);
        results_dict.iterations(end+1) = counter;
        results_dict.H(end+1) = H;
        results_dict.Random(end+1) = RANDOM;
        saveas(gcf, sprintf('results/iterations_%d_H_%d_random_%d.png', counter, H, RANDOM));
        break;
    end
    
    % loop for moving the unhappy agents
    for i = 1:ROWS
        for j = 1:COLS
            % perform actions only if the cell is unhappy and not empty
            if (grid(i,j) ~= 2 && ~happy_array(i,j))
                % random method. Moving randomly until finding an empty cell
                if (RANDOM)
                    direction_axis_0 = randi([-1, 1]);
                    direction_axis_1 = randi([-1, 1]);
                    pos_x = i + direction_axis_0;
                    pos_y = j + direction_axis_1;
                    
                    % conditions for checking if the new position is out of range
                    [pos_x, pos_y] = check_boundaries(pos_x, pos_y, ROWS, COLS);
                    
                    % loop to check if the new position is empty
                    while (grid(pos_x, pos_y) ~= 2)
                        direction_axis_0 = randi([-1, 1]);
                        direction_axis_1 = randi([-1, 1]);
                        pos_x = pos_x + direction_axis_0;
                        pos_y = pos_y + direction_axis_1;
                        
                        % conditions for checking if the new position is out of range
                        [pos_x, pos_y] = check_boundaries(pos_x, pos_y, ROWS, COLS);
                    end
                else
                    pos_x = i;
                    pos_y = j;
                    radius = 1;
                    flag = false;
                    
                    while ~flag
                        for x = pos_x - radius : pos_x + radius
                            for y = pos_y - radius : pos_y + radius
                                x_mod = mod(x - 1, ROWS) + 1;
                                y_mod = mod(y - 1, COLS) + 1;
                                if (grid(x_mod, y_mod) == 2)
                                    flag = true;
                                    pos_x = x_mod;
                                    pos_y = y_mod;
                                    break; % exit if the empty cell is found
                                end
                            end
                            if flag
                                break;
                            end
                        end
                        radius = radius + 1; % increasing the radius
                        
                    end

                end
                
                % moving the agent and updating the old position with an empty cell
                tmp = grid(i,j);
                grid(i,j) = 2;
                grid(pos_x,pos_y) = tmp;
            end
        end
    end
    set(h, 'CData', grid);
    drawnow;
    counter = counter + 1;

end

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
function [count] = count_near_cells_y(i, j, ROWS, COLS, grid)
    count =0;
    if grid(i,j) == grid(ROWS,j)
        count = count + 1;
    end
    if grid(i,j) == grid(i,j-1)
        count = count + 1;
    end
    if grid(i,j) == grid(ROWS,j-1)
        count = count + 1;
    end
    if grid(i,j) == grid(mod(i,ROWS)+1,j)
        count = count + 1;
    end
    if grid(i,j) == grid(i,mod(j,COLS)+1)
        count = count + 1;
    end
    if grid(i,j) == grid(mod(i,ROWS)+1,mod(j,COLS)+1)
        count = count + 1;
    end
    if grid(i,j) == grid(mod(i,ROWS)+1,j-1)
        count = count + 1;
    end
    if grid(i,j) == grid(ROWS,mod(j,COLS)+1)
        count = count + 1;
    end
end
function [count] = count_near_cells_x(i, j, ROWS, COLS, grid)
    count =0;
    if grid(i,j) == grid(i-1,j)
        count = count + 1;
    end
    if grid(i,j) == grid(i,COLS)
        count = count + 1;
    end
    if grid(i,j) == grid(i-1,COLS)
        count = count + 1;
    end
    if grid(i,j) == grid(mod(i,ROWS)+1,j)
        count = count + 1;
    end
    if grid(i,j) == grid(i,mod(j,COLS)+1)
        count = count + 1;
    end
    if grid(i,j) == grid(mod(i,ROWS)+1,mod(j,COLS)+1)
        count = count + 1;
    end
    if grid(i,j) == grid(mod(i,ROWS)+1,COLS)
        count = count + 1;
    end
    if grid(i,j) == grid(i-1,mod(j,COLS)+1)
        count = count + 1;
    end
end
function [count] = count_near_cells(i, j, ROWS, COLS, grid)
    count=0;
    if grid(i,j) == grid(ROWS,j)
        count = count + 1;
    end
    if grid(i,j) == grid(i,COLS)
        count = count + 1;
    end
    if grid(i,j) == grid(ROWS,COLS)
        count = count + 1;
    end
    if grid(i,j) == grid(mod(i,ROWS)+1,j)
        count = count + 1;
    end
    if grid(i,j) == grid(i,mod(j,COLS)+1)
        count = count + 1;
    end
    if grid(i,j) == grid(mod(i,ROWS)+1,mod(j,COLS)+1)
        count = count + 1;
    end
    if grid(i,j) == grid(mod(i,ROWS)+1,COLS)
        count = count + 1;
    end
    if grid(i,j) == grid(ROWS,mod(j,COLS)+1)
        count = count + 1;
    end
end
