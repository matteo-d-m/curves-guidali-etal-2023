for experiment_number = 1:length(cfg.experiments)
    experiment_figures_dir = fullfile(figures_dir, cfg.experiments{experiment_number});
    if experiment_number == 1
        sessions = {cfg.sessions.first, cfg.sessions.second};
    elseif experiment_number == 2
        sessions = {cfg.sessions.first, cfg.sessions.third};
    end

    combined_plot = tiledlayout(length(sessions),length(cfg.timepoints));

    for session_number = 1:length(sessions)
        for time = 1:length(cfg.timepoints)
            current_timepoint = cfg.timepoints{time};
            shiftwise_bias_timepoint = readtable(fullfile(cfg.output_dir, ...
                                                          sessions{session_number}, ...
                                                          cfg.timepoints{time}, ...
                                                          ['shiftwise-bias-', ...
                                                          sessions{session_number}, ...
                                                          cfg.timepoints{time}, ...
                                                          '.csv']), ...
                                                 'VariableNamingRule', 'preserve');
            
            shiftwise_bias_timepoint = table2array(shiftwise_bias_timepoint(:,2:end));
            average_bias_timepoint = round(mean(shiftwise_bias_timepoint,2),2);

            if experiment_number == 1
                fitted_function = fitted_functions_experiment1{session_number,time};
            elseif experiment_number == 2
                fitted_function = fitted_functions_experiment2{session_number,time};
            end

            plot_parameters.subject = [];
            plot_parameters.session = session_number;
            plot_parameters.timepoint = current_timepoint;
            nexttile
            draw_psyfunc_plots(fitted_function, percentage_shifts, average_bias_timepoint, plot_parameters)
        end
    end
        ylabel(nexttile(1), [sessions{1} '           '], 'FontName', 'Courier', 'FontWeight', 'Bold', 'Rotation', 0);
        ylabel(nexttile(3), [sessions{2} '           '], 'FontName', 'Courier', 'FontWeight', 'Bold', 'Rotation', 0);
        saveas(gcf, fullfile(experiment_figures_dir, ['group-psychometric-curves-experiment', num2str(experiment_number), '.fig']));
end