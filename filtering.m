EEG.etc.eeglabvers = '14.1.2'; % this tracks which version of EEGLAB is being used, you may ignore it

cd('C:\\Users\\JulioMedeiros\\Desktop\\analysis\\importfiles\\triggers\\GA\\1000QRS\\BCG\\fixed\\')

files=dir('*.set');

for i=1:length(files)
    filename=files(i).name;
    EEG = pop_loadset('filename',filename,'filepath','C:\\Users\\JulioMedeiros\\Desktop\\analysis\\importfiles\\triggers\\GA\\1000QRS\\BCG\\fixed\\');
    EEG = eeg_checkset( EEG );
    EEG=pop_chanedit(EEG, 'lookup','C:\\Users\\JulioMedeiros\\Desktop\\Study1_EEG\\eeglab14_1_2b\\plugins\\dipfit2.3\\standard_BESA\\standard-10-5-cap385.elp');
    EEG = eeg_checkset( EEG );
    EEG = pop_eegfiltnew(EEG, [],1,[],1,[],0);
    EEG = eeg_checkset( EEG );
    EEG = pop_eegfiltnew(EEG, [],45,[],0,[],0);
    EEG = eeg_checkset( EEG );
    EEG.referencesdata=EEG.data(63:66,:);
    EEG = pop_select( EEG,'nochannel',{'M2' 'M1' 'VEOG' 'EKG' 'PulseOx' 'Trigger'});
    EEG = eeg_checkset( EEG );
    EEG.setname=strcat(filename(1:end-4),'_filtered_1_45hz');
    EEG = pop_saveset( EEG, 'filename',strcat(EEG.setname,'.set'),'filepath','C:\\Users\\JulioMedeiros\\Desktop\\analysis\\importfiles\\triggers\\GA\\1000QRS\\BCG\\fixed\\filtered');
    EEG = eeg_checkset( EEG );
end
