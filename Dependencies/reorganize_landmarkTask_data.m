% AUTHOR: Matteo De Matola
% DATE: October 2022 (minor refactoring May 2023)
% 
% THIS SCRIPT:
%   - Reorganizes raw landmark task data from the experiment described in Guidali et al. (2023) and carried out:
%       - At Neurophysiology Lab, IRCCS Istituto Centro San Giovanni di Dio Fatebenefratelli, Brescia
%       - From February-October 2022
%       - By Giacomo Guidali (now at University of Milano-Bicocca) and Matteo De Matola (now at University of Trento)
%   - Must be nested in the master script called 'fit_psyfunc_ccpas_master.m'. however, it can be adapted for use in different contexts.
% 
% HOW DOES THIS SCRIPT WORK?
% A dialog box asks if you already have an 'experiment_1' and an 'experiment_2' folder. Enter 'n' if you have the following directory structure:
% 
%   data
%       |_S01
% 	    |_S02
%       |_...
% 	    |_SXX
% 
% Once you have entered 'n', the script reorganizes the data as follows:
% 	- If a subject's folder contains 'FP' and 'PF', the subject is assigned to a new folder named 'Experiment 1'
% 	- If a subject's folder contains 'FP', 'PF', and 'FP100', the subject is assigned to a new folder named 'Experiment 2' and folder 'PF' is removed.
% 	  This does NOT cause data loss  because Experiment 2 subjects are also Experiment 1 subjects, so folder 'PF' can always be found in 'Experiment 1'.
% In terms of folders, the end result will be:
% 
% 	experiment_1
% 	    |_subject folder
% 	        |_FP
% 	        |_PF
% 
% 	experiment_2
% 	    |_subject folder
%           |_FP
% 	        |_FP100
% 
% Folders must be organized like this for the script to run.
% If your data are already organized like this, just enter 'y' in the dialog box.

question = inputdlg('Do you already have an Experiment 1 and an Experiment 2 folder? y/n');

if char(question) == 'n'
    folderlist = dir(cfg.subjects_dir);
    folderlist = folderlist(arrayfun(@(x) ~strcmp(x.name(1),'.'),folderlist));
    n_subjects = numel(folderlist);
    for i = n_subjects : -1 : 1
        name = folderlist(i).name;
        if length(name) > 3
            folderlist(i) = [];
        end
    end

    clear name

    n_subjects = numel(folderlist);
    subjects = cell(n_subjects,1);
    for i = 1:n_subjects
        subjects{i} = folderlist(i).name;
    end

    experiment_1 = fullfile( cfg.subjects_dir, string(cfg.experiments(1)) );
    experiment_2 = fullfile( cfg.subjects_dir, string(cfg.experiments(2)) );
    mkdir(experiment_1)
    mkdir(experiment_2)

    for subject_number = 1:length(subjects)
        subject_source_dir = fullfile(cfg.subjects_dir, subjects{subject_number});
        folders_to_move = dir(subject_source_dir);
        folders_to_move = folders_to_move(arrayfun(@(x) ~strcmp(x.name(1),'.'),folders_to_move));
        for session_folder = 1:numel(folders_to_move)
            destination_folder = fullfile(experiment_1, subjects{subject_number}, folders_to_move(session_folder).name);
            mkdir(destination_folder)
            copyfile(fullfile(subject_source_dir, folders_to_move(session_folder).name), destination_folder)

            destination_folder = fullfile(experiment_2, subjects{subject_number}, folders_to_move(session_folder).name);
            mkdir(destination_folder)
            copyfile(fullfile(subject_source_dir, folders_to_move(session_folder).name), destination_folder)
        end
    end

    for subject_number = 1:length(subjects)
        if isfolder(fullfile(experiment_1, subjects{subject_number}, cfg.sessions.third)) == 1
            rmdir(fullfile(experiment_1, subjects{subject_number}, cfg.sessions.third), 's')
        end

        if isfolder(fullfile(experiment_2, subjects{subject_number}, cfg.sessions.third)) == 0
            rmdir(fullfile(experiment_2, subjects{subject_number}), 's') % cfg.sessions.third
        end

        if isfolder(fullfile(experiment_2, subjects{subject_number}, cfg.sessions.second)) == 1
            rmdir(fullfile(experiment_2, subjects{subject_number}, cfg.sessions.second), 's')
        end

        rmdir(fullfile(cfg.subjects_dir, subjects{subject_number}), 's')
    end

    folderlist_1 = dir( fullfile(cfg.subjects_dir, string(cfg.experiments(1)) ) );
    folderlist_1 = folderlist_1( arrayfun(@(x) ~strcmp(x.name(1),'.'),folderlist_1) );
    n_subjects_experiment1 = numel(folderlist_1);
    subjects_experiment1 = cell(1,n_subjects_experiment1);
    for i = 1:n_subjects_experiment1
        subjects_experiment1{i} = folderlist_1(i).name;
    end
    folderlist_2 = dir( fullfile(cfg.subjects_dir, string(cfg.experiments(2)) ) );
    folderlist_2 = folderlist_2( arrayfun(@(x) ~strcmp(x.name(1),'.'),folderlist_2) );
    n_subjects_experiment2 = numel(folderlist_2);
    subjects_experiment2 = cell(1,n_subjects_experiment2);
    for i = 1:n_subjects_experiment2
        subjects_experiment2{i} = folderlist_2(i).name;
    end
else
    folderlist_1 = dir( fullfile(cfg.subjects_dir, string(cfg.experiments(1)) ) );
    folderlist_1 = folderlist_1( arrayfun(@(x) ~strcmp(x.name(1),'.'),folderlist_1) );
    n_subjects_experiment1 = numel(folderlist_1);
    subjects_experiment1 = cell(1,n_subjects_experiment1);
    for i = 1:n_subjects_experiment1
        subjects_experiment1{i} = folderlist_1(i).name;
    end
    folderlist_2 = dir( fullfile(cfg.subjects_dir, string(cfg.experiments(2)) ) );
    folderlist_2 = folderlist_2(arrayfun(@(x) ~strcmp(x.name(1),'.'),folderlist_2));
    n_subjects_experiment2 = numel(folderlist_2);
    subjects_experiment2 = cell(1,n_subjects_experiment2);
    for i = 1:n_subjects_experiment2
        subjects_experiment2{i} = folderlist_2(i).name;
    end
end