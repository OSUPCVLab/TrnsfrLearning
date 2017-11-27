function VOT_Tracking_Error_Analysis(sequence_name_list, topNum, LF, track_or_detect, BB_type, max_frames, data_folder_path)
%%%%%%%%%%%%%%%%%%%%%%%% Overview %%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs: topNum, LF, sequence_name_list, BB_type, data_folder_path
% Dependencies: none
% Uses: SEQUENCE_NAME_error_all_bbo_dist_w_LF_?_n_?.mat
% Saves: mean_error_bbo_dist_mat.mat

% Set Data Folder Path to Selected BB Type
if track_or_detect==1
    if BB_type==1
         data_folder_path=[data_folder_path 'tracking/square_BB_results/'];
    else
         data_folder_path=[data_folder_path 'tracking/rectangle_BB_results/'];
    end
else
    if BB_type==1
         data_folder_path=[data_folder_path 'detecting/square_BB_results/'];
    else
         data_folder_path=[data_folder_path 'detecting/rectangle_BB_results/'];
    end
end

% Initiate Variables
n_seq=length(sequence_name_list);
bbo_all=zeros(max_frames-1,n_seq);
dist_error_all=zeros(max_frames-1,n_seq);
bbo_mean=zeros(1,n_seq);
bbo_std=zeros(1,n_seq);
dist_error_mean=zeros(1,n_seq);
dist_error_std=zeros(1,n_seq);

for i=1:n_seq
    % Set Data Directory
    sequence_name=sequence_name_list{i};
    addpath([data_folder_path sequence_name '_results/LF' num2str(LF) 'n' num2str(topNum)]);
    
    % Load SEQUENCE_NAME_error_all_bbo_dist_w_LF_?_n_?.mat
    load([sequence_name '_error_all_bbo_dist_w_LF_' num2str(LF) '_n_' num2str(topNum) '.mat'])
    [n_frames,~]=size(error_all_bbo_dist);
    
    % Calculate Statistics of BBO and Distance Errors
    bbo_all(1:n_frames,i) = error_all_bbo_dist(:,1);
    bbo_mean(i)=mean(error_all_bbo_dist(:,1));
    bbo_std(i)=std(error_all_bbo_dist(:,1));
    
    dist_error_all(1:n_frames,i) = error_all_bbo_dist(:,2);
    dist_error_mean(i)=mean(error_all_bbo_dist(:,2));
    dist_error_std(i)=std(error_all_bbo_dist(:,2));
    
    % Print BB Overlap Ratio for Each Sequence
    h1=figure(1)
    subplot(n_seq,1,i)
    plot(error_all_bbo_dist(:,1));
    ylabel(sequence_name);
    if i==1
        title(['BB Overlap Ratio w/ LF ' num2str(LF) ' n ' num2str(topNum)]);
    end
    if i==n_seq
        xlabel('Frame')
    end
    
    % Print Distance Error for Each Sequence
    h2=figure(2)
    subplot(n_seq,1,i)
    plot(error_all_bbo_dist(:,2));
    ylabel(sequence_name)
    
    if i==1
        title(['Distance Error from Target Center w/ LF ' num2str(LF) ' n ' num2str(topNum)]);
    end
    if i==n_seq
        xlabel('Frame')
    end    
end


% Print
h3=figure
subplot(2,1,1)
plot(bbo_all);
legend(sequence_name_list);
title(['BB Overlap Ratio w/ LF ' num2str(LF) ' n ' num2str(topNum)]);
ylabel('BBO Ratio');

subplot(2,1,2)
plot(dist_error_all);
legend(sequence_name_list);
title(['Distance Error from Target Center w/ LF ' num2str(LF) ' n ' num2str(topNum)]);
xlabel('Frame')
ylabel('Distance')

% Print Mean BBO and Distance with Error Bars for Each Clip
h4=figure
subplot(2,1,1)
errorbar(bbo_mean,bbo_std,'*','LineWidth',3)
title(['Mean BBO Ratio w/ LF ' num2str(LF) ' n ' num2str(topNum)])
xticks(1:n_seq);
set(gca, 'XtickLabel',sequence_name_list);

subplot(2,1,2)
errorbar(dist_error_mean,dist_error_std,'*','LineWidth',3)
title(['Mean Distance Error w/ LF ' num2str(LF) ' n ' num2str(topNum)])
xticks(1:n_seq);
set(gca, 'XtickLabel',sequence_name_list);


mean_error_bbo_dist=[bbo_mean',bbo_std',dist_error_mean',dist_error_std'];


%%%%%%%%%%%%%%%%%%%%%%%%%%%% Save Data %%%%%%%%%%%%%%%%%%%%%%%%%%%%
save_folder=[data_folder_path '/LF' num2str(LF) 'n' num2str(topNum)];
SF_exists=exist(save_folder,'dir');

if SF_exists~=7
    mkdir(save_folder);
end

save_name=[save_folder '/Separate_Clip_BBO_Ratio_w_LF_' num2str(LF) '_n_' num2str(topNum) '.fig'];
savefig(h1, save_name);
save_name=[save_folder '/Separate_Clip_Dist_Error_w_LF_' num2str(LF) '_n_' num2str(topNum) '.fig'];
savefig(h2, save_name);
save_name=[save_folder '/Together_BBO_Ratio_and Dist_Error_w_LF_' num2str(LF) '_n_' num2str(topNum) '.fig'];
savefig(h3, save_name);
save_name=[save_folder '/Mean_BBO_Ratio_and_Dist_Error_w_LF_' num2str(LF) '_n_' num2str(topNum) '.fig'];
savefig(h4, save_name);
save([save_folder '/Mean_BBO_Ratio and STD_w_LF_' num2str(LF) '_n_' num2str(topNum) '.mat'],'mean_error_bbo_dist');

end
