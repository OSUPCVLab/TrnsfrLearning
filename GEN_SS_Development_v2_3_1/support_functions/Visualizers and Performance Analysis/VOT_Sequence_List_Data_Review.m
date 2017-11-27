function VOT_Sequence_List_Data_Review(combination_vector, data_folder_path, track_or_detect, BB_type, sequence_name_list, max_frames)
bbo_all_clips=zeros(length(sequence_name_list),max_frames-1);
dist_all_clips=zeros(length(sequence_name_list),max_frames-1);

mean_bbo=zeros(1,length(sequence_name_list));
mean_dist=zeros(1,length(sequence_name_list));

LF=combination_vector(1);
topNum=combination_vector(2);
SA_multiplier=combination_vector(3);
bb_H_W_std_Multiplier=combination_vector(4);
bb_learning_ratio=combination_vector(5);
max_iter=combination_vector(6);
error_thresh=combination_vector(7);
Q=combination_vector(8);
R=combination_vector(9);

combination_data_label=['LF_' num2str(LF) '_topNum_' num2str(topNum) '_SA_multiplier_' num2str(SA_multiplier) '_HW_Multiplier_' num2str(bb_H_W_std_Multiplier) '_WH_LF_' num2str(bb_learning_ratio) '_Max_Iter_' num2str(max_iter) '_Err_Thresh_' num2str(error_thresh) '_Q_' num2str(Q) '_R_' num2str(R) '/']; % Where the results are saved



for i=1:length(sequence_name_list)
    sequence_name=sequence_name_list{i};
    
    if track_or_detect==1
        if BB_type==1
            load_folder_path=[data_folder_path 'tracking/square_BB_results/' combination_data_label];
        else
            load_folder_path=[data_folder_path 'tracking/rectangle_BB_results/' combination_data_label];
        end
    else
        if BB_type==1
            load_folder_path=[data_folder_path 'detecting/square_BB_results/' combination_data_label];
        else
            load_folder_path=[data_folder_path 'detecting/rectangle_BB_results/' combination_data_label];
        end
    end
    addpath([load_folder_path sequence_name '_results/']);
    load([sequence_name '_error_all_bbo_dist.mat'])
    
    bbo_all_clips(i,:)=error_all_bbo_dist(2:end,1)';
    dist_all_clips(i,:)=error_all_bbo_dist(2:end,2)';
    mean_bbo(i)=mean(error_all_bbo_dist(2:end,1));
    mean_dist(i)=mean(error_all_bbo_dist(2:end,2));
    
end

h=figure
subplot(2,1,1)
plot(bbo_all_clips)
ylabel('BBO Ratio')
legend(sequence_name_list)

subplot(2,1,2)
plot(dist_all_clips)
ylabel('Distance')
xlabel('Frames')
legend(sequence_name_list)

h=figure
subplot(2,1,1)
plot(mean_bbo,'k+','MarkerSize',10,'LineWidth',2)
ylabel('Mean BBO')
set(gca, 'XtickLabel',sequence_name_list);

subplot(2,1,2)
plot(mean_dist,'k+','MarkerSize',10,'LineWidth',2)
ylabel('Mean Distance')
set(gca, 'XtickLabel',sequence_name_list);




end