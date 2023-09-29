clear all; close all; clc

eeglab

EEG.etc.eeglabvers = '14.1.2'; % this tracks which version of EEGLAB is being used, you may ignore it

cd('C:\\Users\\JulioMedeiros\\Desktop\\analysis\\importfiles\\triggers\\GA\\1000QRS\\BCG\\fixed\\filtered\\inter_reref\\epoching')

files=dir('*.set');

for i=44:length(files)
% for i=1
    tic
    filename=files(i).name;
    disp(">>>>>>>>>>>")
    disp(strcat(">>>>>>",{' '},filename,{' '},'<<<<<<'))
    disp(">>>>>>>>>>>")
    EEG = pop_loadset('filename',filename,'filepath','C:\\Users\\JulioMedeiros\\Desktop\\analysis\\importfiles\\triggers\\GA\\1000QRS\\BCG\\fixed\\filtered\\inter_reref\\epoching\\');
    EEG = eeg_checkset( EEG );
    
    %     idx_start=find(strcmp({EEG.event.type},'15'));
    %     time_start=(EEG.event(idx_start(end)).latency)/EEG.srate;
    %     EEG = pop_select( EEG,'notime',[time_start EEG.xmax] );
    %     EEG = eeg_checkset( EEG );
    
    EEG = pop_runica(EEG, 'extended',1,'interupt','on');
    EEG = eeg_checkset( EEG );
    
    EEG.setname=strcat(filename(1:end-4),'_ICAcomp');
    EEG = pop_saveset( EEG, 'filename',strcat(EEG.setname,'.set'),'filepath','C:\\Users\\JulioMedeiros\\Desktop\\analysis\\importfiles\\triggers\\GA\\1000QRS\\BCG\\fixed\\filtered\\inter_reref\\epoching\\ICAcomp');
    EEG = eeg_checkset( EEG );
    %         a=toc;
    %         fid=fopen(strcat('files_iter\','ICA_',num2str(i),'_',num2str(j),'_',person{i},'_',num2str(j),'.txt'),'w');
    %         fprintf(fid,(strcat('Time elapsed:',num2str(a),'secs.  >>>','maxstep: ',' ',num2str(EEG.icastep))));
    %         fclose(fid);
    disp(">>>>>>>>>>>")
    disp(strcat(">>>>>>",{' '},filename,{' '},'<<<<<<'))
    disp(">>>>>>>>>>>")
    toc
end
