% ----------------------------------------------
% Script Name: BCG_cleaning.m
% Author: Julio Medeiros
% Date: 10/09/2023
% Description: This script is used to preprocess BCG from the EEG data using EEGLAB.
% ----------------------------------------------

% ----------------------------------------------
% Add the necessary paths and initialize EEGLAB
% ----------------------------------------------
addpath('C:\Users\JulioMedeiros\Desktop\Study1_EEG\eeglab14_1_2b');
eeglab

% ----------------------------------------------
% Change to the directory containing EEG data files
% ----------------------------------------------
cd('C:\Users\JulioMedeiros\Desktop\analysis\importfiles\triggers\GA\1000QRS\')

% ----------------------------------------------
% List EEG data files in the directory
% ----------------------------------------------
files = dir('*.set');

% ----------------------------------------------
% Loop through each EEG data file for processing
% ----------------------------------------------
for i = 1:length(files)
    filename = files(i).name;

    % Load the EEG data
    EEG = pop_loadset('filename', filename, 'filepath', 'C:\Users\JulioMedeiros\Desktop\analysis\importfiles\triggers\GA\1000QRS');

    % Preprocess EEG data
    EEG = eeg_checkset(EEG);
    EEG = pop_fmrib_pas(EEG, 'qrs', 'obs', 3);
    EEG = eeg_checkset(EEG);

    % Modify EEG data if needed (e.g., add ECG data)
    % EEG.data(64, :) = ECG;

    % Set a new name for the EEG dataset
    EEG.setname = strcat(filename(1:end-4), '_BCG');

    % Save the preprocessed EEG data
    EEG = pop_saveset(EEG, 'filename', strcat(EEG.setname, '.set'), 'filepath', 'C:\Users\JulioMedeiros\Desktop\analysis\importfiles\triggers\GA\1000QRS\BCG\');
    EEG = eeg_checkset(EEG);
end
