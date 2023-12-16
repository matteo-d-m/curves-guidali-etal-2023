% AUTHOR: Matteo De Matola (based on work by Marco Esposito)
% DATE: October 2022 (refactored May 2023 - added response bias and reaction time calculation July 2023)
% 
% GIVEN:
%     1) a subject ID (e.g., 'S01')
%     2) a session ID (e.g., 'FP' for fronto-parietal ccPAS)
%     3) a timepoint ID (e.g., 'pre' for pre-stimulation)
% THIS FUNCTION:
%     - loads raw data from .mat files. the .mat files are the outputs of the script that runs the task during experimental sessions
%     - extracts the parts of interest from the resulting arrays
%     - concatenates all parts of interest into a single array, then converts it to table 
%     - computes accuracy, misses, response bias and mean reaction time (RT) for the given subject in the given timepoint and the given session
%     - returns the data table and one value per behavioural variable
%       (accuracy, misses, response bias and mean RT)

function [raw_data, accuracy, misses, response_bias, mean_RT] = load_landmarkTask_data(data_dir, subject, session, timepoint)
  
    block1_data = load(fullfile(data_dir, [subject session '_' timepoint 'L1.mat']));     % load first .mat file
    behavioral_data_block1 = block1_data.behav;                                           % extract the part of interest
    block2_data = load(fullfile(data_dir, [subject session '_' timepoint 'L2.mat']));     % load second .mat file 
    behavioral_data_block2 = block2_data.behav;                                           % extract the part of interest
    
    raw_data = array2table(...                                                            % concatenate all data arrays into a single one, then convert it to table
                          [behavioral_data_block1; behavioral_data_block2],...
                          'VariableNames', ...
                          { ...
                           't', ...
                           'instruct', ...
                           'stim_shift_pixels', ...
                           'stim_shift_deg', ...
                           'stim_width_pixels', ...
                           'button_press', ...
                           'correct', ...
                           'RT' ...
                          } ...
                         );

    accuracy = round((sum( raw_data.correct == 1) / (size(raw_data,1) - sum( raw_data.correct == -1)))* 100, 2 );
    misses = round((sum(raw_data.button_press == -1) / size(raw_data,1) ) *100, 2);
    button_presses = raw_data.button_press;
    button_presses(button_presses == -1) = 0;                                             % recoding for response bias calculation 
    button_presses(button_presses == 2) = -1;                                             % recoding for response bias calculation 
    response_bias = round(sum(button_presses) / (numel(button_presses) - sum(button_presses == 0) ), 2 );
    mean_RT = round(mean(raw_data.RT(raw_data.RT > 0)),2);                                % exclude negative values because RT = -1 in case of misses