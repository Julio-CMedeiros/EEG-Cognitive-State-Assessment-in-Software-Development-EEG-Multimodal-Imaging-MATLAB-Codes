% clear all;close all; clc

eeglab
clear all; close all; clc

cd('C:\Users\JulioMedeiros\Desktop\analysis\importfiles\triggers')

files=dir('*.set');

container_infor={};
container_99_files=[];
container_15_files=[];

contador=0;

for i=1:length(files)
    
    name_file=files(i).name;
    EEG.etc.eeglabvers = '14.1.2'; % this tracks which version of EEGLAB is being used, you may ignore it
    EEG = pop_loadset('filename',name_file,'filepath','C:\\Users\\JulioMedeiros\\Desktop\\analysis\\importfiles\\triggers\\');
    EEG = eeg_checkset( EEG );
    
    if sum(ismember({EEG.event.type},'99'))==0
        contador=contador+1;
        container_infor{contador,1}=i;
        container_infor{contador,2}=name_file;
        container_infor{contador,3}=99;
        container_99_files=[container_99_files;i]
    end
    
    if sum(ismember({EEG.event.type},'15'))<3
        contador=contador+1;
        container_infor{contador,1}=i;
        container_infor{contador,2}=name_file;
        container_infor{contador,3}=15;
        container_infor{contador,4}=sum(ismember({EEG.event.type},'15'));
        container_15_files=[container_15_files;i];
    end
end

% save('C:\Users\JulioMedeiros\Desktop\triggersinfor','container_infor','container_99_files','container_15_files')

