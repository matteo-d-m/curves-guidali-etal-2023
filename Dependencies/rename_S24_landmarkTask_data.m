% AUTHOR: Matteo De Matola
% DATE: October 2022 (refactored May 2023)
%
% WHAT DOES THIS SCRIPT DO?
%   - this script renames landmark task (LM) data for subject 24. this is necessary because we had erroneously saved 'FP' data as 'PF'
% 
% HOW DOES THIS SCRIPT WORK?
%   - it accesses the folders where S24 data can be found
%   - in each folder, for each LM file, it inverts the order of letters P and F in the file's name
%   - it re-saves the file with the new name

for to_rename = 1:length(cfg.experiments)
    data_dir = fullfile(cfg.subjects_dir, cfg.experiments{to_rename}, subjects{subject_number}, sessions{session_number});
    files = dir(data_dir);
    files = files(arrayfun(@(x) ~strcmp(x.name(1),'.'),files));
    for file_number = 1:numel(files)
        file_name = files(file_number).name;
        if file_name(1) == 'S' && file_name(4) == 'P'
            old_dir = fullfile(data_dir, file_name);
            file_name(4:5) = 'FP';
            new_dir = fullfile(data_dir, file_name);
            movefile(old_dir, new_dir);
        end
    end
end

clear to_rename files file_number file_name old_dir new_dir