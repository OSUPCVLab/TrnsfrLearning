%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script runs frame by frame hayper-parameter genetic optimization for
% generative target tracking. This is completed by sampling a region of the
% image, called the search area. The search area is then input into the
% modified GoogLeNet to create the Class Activation Map Volume. The CAM
% volume is then used to estimate the BB size and location. The image
% region is then input into the modified GoogLeNet and the class activation
% scores are used to update the BoW appearance model.

% Version 2.3 Updates: 1.) Remove KF Q and R, 2.) Convert 2D Gaussian
% Iterative Solver with an Adjustment Computation, 3.) Sample image search
% area jitter combination (slightly shifting the search area up and down,
% and left and right, and summing the results to stabalize input.)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear all; clc;
warning('off');
addpath(genpath('.\support_functions\'))
load('n_std_3.mat')
%%%%%%%%%%%%%%%%%%%%%%%%%% User Input Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%
[sequence_name_list, max_frames, track_or_detect, fixed, BB_type, LF_Array,  topNum_Array, SA_multiplier_Array, bb_H_W_std_Multiplier_Array, bb_learning_ratio_Array, max_iter_Array, error_thresh_Array, KF_switch, Q_Array, R_Array, data_folder_path, clip_dir, model_dir, net_weights, net_model, net] = userInputParameters();
frames_analyzed=100;
repeat=0;
n_HP=5;
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