% ----------------------------------------------
% Script Name: GA_cleaning.m
% Author: Julio Medeiros
% Email: juliomedeiros@dei.uc.pt
% Institution: University of Coimbra (UC), Centre for Informatics and Systems of the University of Coimbra (UC)
% Date: 10/09/2023
% Description: This script is used to preprocess Gradient Artifact (GA) from the EEG data using EEGLAB.
% ----------------------------------------------

EEG.etc.eeglabvers = '14.1.2'; % this tracks which version of EEGLAB is being used, you may ignore it
timer_container=[];
windows=[21];
factor=[2];
ANC=[0];
cont=0;

% cd('D:\Data_study1\fmri free')
% 
% subject=dir('*');
% subject=subject(3:end,:);
% 
% % for s=3:length(subject)
% 
% for s=1:length(subject)
%     tic
%     
%     subject_file=subject(s).name;
%     cd(strcat('D:\Data_study1\fmri free\',subject_file,'\EEG'))
%     run_files=dir('*inside Data.cnt');
%     
%     for m=1:length(run_files)
%         name_file=run_files(m).name;
%         run=regexp(name_file, '\d+', 'match');
%         EEG = pop_loadcnt(strcat('D:\Data_study1\fmri free\',subject_file,'\EEG\',name_file), 'dataformat', 'auto', 'keystroke', 'on', 'memmapfile', '');

% cd('C:\Users\JulioMedeiros\Desktop\analysis\importfiles\triggers')
cd('C:\Users\JulioMedeiros\Desktop\analysis\importfiles\problemas')
path=pwd;

files=dir('*.set');

for s=1:length(files)
    filename=files(s).name;
    EEG = pop_loadset('filename',filename,'filepath',path);
    EEG = eeg_checkset( EEG );        
        for i=1:length(ANC)
            for j=1:length(factor)
                for k=1:length(windows)
                    cont=cont+1;
                    %             EEG = pop_loadcnt('D:\Data_study1\fmri free\AB16092019\EEG\Acquisition 01inside Data.cnt' , 'dataformat', 'auto', 'keystroke', 'on', 'memmapfile', '');
                    % %             [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname','filename','gui','off');
                    %             [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, cont,'retrieve',1,'study',0);
                    name=strcat(EEG.setname,'_GA_ANC', num2str(ANC(i)),'_factor',num2str(factor(j)),'_win',num2str(windows(k)));
                    tic
                    EEG = pop_fmrib_fastr(EEG,70,factor(j),windows(k),'keypad5',0,ANC(i),0,0,0,0.03,[63 64 65 66],'auto');
                    
%                     tempo=toc;
                    %                     [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname',name,'gui','off');
%                     timer_container=[timer_container; [ANC(i) factor(j) windows(k) tempo/60]];
                    EEG.setname=name;
                    EEG = eeg_checkset( EEG );
                    EEG = pop_saveset( EEG, 'filename',name,'filepath',strcat(path,'\GA\'));
                    EEG = eeg_checkset( EEG );
                end
            end
        end
    end

