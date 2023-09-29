% EEGLAB history file generated on the 16-Sep-2020
% ------------------------------------------------
EEG.etc.eeglabvers = '14.1.2'; % this tracks which version of EEGLAB is being used, you may ignore it

cd('C:\\Users\\JulioMedeiros\\Desktop\\analysis\\importfiles\\triggers\\GA\\1000QRS\\BCG\\')

files=dir('*.set');

%REMOVO os 2 primeiros TR's logo removo os primeiros 6 secs

for i=1:length(files)
    filename=files(i).name;
    EEG = pop_loadset('filename',filename,'filepath','C:\\Users\\JulioMedeiros\\Desktop\\analysis\\importfiles\\triggers\\GA\\1000QRS\\BCG');
    %     idx_start=find(strcmp({EEG.event.type},'99'));
    %     time_start=(EEG.event(idx_start).latency)/EEG.srate;
    %     EEG = pop_select( EEG,'notime',[0 time_start] );
    %     EEG = eeg_checkset( EEG );
    %     EEG = pop_select( EEG,'notime',[EEG.xmax-20 EEG.xmax] );
    idx_start_keypad=find(strcmp({EEG.event.type},'keypad5'));
    time_start=(EEG.event(idx_start_keypad(2)).latency)/EEG.srate;
    EEG = pop_select( EEG,'notime',[0 time_start] );
    EEG = eeg_checkset( EEG );
    idx_start_15=find(strcmp({EEG.event.type},'15'));
    time_start_15=(EEG.event(idx_start_15(3)).latency)/EEG.srate;
    EEG = pop_select( EEG,'notime',[time_start_15 EEG.xmax] );
    EEG = eeg_checkset( EEG );
    EEG.setname=strcat(filename(1:end-4),'_BCG_fixed');
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename',strcat(EEG.setname,'.set'),'filepath','C:\\Users\\JulioMedeiros\\Desktop\\analysis\\importfiles\\triggers\\GA\\1000QRS\\BCG\\fixed\\');
    EEG = eeg_checkset( EEG );
end


