clear all; close all; clc
addpath 'C:\Users\JulioMedeiros\Desktop\Study1_EEG\eeglab14_1_2b'

addpath 'C:\Users\JulioMedeiros\Desktop\Study1_EEG\eeglab14_1_2b\plugins\ICLabel1.2.5\viewprops'

eeglab

cd('C:\Users\JulioMedeiros\Desktop\analysis\importfiles\triggers\GA\1000QRS\BCG\fixed\filtered\inter_reref\epoching\ICAcomp\')

files=dir('*.set');

dbstop in pause
for i=44:length(files)
    i
    tic
    filename=files(i).name;
    EEG.etc.eeglabvers = '14.1.2'; % this tracks which version of EEGLAB is being used, you may ignore it
    disp(">>>>>>>>>>>")
    disp(strcat(">>>>>>",{' '},filename,{' '},'<<<<<<'))
    disp(">>>>>>>>>>>")
    EEG = pop_loadset('filename',filename,'filepath','C:\\Users\\JulioMedeiros\\Desktop\\analysis\\importfiles\\triggers\\GA\\1000QRS\\BCG\\fixed\\filtered\\inter_reref\\epoching\\ICAcomp\\');
    EEG = eeg_checkset( EEG );
    pop_eegplot( EEG, 0, 1, 1);
    movegui('west');
    
    %     aa=0;
    %     while aa==0
    %         aa=input('Continuar? Ranking certos? 1 (sim) 2 (saltar): ');
    %
    %         if aa==1
    %
    EEG = pop_iclabel(EEG, 'default');
    eeglab redraw;
    pop_viewprops(EEG, 0,[1:35],{'freqrange',[1,45]})
    
    %     pop_selectcomps(EEG, [1:60] );
        
    EEG = eeg_checkset( EEG );
    flag=1000;
    rem=[];
    while flag~=0
        flag=input('Componentes a remover: ');
        if flag>99
            flag=input('ERRO!!!!!! Componentes a remover: ');
        end
        if flag~=0
            rem=[rem,flag];
            sort(rem)
        end
        if flag==99
            pause
        end
    end
    
    rem=unique(rem);
    EEG.comp_removed=rem;
    EEG = pop_subcomp( EEG, rem, 0);
    removidas=length(rem)
    
    pop_eegplot( EEG, 1, 1, 1);
    cont=0;
    while cont~=1
        cont=input('>> eegplot >> Continue? Yes (1) or No (0): ');
    end
    %
    
    EEG.setname=strcat(filename(1:end-4),'_ICA_clean');
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename',strcat(EEG.setname,'.set'),'filepath','C:\\Users\\JulioMedeiros\\Desktop\\analysis\\importfiles\\triggers\\GA\\1000QRS\\BCG\\fixed\\filtered\\inter_reref\\epoching\\ICAcomp\\ICA\\');
    EEG = eeg_checkset( EEG );
    
    fileID = fopen('C:\Users\JulioMedeiros\Desktop\ICA_infor.txt','a+');
    fprintf(fileID,strcat(filename,' >>>>> components removed(',num2str(removidas),'): ',num2str(rem),' \n'));
    fclose(fileID);
    
    
    %         elseif aa==2
    %             rankings = fopen('C:\Users\JulioMedeiros\Desktop\Study1_EEG\eeglab14_1_2b\ICA_rankings.txt','a+');
    %             fprintf(rankings,strcat(name_file,' \n'));
    %             fclose(rankings);
    %
    %         else
    %             aa=0;
    %         end
close all
clc    
end
