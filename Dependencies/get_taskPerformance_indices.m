% AUTHOR: Matteo De Matola (based on work by Marco Esposito)
% DATE: October 2022 (refactored May 2023)
%
% THIS SCRIPT:
% > for each experiment
%   > for each session in the experiment
%       > for each timepoint in the session
%           > for each subject
%               > loads raw data
%               > computes accuracy, misses, response bias and mean
%                 reaction time (RT) ('load_landmarkTask_data.m')
%               > computes shiftwise perceptual bias
%               > writes all results to file
%           > end for
%       > end for 
% > end for
%   
% all the code that does not perform any of the operations listed above is "supporting code", i.e., it defines variables or prepares them for an operation.

for experiment_number = 1:length(cfg.experiments)
    if isfolder(fullfile(cfg.output_dir, cfg.sessions.first)) == 0 || experiment_number == 1            % this conditional block just to set variable names
        sessions = {cfg.sessions.first, cfg.sessions.second};
    else
        sessions = {cfg.sessions.third};
    end

    if experiment_number == 1                                                                           % this conditional block just to set variable names
        n_subjects = n_subjects_experiment1;
        subjects = subjects_experiment1;
    else
        n_subjects = n_subjects_experiment2;
        subjects = subjects_experiment2;
    end

    for session_number = 1:length(sessions)
        current_session = sessions{session_number};
        for time = 1:length(cfg.timepoints)
            current_timepoint = cfg.timepoints{time};
            performance_timepoint = zeros(numel(cfg.behavioural_variables), n_subjects);                % just memory preallocation
            shiftwise_bias_timepoint = zeros(cfg.task_parameters.number_of_shifts, n_subjects);         % just memory preallocation
            for subject_number = 1:length(subjects)
                current_subject = subjects{subject_number};
                if all(char(subjects{subject_number}) == 'S24') && experiment_number == 1 && session_number == 1 && time == 1
                    rename_S24_landmarkTask_data
                else
                    data_dir = fullfile(cfg.subjects_dir, cfg.experiments{experiment_number}, current_subject, current_session);
                end
                [raw_data, accuracy, misses, response_bias, mean_RT] = load_landmarkTask_data(data_dir, ...
                                                                                              current_subject, ...
                                                                                              current_session, ...
                                                                                              current_timepoint);
                
                if subject_number == 1                                                                  % this conditional statement to avoid useless repetition
                    shift_values_degrees_va = unique(raw_data.stim_shift_deg);
                    shift_values_degrees_va([1 end]) = [];
                    percentage_shifts = shift_values_degrees_va * 100 ./ cfg.task_parameters.line_length_degrees;
                    cfg.task_parameters.shifts_degrees_va = shift_values_degrees_va;
                end
                shiftwise_bias = compute_shiftwise_bias(raw_data, cfg);
                performance_timepoint(1,subject_number) = accuracy;
                performance_timepoint(2,subject_number) = misses;
                performance_timepoint(3,subject_number) = response_bias;
                performance_timepoint(4,subject_number) = mean_RT;
                shiftwise_bias_timepoint(:, subject_number) = shiftwise_bias(:,2);
            end

            performance_table = array2table(performance_timepoint, 'VariableNames', subjects);
            shiftwise_bias_timepoint_table = array2table([cfg.task_parameters.shifts_degrees_va shiftwise_bias_timepoint], ...
                                                         'VariableNames', ['shift_degrees_visualAngle' subjects]);

            output_subdir = fullfile(cfg.output_dir, sessions{session_number}, cfg.timepoints{time});
            mkdir(output_subdir)

            performanceData_filename = ['performance-data-', sessions{session_number}, cfg.timepoints{time} '.csv'];
            shiftwiseBias_filename = ['shiftwise-bias-', sessions{session_number}, cfg.timepoints{time}, '.csv'];
            
            writetable( [cfg.behavioural_variables performance_table], fullfile(output_subdir,performanceData_filename) );
            writetable( shiftwise_bias_timepoint_table, fullfile(output_subdir,shiftwiseBias_filename) );
        end
    end
end

clear accuracy misses response_bias mean_RT performance_timepoint performance_table shiftwise_bias_timepoint_table