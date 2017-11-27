% Testing GEN_SS_FF
close all; clear all; clc;
warning('off');

% Add Paths
addpath(genpath('.\support_functions\'))
load('n_std_3.mat')

% CNN Initialization
model_dir='C:/Models/Caffe/'; % Caffe models directory
addpath('C:\libraries\caffe-windows-master\matlab'); % Included Library
net_weights = [model_dir 'imagenet_googleletCAM_train_iter_120000.caffemodel'];
net_model = [model_dir 'deploy_googlenetCAM.prototxt'];
net = caffe.Net(net_model, net_weights, 'test');

% Clip Information
clip_dir='C:/Data Sets/VOT_2015_Clips/';
sequence_name='basketball';


% HP Combination
LF=.5;
topNum=100;
SA_multiplier=3.5;
bb_H_W_std_Multiplier=10;
bb_learning_ratio=0.1;
max_iter=45;
error_thresh=0.5;
Q=300;
R=600;
HP_vector=[LF topNum SA_multiplier bb_H_W_std_Multiplier bb_learning_ratio max_iter error_thresh Q R];

% Algorithm Settings
start_frame=1;
max_frames=10;
fixed=3;
KF_switch=1;
track_or_detect=1;
algorithm_settings=[start_frame max_frames fixed KF_switch track_or_detect];

[mean_bbo]=GEN_SS_CLIP_ANALYSIS(clip_dir, sequence_name, start_frame, max_frames, HP_vector, algorithm_settings, net)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Set Clip Directory
% sequence_path=[clip_dir,sequence_name,'/'];
% Files = dir(strcat(sequence_path,'*.jpg'));
% ground_truth_path=[clip_dir,sequence_name,'/groundtruth.txt'];
% true_boxes=load(ground_truth_path);
% 
% 
% for i=1:10
%     frame = imread([sequence_path,Files(i).name]);
% %     Load Bounding Box of Frame 'i' and Format to Uniform Order
%     corner_xs=[true_boxes(i,1), true_boxes(i,3), true_boxes(i,5), true_boxes(i,7)];
%     corner_ys=[true_boxes(i,2), true_boxes(i,4), true_boxes(i,6), true_boxes(i,8)];
%     gt_BB=[min(corner_xs),min(corner_ys),max(corner_xs)-min(corner_xs),max(corner_ys)-min(corner_ys)];
%     
%     if i==1
%         estimated_BB=gt_BB;
%         BB_center=[estimated_BB(1)+estimated_BB(3)/2 estimated_BB(2)+estimated_BB(4)/2];
%         previous_positions=[BB_center; BB_center];
%         BoW=ones(1000,1)/1000;
%         qxy=[BB_center 0 0 0 0]';
%         Pxy=eye(6,6);
%     end
%     [estimated_BB, BoW, qxy, Pxy]=GEN_SS_FF(frame, estimated_BB, qxy, Pxy, previous_positions, BoW, HP_vector, algorithm_settings, net);
%     previous_positions(2,:)=previous_positions(1,:);
%     previous_positions(1,:)=[estimated_BB(1)+estimated_BB(3)/2 estimated_BB(2)+estimated_BB(4)/2];
%     
%     
%     % Calculate BBO Ratio
%     bbi=rectint(estimated_BB,gt_BB);
%     bbo=2*bbi/(estimated_BB(3)*estimated_BB(4)+gt_BB(3)*gt_BB(4));
%     
%     % Calculate Distance to Center Error
%     gt_center=[current_BB(1)+gt_BB(3)/2,gt_BB(2)+gt_BB(4)/2];
%     estimated_center=[estimated_BB(1)+estimated_BB(3)/2, estimated_BB(2)+estimated_BB(4)/2];
%     dist=pdist([estimated_center; gt_center],'euclidean')/sqrt(estimated_BB(3)^2+estimated_BB(4)^2);
%     
% 
%     
% end