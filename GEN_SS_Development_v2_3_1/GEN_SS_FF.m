function [estimated_BB, BoW, qxy, Pxy]=GEN_SS_FF(frame, previous_BB, qxy, Pxy, previous_positions, BoW, HP_vector, algorithm_settings, net)  
% Unpack HP and Setting Inputs
LF=HP_vector(1);
topNum=HP_vector(2);
SA_multiplier=HP_vector(3);
bb_H_W_std_Multiplier=HP_vector(4);
bb_learning_ratio=HP_vector(5);


img_size=size(frame);

% Create Image Sample Search Area (SA)
SA_box=GEN_SS_SAMPLE_IMAGE(img_size, previous_BB, SA_multiplier);

% Create CAM Volume
[~, ~, CAM_volume]=run_CNN(net, frame, SA_box);

% Predict BB
predict_inputs=[bb_H_W_std_Multiplier, bb_learning_ratio];
[estimated_BB, qxy, Pxy]=GEN_SS_PREDICT_BB(CAM_volume, BoW, qxy, Pxy, SA_box, predict_inputs, previous_positions, previous_BB, img_size);

% Learn Target Features
[identity_results, value, ~]=run_CNN(net, frame, estimated_BB);
BoW=GEN_SS_BoW_Update(BoW, identity_results, value, LF, topNum);


end
