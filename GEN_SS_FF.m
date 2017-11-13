function [estimated_BB, BoW, qxy, Pxy]=GEN_SS_FF(frame, previous_BB, qxy, Pxy, previous_positions, BoW, HP_vector, algorithm_settings, net)  
% Unpack HP and Setting Inputs
LF=HP_vector(1);
topNum=HP_vector(2);
SA_multiplier=HP_vector(3);
bb_H_W_std_Multiplier=HP_vector(4);
bb_learning_ratio=HP_vector(5);
max_iter=HP_vector(6);
error_thresh=HP_vector(7);
Q=HP_vector(8);
R=HP_vector(9);

fixed=algorithm_settings(1);
KF_switch=algorithm_settings(2);
track_or_detect=algorithm_settings(3);

img_size=size(frame);

% Create Image Sample Search Area (SA)
SA_box=GEN_SS_SAMPLE_IMAGE(img_size, previous_BB, SA_multiplier);

% Create CAM Volume
[~, ~, CAM_volume]=run_CNN(net, frame, SA_box);

% Predict BB
KF_inputs=[Q R];
Gauss_fit_inputs=[max_iter, error_thresh, bb_H_W_std_Multiplier, bb_learning_ratio];
[estimated_BB, qxy, Pxy]=GEN_SS_PREDICT_BB(CAM_volume, BoW, qxy, Pxy, SA_box, Gauss_fit_inputs, KF_inputs, previous_positions, img_size);

% Learn Target Features
[identity_results, value, ~]=run_CNN(net, frame, estimated_BB);
BoW=GEN_SS_BoW_Update(BoW, identity_results, value, LF, topNum);


end
