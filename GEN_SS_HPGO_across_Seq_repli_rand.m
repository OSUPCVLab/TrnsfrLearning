%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script is the main method for the BoW Incremental Learning with the
% VOT2015 dataset. First, the input parameters are loaded using the
% userInputParameters.m script. The input parameters can be set by editing
% this script. Second, the variables are initiated. It should be noted that
% the variables are reset inbetween sequences, after it has been saved.
% Third, each frame of the selected sequence is analyzed.

% Frame Analysis Process
% The first frame of the sequence is used to initialize the BoW incremental
% layer. This is done by sampling 'n' of the highest scoring classes
% produced by inputing the bounding box region. For the first frame the
% bounding box region is dictated by a ground truth set by VOT2015. In
% detecting, the bounding boxregions are always the ground truth. In
% tracking, the estimated bounding box region is used. The BoW posterior
% estimation is updated using a learning factor 'LF'. The learning factor
% is a value between 0-1, where a value of 1 means the model is never
% updated, and 0 meaning the model is updated at each frame.

% With all subsequent frames, the BoW model is used to create an optimized
% class activation map (CAM). CAM as created by sampling the last
% convolution layer in the modified GoogLeNet after inputing a search
% region. The search region is created by scaling the bounding box region
% from the previous frame by a factor. As a default it is set to 2. The
% resulting CAM are summed using the probability of each class in the BoW
% model. The bounding box of the frame being analyzed is then predicted using
% a 2D guassin fit. The target centers are the means of the fit. The height
% and width are set to a constant. They can be estimated using the standard
% deviation of the fit. Once the bounding box region is estimated, the
% process is repeated. The BoW model is updated with the estimated bounding
% box region. A search area is created in the following frame by multplying
% the estimated bounding box by a factor. CAM are created from the serach
% region.


% The data from each clip is saved in a desctriptive folder architecture
% and naming scheme. For example the directory path shown below refers to
% the detection results using rectangular bounding boxes for the basketball
% sequence with a learning factor of 0.5 and a sample size of 20.
% ...\VOT_CAM_Tracking_6_2_2017\results\detecting\rectangle_BB_results\basketball_results\LF0.5n20

% Included in this script are two results analysis functions.
% (1) VOT_Tracking_Error_Analysis() and (2) LF_and_N_Peformance_Analysis().
% (1) produces bounding box overlap and distance to center error plots
% for each clip. (2) produces similar plots for each learning factor and
% sampling number.

