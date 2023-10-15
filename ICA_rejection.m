% ----------------------------------------------
% Script Name: ICA_rejection.m
% Author: Julio Medeiros
% Email: juliomedeiros@dei.uc.pt
% Institution: University of Coimbra (UC), Centre for Informatics and Systems of the University of Coimbra (UC)
% Date: 10/09/2023
% Description: This script is used for Independent Component Analysis (ICA) component rejection from the EEG data using EEGLAB and ICLabel plugin.
% ----------------------------------------------

clear all; close all; clc
% Add necessary paths for EEGLAB and its plugins
addpath('C:\Users\JulioMedeiros\Desktop\Study1_EEG\eeglab14_1_2b');
addpath('C:\Users\JulioMedeiros\Desktop\Study1_EEG\eeglab14_1_2b\plugins\ICLabel1.2.5\viewprops');

% Initialize EEGLAB
eeglab

% Set the working directory
cd('C:\Users\JulioMedeiros\Desktop\analysis\importfiles\triggers\GA\1000QRS\BCG\fixed\filtered\inter_reref\epoching\ICAcomp\')

% List EEG data files in the directory
files = dir('*.set');

% Enable debugging mode at 'pause' statement
dbstop in pause

% Loop through EEG data files for processing
for i = 1:length(files)
    i
    tic
    
    % Load the EEG data
    filename = files(i).name;
    EEG.etc.eeglabvers = '14.1.2'; % this tracks which version of EEGLAB is being used, you may ignore it
    disp('>>>>>>>>>>>');
    disp(strcat('>>>>>>',{' '},filename,{' '},'<<<<<<'));
    disp('>>>>>>>>>>>');
    EEG = pop_loadset('filename', filename, 'filepath', 'C:\Users\JulioMedeiros\Desktop\analysis\importfiles\triggers\GA\1000QRS\BCG\fixed\filtered\inter_reref\epoching\ICAcomp\');
    EEG = eeg_checkset(EEG);
    
    % Plot EEG data
    pop_eegplot(EEG, 0, 1, 1);
    movegui('west');
    
    % Perform IClabel pop and allows user to select ICA components with artifact to remove based on topoplot, PSD  [1, 45], time series and ICALabel Classification
    EEG = pop_iclabel(EEG, 'default');
    eeglab redraw;
    pop_viewprops(EEG, 0, [1:60], {'freqrange', [1, 45]});
    
    % Allow user to select components for removal
    EEG = eeg_checkset(EEG);
    flag = 1000;
    rem = [];
    
    while flag ~= 0
        flag = input('Componentes a remover: ');
        
        if flag > 99
            flag = input('ERRO!!!!!! Componentes a remover: ');
        end
        
        if flag ~= 0
            rem = [rem, flag];
            sort(rem)
        end
        
        if flag == 99
            pause
        end
    end
    
    rem = unique(rem);
    EEG.comp_removed = rem;
    EEG = pop_subcomp(EEG, rem, 0);
    removidas = length(rem);
    
    % Plot EEG data after component removal
    pop_eegplot(EEG, 1, 1, 1);
    cont = 0;
    
    while cont ~= 1
        cont = input('>> eegplot >> Continue? Yes (1) or No (0): ');
    end
    
    % Update name and save it
    EEG.setname = strcat(filename(1:end-4), '_ICA_clean');
    EEG = eeg_checkset(EEG);
    EEG = pop_saveset(EEG, 'filename', strcat(EEG.setname, '.set'), 'filepath', 'C:\Users\JulioMedeiros\Desktop\analysis\importfiles\triggers\GA\1000QRS\BCG\fixed\filtered\inter_reref\epoching\ICAcomp\ICA\');
    EEG = eeg_checkset(EEG);
    
    % Log information about components removed
    fileID = fopen('C:\Users\JulioMedeiros\Desktop\ICA_infor.txt', 'a+');
    fprintf(fileID, strcat(filename, ' >>>>> components removed(', num2str(removidas), '): ', num2str(rem), ' \n'));
    fclose(fileID);
    
    % Close figures and clear the command window
    close all
    clc    
end
