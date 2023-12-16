% AUTHOR: Matteo De Matola
% DATE: October 2022 (refactored May 2023)

% THIS SCRIPT:
% > defines a decreasing logistic function and related fitting options. these options are:
%   - fitting method (non-linear least squares)
%   - the initial values of the function's parameters (changing them will slightly change their final values, affecting reproducibility)
%   > for each session in the experiment
%       > for each timepoint in the session
%           > fetches the matrix that stores perceptual bias data 
%           > computes the sample mean for that timepoint of that session
%           > fits a psychometric function to mean perceptual bias (just to visualize the trend - no analyses performed on curve parameters)
%           > saves all psychometric functions (for plotting) 
%       > end for
%   > end for
% 
% all the code that does not perform any of the operations listed above is "supporting code", i.e., it defines variables or prepares them for an operation.

fit_options = fitoptions('Method', 'NonlinearLeastSquares', ...
                         'StartPoint', [0.1 0.2]);

psychometric_function = fittype('1/(1 + exp((percentage_shifts - pse)/s))', ...
                                'independent', 'percentage_shifts', ...
                                'dependent', 'average_bias_timepoint', ...
                                'options', fit_options);

sessions = {cfg.sessions.first, cfg.sessions.second, cfg.sessions.third};

fitted_functions_experiment1 = cell( length(sessions)-1,length(cfg.timepoints) );
fitted_functions_experiment2 = cell( length(sessions)-1,length(cfg.timepoints) );

for session_number = 1:length(sessions)
    for time = 1:length(cfg.timepoints)
        shiftwise_bias_timepoint = readtable(fullfile(cfg.output_dir, ...
                                                      sessions{session_number}, ...
                                                      cfg.timepoints{time}, ...
                                                      ['shiftwise-bias-' ...
                                                      sessions{session_number} ...
                                                      cfg.timepoints{time} ...
                                                      '.csv']), ...
                                             'VariableNamingRule', 'preserve'); 

%         performance_data = readtable(fullfile(cfg.output_dir, ...
%                                               sessions{session_number}, ...
%                                               cfg.timepoints{time}, ...
%                                               ['performance-data-', ...
%                                               sessions{session_number}, ...
%                                               cfg.timepoints{time}, ...
%                                               '.csv']), ...
%                                      'VariableNamingRule', 'preserve');
% 
%         performance_data.Properties.VariableNames(1) = {' '};

        shiftwise_bias_timepoint = table2array( shiftwise_bias_timepoint(:,2:end) );
        average_bias_timepoint = round(mean(shiftwise_bias_timepoint,2),2);

%         performance_data = table2array( performance_data(:,2:end) );
%         accuracy_mean = round( mean(performance_data(1,:)), 2 );
%         misses_mean = round( mean(performance_data(2,:)), 2 );

        [fitted_function, ~, ~] = fit(-percentage_shifts, average_bias_timepoint, psychometric_function, fit_options);

        if session_number == 1
            fitted_functions_experiment1{session_number,time} = fitted_function;
            fitted_functions_experiment2{session_number,time} = fitted_function;
        elseif session_number == 2
            fitted_functions_experiment1{session_number,time} = fitted_function;
        elseif session_number == 3
            fitted_functions_experiment2{session_number-1,time} = fitted_function;
        end
    end
end