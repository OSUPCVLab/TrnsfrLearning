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
[sequence_name_list, max_frames, track_or_detect, fixed, BB_type, LF_Array,  topNum_Array, SA_multiplier_Array, bb_H_W_std_Multiplier_Array, bb_learning_ratio_Array, max_iter_Array, error_thresh_Array, KF_switch, Q_Array, R_Array, data_folder_path, clip_dir, model_dir, net_weights, net_model, net] = userInputParameters();
frames_analyzed=100;
repeat=0;
n_HP=9;
while repeat<10 % Controls number of trials completed
    repeat=repeat+1;
    
    opt_HP_FF=zeros(frames_analyzed,n_HP);
    BB_opt_HP_FF=zeros(frames_analyzed);
    for seq_count=1:length(sequence_name_list)
        % Set Clip Directory and Load Clip Info: images, gt BB
        sequence_name=sequence_name_list{seq_count};
        sequence_path=[clip_dir,sequence_name,'/'];
        Files = dir(strcat(sequence_path,'*.jpg'));
        LengthFiles = length(Files);
        ground_truth_path=[clip_dir,sequence_name,'/groundtruth.txt'];
        true_boxes=load(ground_truth_path);
        
        % Create Save Directory
        save_folder=[ data_folder_path '\' num2str(repeat) '\' sequence_name '\'];
        SF_exists=exist(save_folder,'dir');
        
        if SF_exists~=7
            mkdir(save_folder);
        end
        
        % Load Ground Truth BB
        corner_xs=[true_boxes(1,1), true_boxes(1,3), true_boxes(1,5), true_boxes(1,7)];
        corner_ys=[true_boxes(1,2), true_boxes(1,4), true_boxes(1,6), true_boxes(1,8)];
        gt_BB=[min(corner_xs),min(corner_ys),max(corner_xs)-min(corner_xs),max(corner_ys)-min(corner_ys)];
        
        for current_frame_n=1:frames_analyzed
            if current_frame_n==1
                % Initialize BoW and KF Parameters
                estimated_BB=gt_BB;
                frame_BoW=ones(1000,1)/1000;
                frame_qxy=[gt_BB(1)+gt_BB(3)/2 gt_BB(2)+gt_BB(4)/2 0 0 0 0]';
                frame_Pxy=eye(6,6);
            end
            % Run Genetic Optimization
            [GO_HP_vector]=GEN_SS_GO(clip_dir, sequence_name, current_frame_n, estimated_BB, frame_BoW, frame_qxy, frame_Pxy, max_frames, fixed, KF_switch, track_or_detect, net); 
            
            %Update BoW, qxy, Pxy with Optimized HP
            HP_vector=GO_HP_vector;
            algorithm_settings=[current_frame_n max_frames fixed KF_switch track_or_detect];
            [mean_bbo, frame_BoW, frame_qxy, frame_Pxy]=GEN_SS_CLIP_ANALYSIS(clip_dir, sequence_name, estimated_BB, current_frame_n, max_frames, HP_vector, frame_BoW, frame_qxy, frame_Pxy, algorithm_settings, net);
           
            opt_HP_FF(current_frame_n,:)=GO_HP_vector;
            BB_opt_HP_FF(current_frame_n)=mean_bbo;
        end
        save([save_folder 'FF_Opt_HP.mat'],'opt_HP_FF');
        save([save_folder 'FF_Opt_HP_BBO.mat'], 'BB_opt_HP_FF')
        
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