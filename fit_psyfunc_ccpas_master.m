%% AUTHOR: Matteo De Matola (based on work by Marco Esposito)
%% DATE: October 2022 (refactored June 2023)
%% FOR QUESTIONS ABOUT THIS SCRIPT OR ITS INPUTS/OUTPUTS/DEPENDENCIES/BUGS (if any): matteo [dot] dematola [at] unitn [dot] it
%% the code in this section:
%   - sets directories
%   - initializes the configuration structure (cfg) 
%   - reorganizes the data as required by following steps (this is done by calling subscript 'reorganize_landmarkTask_data')

main_dir = fileparts(mfilename('fullpath'));
dependencies_dir = 'Dependencies';                                          % contains the functions and scripts called by this master script
addpath(fullfile(main_dir, dependencies_dir));                              % Matlab's built-in 'fullfile' function builds a file or folder name from parts
mkdir(fullfile(main_dir, 'outputs'));

cfg.subjects_dir = fullfile(main_dir, 'Raw data');                          % defines a configuration structure (cfg) whose fields are fundamental variables
cfg.output_dir = fullfile(main_dir, 'outputs');
cfg.experiments = {'Experiment 1', 'Experiment 2'};
cfg.sessions = struct('first', 'FP', 'second', 'PF', 'third', 'FP100');
cfg.timepoints = {'pre', 'post'};
cfg.task_parameters = struct( ...
                            'line_length_degrees', 20, ...
                            'number_of_shifts', 17, ...
                            'shifts_degrees_va', [], ...
                            'range_percent', 2.8, ...
                            'shift_repetitions', 8);
cfg.right_code = 1;
cfg.left_code = 2;
cfg.longer_code = 1;
cfg.shorter_code = 2;
cfg.behavioural_variables = array2table({'accuracy'; 'misses'; 'response_bias'; 'mean_RT'});
cfg.behavioural_variables.Properties.VariableNames = {' '};
cfg.psychometric_variables = array2table({'PSE'; 'slope_at_PSE'; 'curve_width'});
cfg.psychometric_variables.Properties.VariableNames = {' '};

reorganize_landmarkTask_data

%% load landmark task data, compute performance indices and write their values to file
get_taskPerformance_indices

%% fit psychometric curves to single-subject data, save their PSE, slope at PSE, and curve width, then write their values to file
fit_psychometric_functions_subjects   

%% plot single-subject psychometric curves
plot_fitted_functions_subjects                      

%% fit a psychometric curves to group averages (just to visualize the trend - no analyses performed on curve parameters)
fit_psychometric_functions_groups 

%% plot group-level psychometric curves (just to visualize the trend - no analyses performed on curve parameters)
plot_fitted_functions_groups 