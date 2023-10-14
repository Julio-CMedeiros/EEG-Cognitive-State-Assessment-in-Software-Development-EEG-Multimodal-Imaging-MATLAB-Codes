% ----------------------------------------------
% Script Name: BCG_cleaning.m
% Author: Julio Medeiros
% Email: juliomedeiros@dei.uc.pt
% Institution: University of Coimbra (UC), Centre for Informatics and Systems of the University of Coimbra (UC)
% Date: 10/09/2023
% Description: This script is used to preprocess Ballistocardiogram (BCG) from the EEG data using EEGLAB using EEGLAB with the FMRIB Plug-in.
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
% Loop through each EEG data file for preprocessing
% ----------------------------------------------
for i = 1:length(files)
    filename = files(i).name;

    % Load the EEG data
    EEG = pop_loadset('filename', filename, 'filepath', 'C:\Users\JulioMedeiros\Desktop\analysis\importfiles\triggers\GA\1000QRS');

    % Preprocess EEG data
    EEG = eeg_checkset(EEG);
    EEG = pop_fmrib_pas(EEG, 'qrs', 'obs', 3);
    EEG = eeg_checkset(EEG);

    % Update file name
    EEG.setname = strcat(filename(1:end-4), '_BCG');

    % Save the preprocessed EEG data
    EEG = pop_saveset(EEG, 'filename', strcat(EEG.setname, '.set'), 'filepath', 'C:\Users\JulioMedeiros\Desktop\analysis\importfiles\triggers\GA\1000QRS\BCG\');
    EEG = eeg_checkset(EEG);
end
