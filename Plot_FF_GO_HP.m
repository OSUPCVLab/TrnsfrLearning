function [opt_HP_FF_Volume]=Plot_FF_GO_HP()
close all; clear all; clc;
% [sequence_name_list, max_frames, track_or_detect, fixed, BB_type, LF_Array,  topNum_Array, SA_multiplier_Array, bb_H_W_std_Multiplier_Array, bb_learning_ratio_Array, max_iter_Array, error_thresh_Array, KF_switch, Q_Array, R_Array, data_folder_path, clip_dir, model_dir, net_weights, net_model, net] = userInputParameters();
data_folder_path='./10_31_17_GO_frame_by_frame_opt/';
repeat=1;
sequence_name_list={'basketball', 'car1', 'car2', 'pedestrian1','road','racing','gymnastics1'};%'basketball', 'car1', 'car2', 'pedestrian1','pedestrian2','road','racing','gymnastics1'};

opt_HP_FF_Volume=zeros(100,9,length(sequence_name_list));
for i=1:length(sequence_name_list)
    sequence_name=sequence_name_list{i};
    save_folder=[ data_folder_path '\' num2str(repeat) '\' sequence_name '\'];
    S_opt_HP_FF=load([save_folder 'FF_Opt_HP.mat']);
    opt_HP_FF=S_opt_HP_FF.opt_HP_FF;
    opt_HP_FF_Volume(:,:,i)=opt_HP_FF;
    S_opt_HP_FF_BBO=load([save_folder 'FF_Opt_HP_BBO.mat']);
    opt_HP_FF_BBO=S_opt_HP_FF_BBO.BB_opt_HP_FF;
    opt_HP_FF_BBO_Volume(:,i)=opt_HP_FF_BBO(:,1);
end

HP_mean=zeros(9,length(sequence_name_list));
HP_std=zeros(9,length(sequence_name_list));
HP_FF_mean=zeros(100,9);
HP_FF_std=zeros(100,9);

for i=1:9
    hp_surf(:,:)=opt_HP_FF_Volume(:,i,:);
    HP_mean(i,:)=mean(hp_surf);
    HP_std(i,:)=std(hp_surf);
    HP_FF_mean(:,i)=mean(hp_surf,2);
    HP_FF_std(:,i)=std(hp_surf');
    figure
    for j=1:length(sequence_name_list)
        subplot(length(sequence_name_list),1,j)
        plot(hp_surf(:,j))
        ylabel(['Seq#: ' num2str(j)])
        axis tight
    end
    xlabel('Frame')
    suptitle(['HP# ' num2str(i)])
    
end

figure
for i=1:2
    subplot(2,1,i)
    errorbar(HP_mean(i,:)',HP_std(i,:)','k*','LineStyle','none')
    ylabel(['HP# ' num2str(i)])
    axis tight
end
xlabel('Sequence')
suptitle('BoW HP Mean with 1 STD')

figure
for i=3:7
    subplot(5,1,i-2)
    errorbar(HP_mean(i,:)',HP_std(i,:)','k*','LineStyle','none')
    ylabel(['HP# ' num2str(i)])
    axis tight
end
xlabel('Sequence')
suptitle('BB Prediction HP Mean with 1 STD')

figure
for i=1:7
    subplot(7,1,i)
    errorbar(HP_FF_mean(:,i),HP_FF_std(:,i),'k*','LineStyle','none')
    ylabel(['HP# ' num2str(i)])
    axis tight
end
xlabel('Frame')
suptitle('FF HP Mean with 1 STD across Sequences')

figure
for i=1:length(sequence_name_list)
    subplot(length(sequence_name_list),1,i)
    plot(opt_HP_FF_BBO_Volume(:,i))
    ylabel(['Seq# ' num2str(i)])
    axis tight
    
end
suptitle('BBO Values for Each Sequence over 100 Frames')
xlabel('Frames')

figure
plot(opt_HP_FF_BBO_Volume)
legend(sequence_name_list)
title('BBO Values for All Sequences')
ylabel('BB0 Value')
xlabel('Frame #')

figure
errorbar(mean(opt_HP_FF_BBO_Volume,2),std(opt_HP_FF_BBO_Volume'))
title('Mean BBO for all Sequences w/ 1 STD Errorbars')
ylabel('BB0 Value')
xlabel('Frame #')
end