% AUTHOR: Matteo De Matola 
% DATE: October 2022 (refactored May 2023)

figures_dir = fullfile(cfg.output_dir, 'figures');
mkdir(figures_dir);

for experiment_number = 1:length(cfg.experiments)
    experiment_figures_dir = fullfile(figures_dir, cfg.experiments{experiment_number});
    mkdir(experiment_figures_dir);
    if experiment_number == 1                                                           % this conditional block just to set variable names
        sessions = {cfg.sessions.first, cfg.sessions.second};
        subjects = subjects_experiment1;
    elseif experiment_number == 2
        sessions = {cfg.sessions.first, cfg.sessions.third};
        subjects = subjects_experiment2;
    end
    for subject_number = 1:numel(subjects)
        subject = subjects{subject_number};
        tiledlayout( length(sessions),length(cfg.timepoints) );                         % defines a plots matrix that will be filled by the following loops
        for session_number = 1:length(sessions)
            for time = 1:length(cfg.timepoints)
                current_timepoint = cfg.timepoints{time};
                shiftwise_bias_timepoint = readtable(fullfile(cfg.output_dir, ...
                                                              sessions{session_number}, ...
                                                              cfg.timepoints{time}, ...
                                                              ['shiftwise-bias-' ...
                                                              sessions{session_number} ...
                                                              cfg.timepoints{time} ...
                                                              '.csv']), ...
                                                     'VariableNamingRule','preserve'); 
                
                subject_column_idx = find(string(shiftwise_bias_timepoint.Properties.VariableNames) == subject);
                shiftwise_bias_subject = table2array(shiftwise_bias_timepoint(:,subject_column_idx));

                fitted_function = fitted_functions_all_experiments{1,experiment_number}{1,session_number}{1,time}{1,subject_number};
                
                plot_parameters.subject = subject;
                plot_parameters.session = session_number;
                plot_parameters.timepoint = current_timepoint;
                nexttile                                                                % selects the next entry of the plots matrix
                draw_psyfunc_plots(fitted_function, percentage_shifts, shiftwise_bias_subject, plot_parameters)
            end
        end
        if experiment_number == 1
            ylabel(nexttile(1), 'FP10             ', 'FontName', 'Courier', 'FontWeight', 'Bold', 'Rotation', 0);
            ylabel(nexttile(3), 'PF10             ', 'FontName', 'Courier', 'FontWeight', 'Bold', 'Rotation', 0);
        elseif experiment_number == 2
            ylabel(nexttile(1), 'FP10             ', 'FontName', 'Courier', 'FontWeight', 'Bold', 'Rotation', 0);
            ylabel(nexttile(3), 'FP100             ', 'FontName', 'Courier', 'FontWeight', 'Bold', 'Rotation', 0);
        end
        saveas(gcf, fullfile(experiment_figures_dir, [subject, '-psychometric-curve-experiment', num2str(experiment_number), '.fig']));
    end
end

clear session subjects subject experiment_figures_dir combined_plot shiftwise_bias_timepoint subject_column_idx shiftwise_bias_subject fitted_function