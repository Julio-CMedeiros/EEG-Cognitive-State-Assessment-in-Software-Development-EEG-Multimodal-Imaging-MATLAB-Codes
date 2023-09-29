clear all; close all; clc

addpath 'C:\Users\JulioMedeiros\Desktop\Study1_EEG\eeglab14_1_2b'

eeglab

EEG.etc.eeglabvers = '14.1.2'; % this tracks which version of EEGLAB is being used, you may ignore it

cd('C:\\Users\\JulioMedeiros\\Desktop\\analysis\\importfiles\\triggers\\GA\\1000QRS\\BCG\\fixed\\filtered\\inter_reref\\epoching\\ICAcomp\\ICA')

files=dir('*.set');

for i=1:length(files)
    tic
    filename=files(i).name;

    EEG = pop_loadset('filename',filename,'filepath','C:\\Users\\JulioMedeiros\\Desktop\\analysis\\importfiles\\triggers\\GA\\1000QRS\\BCG\\fixed\\filtered\\inter_reref\\epoching\\ICAcomp\\ICA\\');
    EEG = eeg_checkset( EEG );
    
    idx_start_1=find(strcmp({EEG.event.type},'1'));
    idx_start_2=find(strcmp({EEG.event.type},'2'));
    idx_start_3=find(strcmp({EEG.event.type},'3'));
    idx_start_15=find(strcmp({EEG.event.type},'15'));
    idx_total_tasks=[idx_start_1,idx_start_2,idx_start_3];
    structure{i,1}=i;
    structure{i,2}=filename;
    structure{i,3}=length(idx_total_tasks);
    structure{i,4}=idx_total_tasks;
    structure{i,5}=length(idx_start_15);
    structure{i,6}=idx_start_15;
end
