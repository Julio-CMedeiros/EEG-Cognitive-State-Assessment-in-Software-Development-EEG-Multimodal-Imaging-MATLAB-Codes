
% %% Configuration
clear, clc, close all;
% load('C:\Users\JulioMedeiros\Desktop\dataset_hrf_and_features.mat')
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
        bold_start=(round(tasks_events(1).latency/1000)/3)+2+1; %+2 por ser os 2 TR que removo iniciais e +1 porque é o indice no vector a começar
        
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
    
%%

load header

% Run / Subject Lists
feedbacks = { 'af' 'vf' 'tf' };
feedbacks_vtc = { 'fa' 'fv', 'trans'};

subjects = { 'AS' 'GS' 'JD' 'JS' 'GC' 'MB' 'ML' 'MR' 'PS' 'RC'};% 'MS' 'CA' 'CP' 'JL' 'BD' };
subjects_names = { 'AlexandreSayal' 'GilbertoSilva' 'JoaoDuarte' 'JoaoSebastiao' 'GabrielCosta' 'MiguelBernardes' 'MarcoLeal' 'MarioRibeiro' 'PatriciaSantos' 'RicardoCouceiro'};% 'MS' 'CA' 'CP' 'JL' 'BD' };


vmr = xff( 'utils/MarcoLeal_TAL.vmr' );
SAMPLE_SIZE = 300;
correlations = [];

statfn = 'min';

for predictor = header
    name = predictor{1};
    
    corrs = [];
    
    for sbji = 1:length(subjects)
        subject = subjects{sbji};
        
        for fbi = 1:length(feedbacks)
            feedback = feedbacks{fbi};
            
            
            map = xff( [resultsfolder sprintf('VMP/%s.vmp', name) ] );
            corrs = [ corrs ; map.Map.VMPData(:)' ];
        end
    end
    
    Fr = 0.5 * log( (1+corrs) ./ (1-corrs+0.00000000001));
    z = Fr .*  sqrt( (SAMPLE_SIZE - 3) ./ 1.06 );
    x = mean(z);
    mFr = mean(Fr);
    
    signifiscance_fisher = normcdf(-abs(x),0,1);
    m = (exp(2*mFr)-1) ./ (exp(2*mFr)+1);
    
    map.Map.VMPData(:) = m;
    
    stat = VOIStatisticsExtraction(map, 'AS', voisfolder);
    %correlations = [ correlations ; stat.literature.(statfn) ];
    correlations = [ correlations ; stat.localizer_group.(statfn) ];
    
end

%%

% %voi = xff([ voisfolder 'literature.voi' ]);
% voi = xff([ voisfolder 'localizer_group.voi' ]);
%
% for i=1:voi.NrOfVOIs
%     fprintf('%s;;', voi.VOI(i).Name);
% end
% fprintf('\n');
%
% NTOP = 7;
% for j=1:NTOP
%
%     for i=1:voi.NrOfVOIs
%         [vals, idxs] = sort(correlations(:,i), 'ascend');
%
%         fprintf('%s;',header{idxs(j)}(7:end));
%         fprintf('%.2f;', vals(j));
%     end
%
%     fprintf('\n');
% end
%
%
%
% %
% % % load vmr
% % vmr = xff('C:\Users\alexa\Desktop\DATA_Marco\fmri\AlexandreSayal\anatomical\PROJECT\AlexandreSayal_TAL.vmr');
% %
% % % load fmr
% % fmr = xff('C:\Users\alexa\Desktop\DATA_Marco\fmri\AlexandreSayal\run-fv-data\PROJECT\PROCESSING\AlexandreSayal_fv_SCCAI_3DMCTS_LTR_THPGLMF2c.fmr');
% %
% % % link vtc
% % vtc = xff('C:\Users\alexa\Desktop\DATA_Marco\fmri\AlexandreSayal\run-fv-data\PROJECT\ANALYSIS\AlexandreSayal_fv_SCCAI_3DMCTS_LTR_THPGLMF2c_TAL.vtc');
% % vtc2 = xff('C:\Users\alexa\Desktop\DATA_Marco\fmri\AlexandreSayal\run-fv-data\PROJECT\ANALYSIS\AlexandreSayal_fv.vtc');
% % % load vmp
% % vmp = xff('trash/exemplo_correlation.vmp');
% %
% %
% %
% % %%
% %
% % bb = vtc.BoundingBox();
% %
% %
% %
% %
% %
% %
% %
% % %%
% % for i = 1:size(vtc.VTCData, 2)
% %     for j = 1:size(vtc.VTCData, 3)
% %         for k = 1:size(vtc.VTCData, 4)
% %             c = corr(double(rtc), double(vtc.VTCData(:,i,j,k)));
% %
% %             if c > 0.9
% %                 [i, j, k]
% %             end
% %         end
% %     end
% % end
% %
% % %%
% % for i = 1:size(vtc.VTCData, 2)
% %     for j = 1:size(vtc.VTCData, 3)
% %         for k = 1:size(vtc.VTCData, 4)
% %             c = round(vmp.Map.VMPData(i, j , k), 4);
% %
% %             if c == -0.0291
% %                 [i, j, k]
% %             end
% %         end
% %     end
% % end
% % disp('done');
% %