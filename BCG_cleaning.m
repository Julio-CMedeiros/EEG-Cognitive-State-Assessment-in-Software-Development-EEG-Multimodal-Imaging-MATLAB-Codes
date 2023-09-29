addpath 'C:\Users\JulioMedeiros\Desktop\Study1_EEG\eeglab14_1_2b'
eeglab

cd('C:\\Users\\JulioMedeiros\\Desktop\\analysis\\importfiles\\triggers\\GA\\1000QRS\\')

files=dir('*.set');

% for i=1:length(files)
for i=1:19
    filename=files(i).name;
    EEG = pop_loadset('filename',filename,'filepath','C:\\Users\\JulioMedeiros\\Desktop\\analysis\\importfiles\\triggers\\GA\\1000QRS');
%     ECG=EEG.data(64,:);
    
%     pop_eegplot( EEG, 1, 0, 1, 10);

%     %     qrs_missing=input('QRS missing:');
%     %     for j=1:qrs_missing
%     %         prompt=strcat('QRS ' , num2str(j), ' trigger:');
%     %         qrs_missing_timer=input(prompt);
%     %         EEG = pop_editeventvals(EEG,'insert',{1 [] [] []},'changefield',{1 'type' 'qrs'},'changefield',{1 'latency' qrs_missing_timer});
%     %     end
%     
%     confirm=0;
%     while confirm==0
%         [qrs_triggers_x,~]=ginput(3);
%         qrs_triggers_x
%         confirm=input('Confirm? Yes (1) No (0): ');
%     end
%     
%     qrs_triggers_timer=qrs_triggers_x/EEG.srate;
%     for m=1:length(qrs_triggers_timer)
%         EEG = pop_editeventvals(EEG,'insert',{1 [] [] []},'changefield',{1 'type' 'qrs'},'changefield',{1 'latency' qrs_triggers_timer(m)});
%     end
    
    EEG = eeg_checkset( EEG );
    EEG = pop_fmrib_pas(EEG,'qrs','obs',3);
    EEG = eeg_checkset( EEG );
%     EEG.data(64,:)=ECG;
    EEG.setname=strcat(filename(1:end-4),'_BCG');
    EEG = pop_saveset( EEG, 'filename',strcat(EEG.setname,'.set'),'filepath','C:\\Users\\JulioMedeiros\\Desktop\\analysis\\importfiles\\triggers\\GA\\1000QRS\\BCG\\');
    EEG = eeg_checkset( EEG );
end