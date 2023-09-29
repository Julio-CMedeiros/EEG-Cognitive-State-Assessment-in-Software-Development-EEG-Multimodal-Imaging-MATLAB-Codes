% clear all; close all; clc
close all, clc
addpath 'C:\Users\JulioMedeiros\Desktop\Study1_EEG\eeglab14_1_2b'
eeglab
addpath(genpath('C:\Users\JulioMedeiros\Desktop\toolbox_rodolfo'))

% EEG = pop_loadset('filename','AB16092019_run01_GA_ANC0_factor2_win21_re250hz_QRS_BCG_BCG_fixed_filtered_1_45hz_inter_reref.set','filepath','C:\\Users\\JulioMedeiros\\Desktop\\analysis\\importfiles\\triggers\\GA\\250QRS\\1\\BCG\\fixed\\filtered\\');

infor
%%
cd('C:\\Users\\JulioMedeiros\\Desktop\\analysis\\importfiles\\triggers\\GA\\1000QRS\\BCG\\fixed\\filtered\\inter_reref')
files=dir('*.set');

for i=1:length(files)
    tic
    filename=files(i).name;
    disp(">>>>>>>>>>>")
    disp(strcat(">>>>>>",{' '},filename,{' '},'<<<<<<'))
    disp(">>>>>>>>>>>")
    EEG = pop_loadset('filename',filename,'filepath','C:\\Users\\JulioMedeiros\\Desktop\\analysis\\importfiles\\triggers\\GA\\1000QRS\\BCG\\fixed\\filtered\\inter_reref\\\epoching');
    EEG = eeg_checkset(EEG);
    output=EEG.epochsremovidos;
    container=[i,




fileID = fopen('C:\Users\JulioMedeiros\Desktop\epoching_infor.txt','a+');
fprintf(fileID,strcat(filename,' >>>>> e removed(',num2str(EEG.epochsremovidos),'): ',num2str(rem),' \n'));
fclose(fileID);
end