% The resulting optimized CAM can be visualzed as a superposition on the
% search area of the image as either the full image or just the cropped
% search area by running print_Image_w_CAM() and create_AVI_from_PNG().

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear all; clc;
warning('off');
addpath(genpath('.\support_functions\'))
load('n_std_3.mat')
%%%%%%%%%%%%%%%%%%%%%%%%%% User Input Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%
repeat=0;
% Set genetic optimization input parameters
n_children=8;
param_limits=[0 1 1 .1 0 1 1E-15; 1 200 10 20 1 100 1];
param_type_int=[0 1 0 0 0 1 0];
generation_limit=100;
[sequence_name_list, max_frames, track_or_detect, fixed, BB_type, LF_Array,  topNum_Array, SA_multiplier_Array, bb_H_W_std_Multiplier_Array, bb_learning_ratio_Array, max_iter_Array, error_thresh_Array, KF_switch, Q_Array, R_Array, data_folder_path, clip_dir, model_dir, net_weights, net_model, net] = userInputParameters();

while repeat<10 % Controls number of trials completed
    repeat=repeat+1;
        
    for seq_count=1:length(sequence_name_list)
        % Set Clip Directory and Load Clip Info: images, gt BB
        sequence_name=sequence_name_list{seq_count}
        sequence_path=[clip_dir,sequence_name,'/'];
        Files = dir(strcat(sequence_path,'*.jpg'));
        LengthFiles = length(Files);
        
        % Set random start frame
        start_frame=1+floor(rand()*(LengthFiles-max_frames));
        
        save_folder=[ data_folder_path '\' num2str(repeat) '\' sequence_name '\'];
        SF_exists=exist(save_folder,'dir');
        
        if SF_exists~=7
            mkdir(save_folder);
        end
        
        
        % Genetic Optimization Initial Conditions
        parent_threshold=.01;
        parent1=param_limits(1,:);
        parent2=param_limits(2,:);
        initial_combination=[parent1;parent2];
        Top_Combination_Parents=initial_combination;
        Top_Combination_Parents_BBO=[0.1 0.1];
        previous_top_bbo=0.1;
        save([save_folder 'Top_Combination_Parents.mat'],'Top_Combination_Parents');
        save([save_folder 'Top_Combination_Parents_BBO.mat'], 'Top_Combination_Parents_BBO')
        
        alpha=1;
        improve=1;
        generation=0;
        generation_top_combination=zeros(generation_limit,9);
        generation_top_bbo=zeros(generation_limit,1);
        % load('parent_pool_store.mat')
        parent_pool_on=0;
        parent_pool_store=zeros(10,9);
        parent_pool_bbo_store=zeros(10,1);
        parents=0;
        use_whole_pool_on=0;
        bbo_zero_count=0;
        lost_target_count=0;
        
        % Begin Genetic Optimization
        while generation<generation_limit&&Top_Combination_Parents_BBO(1)<.99
            generation=generation+1;
            %         load('Top_Combination_Parents.mat')
            %         load('Top_Combination_Parents_BBO.mat')
            
            if use_whole_pool_on==1
                parent_pool=parent_pool_store;
            else
                parent_pool=parent_pool_store(1:parents,:);
            end
            
            % Breed Child Combinations
            [combination_matrix,alpha]=breed(Top_Combination_Parents(1,:), Top_Combination_Parents(2,:), param_limits,  param_type_int, alpha, n_children, improve, parent_pool_on, parent_pool);
            improve=0;
            child_bbo=zeros(n_children,1);
            
            % Test performance of each child combination
            for iii=1:n_children
                HP_vector=combination_matrix(iii,:);
                algorithm_settings=[start_frame max_frames fixed KF_switch track_or_detect];
                [mean_bbo]=GEN_SS_CLIP_ANALYSIS(clip_dir, sequence_name, start_frame, max_frames, HP_vector, algorithm_settings, net);

                child_bbo(iii)=mean(mean_bbo)
            end
            
            % Sort child combinations by performance
            [sort_bbo,sort_I]=sort(child_bbo,'descend');
            previous_top_bbo=sort_bbo(1)
            
            generation_top_combination(generation,:)=combination_matrix(sort_I(1),:);
            generation_top_bbo(generation)=sort_bbo(1);
            save([save_folder 'Genetic_Combination_Development.mat'],'generation_top_combination')
            save([save_folder 'Genetic_Combination_BBO_Development.mat'],'generation_top_bbo')
            
            similarity=[Top_Combination_Parents(1,:)/norm(Top_Combination_Parents(1,:))]*[combination_matrix(sort_I(1),:)/norm(combination_matrix(sort_I(1),:))]';
            
            % Compare top performers to previous top performers
            if sort_bbo(1)>Top_Combination_Parents_BBO(1)
                improve=1;
                Top_Combination_Parents(2,:)=Top_Combination_Parents(1,:);
                Top_Combination_Parents_BBO(2)=Top_Combination_Parents_BBO(1);
                Top_Combination_Parents(1,:)=combination_matrix(sort_I(1),:);
                Top_Combination_Parents_BBO(1)=sort_bbo(1);
                save([save_folder 'Top_Combination_Parents.mat'],'Top_Combination_Parents');
                save([save_folder 'Top_Combination_Parents_BBO.mat'], 'Top_Combination_Parents_BBO')
            elseif sort_bbo(1)>Top_Combination_Parents_BBO(2)&&similarity<0.90
                improve=1;
                Top_Combination_Parents(2,:)=combination_matrix(sort_I(1),:);
                Top_Combination_Parents_BBO(2)=sort_bbo(1);
                save([save_folder 'Top_Combination_Parents.mat'],'Top_Combination_Parents');
                save([save_folder 'Top_Combination_Parents_BBO.mat'], 'Top_Combination_Parents_BBO')
            end
            
            if sort_bbo(2)>Top_Combination_Parents_BBO(2)
                improve=1;
                Top_Combination_Parents(2,:)=combination_matrix(sort_I(2),:);
                Top_Combination_Parents_BBO(2)=sort_bbo(2);
                save([save_folder 'Top_Combination_Parents.mat'],'Top_Combination_Parents');
                save([save_folder 'Top_Combination_Parents_BBO.mat'], 'Top_Combination_Parents_BBO')
            end
            
            % Compare child perfromance to parent pool and incorporate
            for j=1:n_children
                if sort_bbo(j)>parent_threshold
                    parents=parents+1;
                    if parents>10
                        parents=1;
                        if parent_threshold<0.9
                            parent_threshold=parent_threshold+.1*(1-parent_threshold);
                        else
                            parent_threshold=parent_threshold+.1*(1-parent_threshold);
                        end
                        use_whole_pool_on=1;
                    end
                    parent_pool_store(parents,:)=combination_matrix(sort_I(j),:);
                    parent_pool_bbo_store(parents)=sort_bbo(j);
                    parent_pool_on=1;
                end
            end

        end
    end
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%
% full_or_cropped=1;
% print_Image_w_CAM(sequence_name, topNum, LF, track_or_detect, BB_type, SA_multiplier, data_folder_path, clip_dir, full_or_cropped)
%
% for i=1:length(sequence_name)
%      sequence_name=sequence_name{i};
%      create_AVI_from_PNG(topNum, LF, sequence_name, track_or_detect, BB_type, data_folder_path)
% end