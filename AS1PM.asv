candidates = [0,1,2];
weights = [0.45, 0.45, 0.10];
ROWS = 100;
COLS= 100;
grid_array = zeros(ROWS, COLS);

count_0 = 0;
count_1 = 0;
count_2 = 0;
RANDOM = logical(input("Random search or not (press 1 or 0): "));


H = input("Insert value for H: ");
SAVE_PICTURE=logical(input("Save picture or not (press 1 or 0): "));
for i = 1:ROWS
row = randsample(candidates, COLS, true, weights);
count_0 = count_0 + sum(row == 0);
count_1 = count_1 + sum(row == 1);
count_2 = count_2 + sum(row == 2);
disp(row)
grid_array(i, :) = row;
end

h=imagesc(grid_array);


% set the color map to display 0s as black, 1s as red, and 2s as green
colormap([1 0 0; 0 1 0;0 0 0]);

% add a colorbar to show the mapping of values to colors
colorbar;
disp(['number of reds: ', num2str(count_0)]);
disp(['number of blue: ', num2str(count_1)]);
disp(['number of empty: ', num2str(count_2)]);

happy_array=zeros(ROWS, COLS);
for i = 1:ROWS
    for j = 1:COLS

        happy_array(i, j) = false;
    end
end


counter =1;
percentage_happiness =0.;
happy_array_over_iters=[];
results_dict = struct('Random', [], 'iterations', [], 'H', []);
count_previous_happines=0;
while true
    
    if mod(counter, 1000) == 0 % every x iterations, show the grid_array
        disp(['iteration # ', num2str(counter)]);
    end
    % for each row and column
    for i = 1:ROWS
        for j = 1:COLS
            if grid_array(i,j) ~= 2 % if the cell is happy, skip it
                count_same_race = 0; % counter for counting number of same race neighbors
                % conditions if the cell is on the edge of the grid_array
                if i==1 && j==1
                    count_same_race = count_same_race+count_near_cells(i, j, ROWS, COLS, grid_array);
                elseif i==1

                    count_same_race = count_same_race+count_near_cells_y(i, j, ROWS, COLS, grid_array);
                elseif j==1
                    count_same_race = count_same_race+count_near_cells_x(i, j, ROWS, COLS, grid_array);
                else

                    if grid_array(i,j) == grid_array(i-1,j)
                        count_same_race = count_same_race + 1;
                    end
                    if grid_array(i,j) == grid_array(i,j-1)
                        count_same_race = count_same_race + 1;
                    end
                    if grid_array(i,j) == grid_array(i-1,j-1)
                        count_same_race = count_same_race + 1;
                    end
                    if grid_array(i,j) == grid_array(mod(i,ROWS)+1,j)
                        count_same_race = count_same_race + 1;
                    end
                    if grid_array(i,j) == grid_array(i,mod(j,COLS)+1)
                        count_same_race = count_same_race + 1;
                    end
                    if grid_array(i,j) == grid_array(mod(i,ROWS)+1,mod(j,COLS)+1)
                        count_same_race = count_same_race + 1;
                    end
                    if grid_array(i,j) == grid_array(mod(i,ROWS)+1,j-1)
                        count_same_race = count_same_race + 1;
                    end
                    if grid_array(i,j) == grid_array(i-1,mod(j,COLS)+1)
                        count_same_race = count_same_race + 1;
                    end
                end
                % check if the cell is happy
                happy_array(i,j) = count_same_race >= H; % updating happy matrix
            end
        end
    end
    happy_agents = sum(happy_array & (grid_array ~= 2), 'all');
    percentage_happiness = (happy_agents/(count_0 + count_1))*100.;
    if( counter>1001)
        count_previous_happines=0;
        for iter=length(happy_array_over_iters)-1000:length(happy_array_over_iters)-1
            if(happy_array_over_iters(iter) >= percentage_happiness)
                count_previous_happines=count_previous_happines+1;
            end
        end
    end
    happy_array_over_iters(counter) = percentage_happiness;
    %fprintf("%.2f percentage of happiness: ", percentage_happiness);
    if(mod(counter, 400)==0 && percentage_happiness>60.)
        fprintf("percentage of happiness: %.2f\r\n", percentage_happiness);
    end
    if(count_previous_happines>950)
        disp("Applying early stopping");
        fprintf( "percentage of happiness: %.2f\r\n", percentage_happiness);
        if(SAVE_PICTURE)
            save_grid(results_dict, counter, RANDOM, H);
        end
        break;
    end
    if (happy_agents == (count_0 + count_1))
        if(SAVE_PICTURE)
            save_grid(results_dict, counter, RANDOM, H);
        end
        break;
    end
    
    % loop for moving the unhappy agents
    for i = 1:ROWS
        for j = 1:COLS
            % perform actions only if the cell is unhappy and not empty
            if (grid_array(i,j) ~= 2 && ~happy_array(i,j))
                % random method. Moving randomly until finding an empty cell
                if (RANDOM)
                    direction_axis_0 = randi([-1, 1]);
                    direction_axis_1 = randi([-1, 1]);
                    pos_x = i + direction_axis_0;
                    pos_y = j + direction_axis_1;
                    
                    % conditions for checking if the new position is out of range
                    [pos_x, pos_y] = check_boundaries(pos_x, pos_y, ROWS, COLS);
                    
                    % loop to check if the new position is empty
                    while (grid_array(pos_x, pos_y) ~= 2)
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
                                if (grid_array(x_mod, y_mod) == 2)
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
                tmp = grid_array(i,j);
                grid_array(i,j) = 2;
                grid_array(pos_x,pos_y) = tmp;
            end
        end
    end
    set(h, 'CData', grid_array);
    
    drawnow;
    counter = counter + 1;

end

figure
plot(happy_array_over_iters);
title('Happiness over iterations')
xlabel("Iterations")
ylabel("happiness")
grid on;
saveas(gcf,sprintf('Convergence/ConvergenceH%dRandom_%d', H, RANDOM))


function [] = save_grid(results_dict, counter, RANDOM, H)
fprintf('iterations needed to converge: %d\n', counter);
        results_dict.iterations(end+1) = counter;
        results_dict.H(end+1) = H;
        results_dict.Random(end+1) = RANDOM;
        saveas(gcf, sprintf('results/iterations_%d_H_%d_random_%d.png', counter, H, RANDOM));
end



