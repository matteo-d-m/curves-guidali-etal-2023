% AUTHOR: Matteo De Matola (based on work by Marco Esposito)
% DATE: October 2022 (refactored May 2023)
%
% GIVEN:
%     > a table containing data from a given subject in a given timepoint of a given session (i.e., the output of 'load_landmarkTask_data.m')
%     > a configuration (cfg) structure containing task parameters
% THIS FUNCTION:
%     for each shift value
%         > counts the number of 'right is longer' (RL) responses given in the landmark task
%         > counts the number of 'left is shorter' (LS) responses given in the landmark task
%         > normalizes each of the two counts by the number of times the shift value occurred in the task
%         > computes perceptual bias 
%     end for
%     > returns an array with one value of perceptual bias per shift value

function [shiftwise_bias_subject] = compute_shiftwise_bias(raw_data_subject, cfg)
    
    shiftwise_bias_subject = zeros(cfg.task_parameters.number_of_shifts,2);                                         % create the output array
    
    for i = 1:numel(cfg.task_parameters.shifts_degrees_va)
        idx_right_longer = find(raw_data_subject.stim_shift_deg == cfg.task_parameters.shifts_degrees_va(i) ...     % count RL responses
                                & raw_data_subject.button_press == cfg.right_code ...                               
                                & raw_data_subject.instruct == cfg.longer_code);
        idx_left_shorter = find(raw_data_subject.stim_shift_deg == cfg.task_parameters.shifts_degrees_va(i) ...     % count LS responses
                                & raw_data_subject.button_press == cfg.left_code ...
                                & raw_data_subject.instruct == cfg.shorter_code);
        prop_right_longer = numel(idx_right_longer) / (cfg.task_parameters.shift_repetitions);                      % normalize RL responses by shift repetitions
        prop_left_shorter = numel(idx_left_shorter) / (cfg.task_parameters.shift_repetitions);                      % normalize LS responses by shift repetitions
        perceptual_bias = (prop_right_longer + prop_left_shorter) / 2;                                              % compute perceptual bias
        shiftwise_bias_subject(i, :) = [cfg.task_parameters.shifts_degrees_va(i)   perceptual_bias];                % fill up the output array
    end