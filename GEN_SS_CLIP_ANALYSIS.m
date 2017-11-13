function [mean_bbo, BoW, qxy, Pxy, estimated_BB]=GEN_SS_CLIP_ANALYSIS(clip_dir, sequence_name, estimated_BB, start_frame, max_frames, HP_vector, initial_BoW, initial_qxy, initial_Pxy, algorithm_settings, net)

% Set Clip Directory
sequence_path=[clip_dir,sequence_name,'/'];
Files = dir(strcat(sequence_path,'*.jpg'));
ground_truth_path=[clip_dir,sequence_name,'/groundtruth.txt'];
true_boxes=load(ground_truth_path);

bbo_all=zeros(max_frames,1);

for i=1:max_frames
    frame_n = (i-1)+start_frame;
    
    % Load Image and Ground Truth Bounding Boxes
    frame = imread([sequence_path,Files(frame_n).name]);
    corner_xs=[true_boxes(frame_n,1), true_boxes(frame_n,3), true_boxes(frame_n,5), true_boxes(frame_n,7)];
    corner_ys=[true_boxes(frame_n,2), true_boxes(frame_n,4), true_boxes(frame_n,6), true_boxes(frame_n,8)];
    gt_BB=[min(corner_xs),min(corner_ys),max(corner_xs)-min(corner_xs),max(corner_ys)-min(corner_ys)];
    
    % Initialize BoW, qxy, and Pxy on First Frame
    if i==1
        BB_center=[estimated_BB(1)+estimated_BB(3)/2 estimated_BB(2)+estimated_BB(4)/2];
        previous_positions=[BB_center; BB_center];
        BoW=initial_BoW;
        qxy=initial_qxy;
        Pxy=initial_Pxy;
    end
    
    % GEN_SS on Single Frame
    [estimated_BB, BoW, qxy, Pxy]=GEN_SS_FF(frame, estimated_BB, qxy, Pxy, previous_positions, BoW, HP_vector, algorithm_settings, net);
    previous_positions(2,:)=previous_positions(1,:);
    previous_positions(1,:)=[estimated_BB(1)+estimated_BB(3)/2 estimated_BB(2)+estimated_BB(4)/2];
    
    % Calculate BBO Ratio
    bbi=rectint(estimated_BB,gt_BB);
    bbo=2*bbi/(estimated_BB(3)*estimated_BB(4)+gt_BB(3)*gt_BB(4));
    bbo_all(i)=bbo;
    
    % Calculate Distance to Center Error
    gt_center=[gt_BB(1)+gt_BB(3)/2,gt_BB(2)+gt_BB(4)/2];
    estimated_center=[estimated_BB(1)+estimated_BB(3)/2, estimated_BB(2)+estimated_BB(4)/2];
    dist=pdist([estimated_center; gt_center],'euclidean')/sqrt(estimated_BB(3)^2+estimated_BB(4)^2);
    
end

mean_bbo=mean(bbo_all);
end