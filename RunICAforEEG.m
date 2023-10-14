% ----------------------------------------------
% Script Name: RunICAforEEG.m
% Author: Julio Medeiros
% Email: juliomedeiros@dei.uc.pt
% Institution: University of Coimbra (UC), Centre for Informatics and Systems of the University of Coimbra (UC)
% Date: 10/09/2023
% Description: This script runs Independent Component Analysis (ICA) on EEG data using EEGLAB.
% ----------------------------------------------

clear all;
close all;
clc

% Initialize EEGLAB and set its version
eeglab
EEG.etc.eeglabvers = '14.1.2'; % Tracks the version of EEGLAB being used

% Set the working directory
cd('C:\Users\JulioMedeiros\Desktop\analysis\importfiles\triggers\GA\1000QRS\BCG\fixed\filtered\inter_reref\epoching')

% List EEG data files in the directory
files = dir('*.set');

% Loop through EEG data files
for i = 1:length(files)
    tic
    filename = files(i).name;
    
    disp('>>>>>>>>>>>');
    disp(strcat('>>>>>>', {' '}, filename, {' '}, '<<<<<<'));
    disp('>>>>>>>>>>>');
    
    % Load the EEG data
    EEG = pop_loadset('filename', filename, 'filepath', 'C:\Users\JulioMedeiros\Desktop\analysis\importfiles\triggers\GA\1000QRS\BCG\fixed\filtered\inter_reref\epoching\');
    EEG = eeg_checkset(EEG);
    
    % Run Independent Component Analysis (ICA) runica (change the number of steps to 2000 in the eeglab runica function!)
    EEG = pop_runica(EEG, 'extended', 1, 'interrupt', 'on');
    EEG = eeg_checkset(EEG);
    
    % Update name for the EEG dataset and save it
    EEG.setname = strcat(filename(1:end-4), '_ICAcomp');
    EEG = pop_saveset(EEG, 'filename', strcat(EEG.setname, '.set'), 'filepath', 'C:\Users\JulioMedeiros\Desktop\analysis\importfiles\triggers\GA\1000QRS\BCG\fixed\filtered\inter_reref\epoching\ICAcomp');
    EEG = eeg_checkset(EEG);
    
    disp('>>>>>>>>>>>');
    disp(strcat('>>>>>>', {' '}, filename, {' '}, '<<<<<<'));
    disp('>>>>>>>>>>>');
    
    toc
end
