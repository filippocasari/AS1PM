for i = 1:9
    fig_file = sprintf('Convergence/ConvergenceH%dRandom_0.fig', i);
    % Construct the file path
    if exist(fig_file, 'file')
        
        png_file = sprintf('Convergence/ConvergenceH%dRandom_0.png', i);
        
        % Load the figure file
        fig = openfig(fig_file);
    
        % Save the figure as a PNG image
        saveas(fig, png_file, 'png');
    
        % Close the figure
        close(fig);
    end
    fig_file = sprintf('Convergence/ConvergenceH%dRandom_1.fig', i);
    if exist(fig_file, 'file')
        png_file = sprintf('Convergence/ConvergenceH%dRandom_1.png', i);
        
        % Load the figure file
        fig = openfig(fig_file);
    
        % Save the figure as a PNG image
        saveas(fig, png_file, 'png');
    
        % Close the figure
        close(fig);
    end
end
