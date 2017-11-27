function [sequence_name_list, max_frames, track_or_detect, fixed, BB_type, LF_Array,  topNum_Array, SA_multiplier_Array, bb_H_W_std_Multiplier_Array, bb_learning_ratio_Array, max_iter_Array, error_thresh_Array, KF_switch, Q_Array, R_Array, data_folder_path, clip_dir, model_dir, net_weights, net_model, net]=userInputParameters()
% Sequences to be Analyzed
sequence_name_list={'basketball', 'car1', 'car2', 'pedestrian1','pedestrian2','road','racing','gymnastics1'};%'basketball', 'car1', 'car2', 'pedestrian1','pedestrian2','road','racing','gymnastics1'};
max_frames=2; % The max number of frames analyzed from each clip

% Type of Analysis
track_or_detect=1; % 0=Detecting, 1=Tracking
fixed=3; % Use 3.(1) BB H,W fixed to original; (2) std_multi, (3) learn previous estimated BB
BB_type=2; % Use 2. The type of bounding box used 1=square, 2=rectangle

%BoW Parameters
LF_Array=[.01 0.05 0.1]; %Learning factor used in BoW posterior estimated class distribution
topNum_Array=[5 10 50]; %8 10  The number of highested scoring classes for each BoW update

% BB Estimate Parameters
SA_multiplier_Array=[1 1.5 2]; %  The relative size of the search area compared to the bounding box
bb_H_W_std_Multiplier_Array=[3 4 5]; % 5  STD multiplier for estimating BB H,W
bb_learning_ratio_Array=[0.05 0.1]; %0.1

% 2D Guassian Fit Parameters
max_iter_Array=[5 25 50];
error_thresh_Array=[1e-6];

%Kalman Filter Parameters
KF_switch=1;
Q_Array=[0.1 1 10 100 1000];
R_Array=[10];

% Relevant Directories
data_folder_path='./11_16_18_GO_frame_by_frame_opt/'; %_w_SA_multiplier_' num2str(SA_multiplier) '_HW_Multiplier_' num2str(bb_H_W_std_Multiplier) '_WH_LF_' num2str(bb_learning_ratio) '_Q_' num2str(Q) '_R_' num2str(R) '/']; % Where the results are saved
clip_dir='C:/Data Sets/VOT_2015_Clips/'; % VOT clip directory
model_dir='C:/Models/Caffe/'; % Caffe models directory

% CNN Initialization
addpath('C:\libraries\caffe-windows-master\matlab'); % Included Library
net_weights = [model_dir 'imagenet_googleletCAM_train_iter_120000.caffemodel'];
net_model = [model_dir 'deploy_googlenetCAM.prototxt'];
net = caffe.Net(net_model, net_weights, 'test');
end