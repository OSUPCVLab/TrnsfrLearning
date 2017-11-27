function VOT_Clip_Data_Review(combination_vector, data_folder_path, track_or_detect, BB_type, sequence_name)
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

load([sequence_name '_classes_all.mat'])
load([sequence_name '_classes_all_val.mat'])

load([sequence_name '_word_bag_all.mat'])
load([sequence_name '_word_bag_all_val.mat'])
load([sequence_name '_word_bag_count_all.mat'])

load([sequence_name '_error_all_bbo_dist.mat'])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mean_val_mat = mean(classes_all_val,1);
std_val_mat=std(classes_all_val,0,1);

h=figure
plot(classes_all_val')
set(gca, 'YScale', 'log')
grid on
xlabel('Class Rank')
ylabel('Class Score')
title('Class Score vs. Class Rank')
% savefig(h,[save_folder '/' sequence_name '_class_score_versus_rank.fig']);

h=figure
errorbar(mean_val_mat',std_val_mat')
xlabel('Class Rank')
ylabel('Class Score')
title('Mean Class Score vs. Class Rank')
grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
list_mat=classes_all(:,1:100,:);
value_mat=classes_all_val(:,1:100,:);

[n_frames,~]=size(classes_all);
h=figure
x=ones(1,100);
colormap('jet');
for i=1:n_frames
    xp=x*i;
    %     for j=1:topNum
    I=value_mat(i,:);
    I=round((I*100))/100;
    scatter(xp,list_mat(i,:),.1+I*255,I,'filled');
    hold on
    %     end
end
xlabel('Frame')
ylabel('Class')
colorbar

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h=figure
colormap('jet');
for i=1:n_frames
    for j=1:word_bag_count_all(i)
    I=word_bag_all_val(i,j);
    I=round((I*100))/100;
    scatter(i,word_bag_all(i,j),.1+I*255,I,'filled');
    hold on
    end
end
xlabel('Frame')
ylabel('Class')
title('BoW')
colorbar

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h=figure
mean_bbo=mean(error_all_bbo_dist(2:end,1));
mean_dist=mean(error_all_bbo_dist(2:end,2));
subplot(2,1,1)
plot(error_all_bbo_dist(2:end,1));
hold on
plot(mean_bbo*ones(1,n_frames-1),'--');
ylabel('BBO Ratio')

subplot(2,1,2)
plot(error_all_bbo_dist(2:end,2));
hold on
plot(mean_dist*ones(1,n_frames-1),'--');
ylabel('Distance Error')
xlabel('Frame')


end