
% %% Configuration
clear, clc, close all;
load('C:\Users\JulioMedeiros\Desktop\dataset_ALL_hrf_and_features.mat')
load('C:\Users\JulioMedeiros\Desktop\feature_name_and_idx.mat')

%
% Settings Structure
configs = struct();
%
% % Add folders to path
% addpath('utils');
%
% % Load conversion data
% load('conversion.mat');
%
% % Add data folder
%
%
tasks={'cruz1','codigobug','cruz2','codigoneutro','cruz3','texto'};
bold_contrast={'voisBugvsBaseline','voisCodesBugvsCodesNeutro','voisCodesBugvsTxts','voisCodesNeutrovsTxts','voisSuspvsBaseline'};

task_for_analyse=2;
contrast_for_analyse=5;

datafolder='C:\Users\JulioMedeiros\Desktop\vtc\vtc';
configs.dataRoot = fullfile(datafolder);
%
% % NOTICE THIS! configure
% use_hrf = true;
%
%
% Run / Subject Lists
feedbacks = { 'af' 'vf' 'tf' };
feedbacks_vtc = { 'fa' 'fv', 'trans'};

cd('C:\Users\JulioMedeiros\Desktop\BOLD_timecourses\BOLD_timecourses')
bold_files=dir('*.mat');
bold_files_names={bold_files.name};



subjects = {all_data_structure{:,3}}';
subjects_names = {all_data_structure{:,3}}';
%% Iteration

transformed_features = {'mean', 'max', 'min'};
delays_hrf = {'hrf_4';'hrf_5';'hrf_6';'hrf_7'};

for sbji = 48:length(subjects)
    tic
    
    % Subject Name and Folder Name
    subject = subjects{sbji};
    subjectname = subjects_names{sbji};
    
    fprintf('---- Subject %s ----\n',subjectname);
    %     resultsfolder=strcat('C:\Users\JulioMedeiros\Desktop\mapas\',subjectname);
    %     mkdir(resultsfolder)
    
    
    %%Select VTC
    cd(configs.dataRoot)
    % Select .vtc file to process
    configs.vtcfile = fullfile( configs.dataRoot,...
        [subject '_MIA_SCCTBL_3DMCTS_SD3DSS4.00mm_THPGLMF2c_TAL.vtc'] );
    %         configs.vtcfile = fullfile(subject, '_MIA_SCCTBL_3DMCTS_SD3DSS4.00mm_THPGLMF2c_TAL.vtc');
    
    if logical(sum(ismember(bold_files_names,strcat(subject,'_',bold_contrast{contrast_for_analyse},'.mat'))))
        load(strcat('C:\Users\JulioMedeiros\Desktop\BOLD_timecourses\BOLD_timecourses\',subject,'_',bold_contrast{contrast_for_analyse},'.mat'))
        bold_signal=voi_tc;
        tasks_events=all_data_structure{sbji, 4}.ownevents.(tasks{task_for_analyse});
        bold_start=(round(tasks_events(1).latency/1000)/3)+2+1; %+2 por ser os 2 TR que removo iniciais e +1 porque   o indice no vector a come ar
        
        % Link vtc to tal.vmr
%         vtc = xff(configs.vtcfile );
        
        
        
        %%Correlation Analysis
        
        
%         predictors = [];
%         header = {};

        for hrf_delay = 4
%         for hrf_delay = 1:length(delays_hrf)

            %             delays_hrf{hrf_delay}
            predictors = [];
            header = {};
            
%             resultsfolder=strcat('D:\mapas_',delays_hrf{hrf_delay},'\',subjectname);
            resultsfolder=strcat('C:\Users\JulioMedeiros\Desktop\mapas_',delays_hrf{hrf_delay},'\',subjectname);
            
            mkdir(resultsfolder)
            
            for transformed_feat = 1:length(transformed_features)
%                 transformed_features{transformed_feat}
                for features_type = 1:length({feature_name_and_idx{:,1}})
%                 for features_type = 1:2100
                    
                    % load features from file
                    features=all_data_structure{sbji, 4}.hrf.(delays_hrf{hrf_delay}).codigobug.(transformed_features{transformed_feat})(:,features_type);
                    
                    
                    % Condition name = feature name
                    conditionName  = sprintf('%s_%s', transformed_features{transformed_feat}, feature_name_and_idx{features_type});
                    
                    
                    % feature identification
                    name = sprintf('%s_%s_%s', subject, delays_hrf{hrf_delay}, conditionName);
                    header = [header {name}];
                    
                    predictors = cat(2, predictors, features);
                                                        
                end
            end
            
            vtc = xff(configs.vtcfile );
            
            predictors=predictors(2:end-10,:);
            
            task_duration=size(predictors(:,1),1);
            
            vtc.VTCData=vtc.VTCData(bold_start+2:bold_start+2+task_duration-1,:,:,:);  %+2 porque tamos a tirar os primeiros 3 segundos (=TR) para ter em conta o delay
            vtc.NrOfVolumes=size(vtc.VTCData,1);
            
            % PCA Predictor
            
            %         [K, pcapred] = pca(predictors);
            %
            %         predictors = [predictors pcapred(:,1)];
            %         header = [header sprintf('%s_PCA', subject)];
            
            %%Run correlations
            
            for i = 1:length(header)
                
                name = header{i};
                features = predictors(:, i);
                
                map = vtc.Correlate(features);
%                             correlations = VOIStatisticsExtraction(map, subject, voisfolder);
                
                map.SaveAs( [resultsfolder sprintf('/%s.vmp', name) ]);
                %             save( [resultsfolder name '.mat'], 'correlations');
                
            end
            
            %     end
            clearvars map vtc features  predictors
        end
    end
    toc
end
    disp('Script finished.')
    
