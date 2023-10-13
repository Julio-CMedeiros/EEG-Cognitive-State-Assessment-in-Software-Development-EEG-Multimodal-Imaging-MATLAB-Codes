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

cd('C:\Users\JulioMedeiros\Desktop\analysis\importfiles\triggers')
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

                    EEG = pop_fmrib_fastr(EEG,70,factor(j),windows(k),'keypad5',0,ANC(i),0,0,0,0.03,[63 64 65 66],'auto');
                    
                    EEG.setname = strcat(EEG.setname,'_GA_ANC', num2str(ANC(i)),'_factor',num2str(factor(j)),'_win',num2str(windows(k)));
                    
                    EEG = eeg_checkset( EEG );
                    EEG = pop_saveset( EEG, 'filename',name,'filepath',strcat(path,'\GA\'));
                    EEG = eeg_checkset( EEG );
                end
            end
        end
    end

