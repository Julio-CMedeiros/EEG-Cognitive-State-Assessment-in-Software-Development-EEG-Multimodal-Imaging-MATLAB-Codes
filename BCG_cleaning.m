addpath 'C:\Users\JulioMedeiros\Desktop\Study1_EEG\eeglab14_1_2b'
eeglab

cd('C:\\Users\\JulioMedeiros\\Desktop\\analysis\\importfiles\\triggers\\GA\\1000QRS\\')

files=dir('*.set');

for i=1:length(files)

    filename=files(i).name;
    EEG = pop_loadset('filename',filename,'filepath','C:\\Users\\JulioMedeiros\\Desktop\\analysis\\importfiles\\triggers\\GA\\1000QRS');

    
    EEG = eeg_checkset( EEG );
    EEG = pop_fmrib_pas(EEG,'qrs','obs',3);
    EEG = eeg_checkset( EEG );
%     EEG.data(64,:)=ECG;
    EEG.setname=strcat(filename(1:end-4),'_BCG');
    EEG = pop_saveset( EEG, 'filename',strcat(EEG.setname,'.set'),'filepath','C:\\Users\\JulioMedeiros\\Desktop\\analysis\\importfiles\\triggers\\GA\\1000QRS\\BCG\\');
    EEG = eeg_checkset( EEG );
end
