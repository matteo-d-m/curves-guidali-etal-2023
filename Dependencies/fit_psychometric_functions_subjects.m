% AUTHOR: Matteo De Matola
% DATE: October 2022 (refactored May 2023)

% THIS SCRIPT:
% > defines a decreasing logistic function and related fitting options. these options are:
%   - fitting method (non-linear least squares)
%   - the initial values of the function's parameters (changing them will slightly change their final values, affecting reproducibility)
% > for each experiment
%     > for each session in the experiment
%       > for each timepoint in the session
%             > fetches the matrix that stores perceptual bias data 
%             > for each subject 
%                 > extracts perceptual bias data from the timepoint's matrix
%                 > fits the psychometric function to the subject's data. before fitting, the data are rotated around x=0 to get more easily interpretable plots 
%                 > saves the psychometric function (for plotting) and its parameters (for statistical analyses)
%               > end for
%             > saves all psychometric functions (for plotting) and write their parameters to file (for statistical analyses)
%       > end for
%       > save all psychometric functions (for plotting)
%     > end for
%     > save all psychometric functions (for plotting)
% > end for
% 
% all the code that does not perform any of the operations listed above is "supporting code", i.e., it defines variables or prepares them for an operation.

fit_options = fitoptions('Method', 'NonlinearLeastSquares', ...
                         'StartPoint', [0.1 0.2]); 

psychometric_function = fittype('1/(1 + exp((percentage_shifts - pse)/s))', ...
                                'independent', 'percentage_shifts', ...
                                'dependent', 'shiftwise_bias_subject', ...
                                'options', fit_options);

curve_data_experiment1 = zeros( numel(cfg.psychometric_variables), numel(subjects_experiment1) );   % just memory preallocation 
curve_data_experiment2 = zeros( numel(cfg.psychometric_variables), numel(subjects_experiment2) );   % just memory preallocation
fitted_functions_all_experiments = cell( 1,length(cfg.experiments) );                               % just memory preallocation
fitted_functions_experiment1 = cell(1,2);                                                           % just memory preallocation
fitted_functions_experiment2 = cell(1,2);                                                           % just memory preallocation

for experiment_number = 1:length(cfg.experiments)                                                   
    if experiment_number == 1                                                                       % this whole conditional block just to set variable names
        sessions = {cfg.sessions.first, cfg.sessions.second};
        fitted_functions_experiment = fitted_functions_experiment1;
        subjects = subjects_experiment1;
        curve_data = curve_data_experiment1;
    elseif experiment_number == 2
        sessions = {cfg.sessions.first, cfg.sessions.third};
        fitted_functions_experiment = fitted_functions_experiment2;
        subjects = subjects_experiment2;
        curve_data = curve_data_experiment2;
    end
    
    for session_number = 1:length(sessions)                                                         
        fitted_functions_session = cell(1,length(cfg.timepoints)); 
        for time = 1:length(cfg.timepoints)                                                         
            fitted_functions_timepoint = cell(1, numel(subjects));
            shiftwise_bias_timepoint = readtable(fullfile(cfg.output_dir, ...
                                                          sessions{session_number}, ...
                                                          cfg.timepoints{time}, ...
                                                          ['shiftwise-bias-' ...
                                                          sessions{session_number} ...
                                                          cfg.timepoints{time} ...
                                                          '.csv']), ...
                                                 'VariableNamingRule', 'preserve'); 
            
            for subject_number = 1:numel(subjects)                                                  
                subject = subjects{subject_number};
                subject_column_idx = find(string(shiftwise_bias_timepoint.Properties.VariableNames) == subject);
                shiftwise_bias_subject = table2array(shiftwise_bias_timepoint(:,subject_column_idx));

                [fitted_function, ~, ~] = fit(-percentage_shifts, shiftwise_bias_subject, psychometric_function, fit_options);
                fitted_functions_timepoint{1,subject_number} = fitted_function;

                pse = fitted_function.pse;
                slope_at_pse = differentiate(fitted_function, pse);
                curve_width = fitted_function.s;
                curve_data(1,subject_number) = pse;
                curve_data(2,subject_number) = slope_at_pse;
                curve_data(3,subject_number) = curve_width;
            end

            fitted_functions_session{1,time} = fitted_functions_timepoint;
            
            output_subdir = fullfile(cfg.output_dir, sessions{session_number}, cfg.timepoints{time});
            curve_data_table = array2table(curve_data, 'VariableNames', subjects);
            curveData_filename = ['curve-data-experiment' num2str(experiment_number) '-' sessions{session_number} cfg.timepoints{time} '.csv'];
            writetable([cfg.psychometric_variables curve_data_table], fullfile(output_subdir,curveData_filename));
        end
        fitted_functions_experiment{1,session_number} = fitted_functions_session;
    end
    fitted_functions_all_experiments{1,experiment_number} = fitted_functions_experiment;
end

clear fitted_function fitted_functions_timepoint fitted_functions_session fitted_functions_experiment1 fitted_functions_experiment2 fitted_functions_experiment 