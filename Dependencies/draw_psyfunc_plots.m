% AUTHOR: Matteo De Matola (based on work by Marco Esposito)
% DATE: October 2022 (minor refactoring May/June 2023)

function draw_psyfunc_plots(fitted_function, stimulus_levels, perceptual_bias, plot_parameters)  
    
    plot(fitted_function, -stimulus_levels, perceptual_bias)
    
    grid on
    legend off
    
    xlabel([])
    ylabel([])
    
    x_axis = get(gca,'XAxis');
    x_axis.FontSize = 10;
    x_axis = gca;
    set(x_axis, 'XTick', stimulus_levels, 'FontName', 'Courier')
    xtickformat('%,.2f')
    
    yticks([0 1])
    
    PSE = fitted_function.pse;
    ylim([0 1])
    my_ylim = ylim;
    line([PSE PSE], my_ylim, 'color', 'r', 'LineStyle', '--','LineWidth', .25 );            % vertical line from x=PSE to y-axis upper limit
    line([0 0], my_ylim, 'color', 'k', 'LineStyle', '-','LineWidth', .03 );                 % vertical line from x=0 to y-axis upper limit
    line([-stimulus_levels(1) -stimulus_levels(end)], [0.5 0.5], 'color', 'k', 'LineStyle', '-', 'LineWidth', .25);
    
    CI = confint(fitted_function)';
    CI_band = patch([CI(1,1) CI(1,2) CI(1,2) CI(1,1)], [1 1 0 0] , 'red');                  % show confidence interval of PSE estimate
    CI_band.FaceAlpha = .15;
    CI_band.LineStyle = 'none';
    
    if plot_parameters.session == 1 
        if isempty(plot_parameters.subject)
            title(['Sample means ' plot_parameters.timepoint ' ccPAS'], 'FontName', 'Courier', 'FontSize', 15)
        else
            title([plot_parameters.subject ' ' regexprep(plot_parameters.timepoint,'(\<\w)','${upper($1)}') ' ccPAS'], 'FontName', 'Courier', 'FontSize', 15)
        end
    end
    
    if PSE > 0
        PSE = ['+' num2str(round(PSE,2))];
    elseif PSE == 0
        PSE = [' ' num2str(round(PSE,2))];
    else
        PSE = num2str(round(PSE,2));
    end
    
    text(0.8 , 0.9, ['PSE: ', PSE], 'FontName', 'Courier', 'FontSize', 13);