function BoW_Post_Tracking_Data_Compile(sequence_name_list, max_frames, track_or_detect, BB_type, LF_Array,  topNum_Array, SA_multiplier_Array, bb_H_W_std_Multiplier_Array, bb_learning_ratio_Array, max_iter_Array, error_thresh_Array, Q_Array, R_Array, data_folder_path)
total_iter=((length(LF_Array)*length(topNum_Array)*length(sequence_name_list))*length(SA_multiplier_Array)*length(bb_H_W_std_Multiplier_Array)*length(bb_learning_ratio_Array)*length(max_iter_Array)*length(error_thresh_Array)*length(Q_Array)*length(R_Array)*max_frames);

compiled_error_list=zeros(total_iter,11);

iter=0;
LF_i=0;
for LF=LF_Array
    LF_i=LF_i+1;
    topNum_i=0;
    for topNum=topNum_Array
        topNum_i=topNum_i+1;
        SA_multiplier_i=0;
        for SA_multiplier=SA_multiplier_Array
            SA_multiplier_i=SA_multiplier_i+1;
            bb_H_W_std_Multiplier_i=0;
            for bb_H_W_std_Multiplier=bb_H_W_std_Multiplier_Array
                bb_H_W_std_Multiplier_i=bb_H_W_std_Multiplier_i+1;
                bb_learning_ratio_i=0;
                for bb_learning_ratio=bb_learning_ratio_Array
                    bb_learning_ratio_i=bb_learning_ratio_i+1;
                    max_iter_i=0;
                    for max_iter=max_iter_Array
                        max_iter_i=max_iter_i+1;
                        error_thresh_i=0;
                        for error_thresh=error_thresh_Array
                            error_thresh_i=error_thresh_i+1;
                            Q_i=0;
                            for Q=Q_Array
                                Q_i=Q_i+1;
                                R_i=0;
                                for R=R_Array
                                    R_i=R_i+1;
                                    iter=iter+1;
                                    
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
                                        addpath([load_folder_path sequence_name '_results/']);
                                        
                                        % Load SEQUENCE_NAME_error_all_bbo_dist_w_LF_?_n_?.mat
                                        load([sequence_name '_error_all_bbo_dist.mat'])
                                        [n_frames,~]=size(error_all_bbo_dist);
                                        
                                        % Calculate Statistics of BBO and Distance Errors
                                        bbo_all(1:n_frames,i) = error_all_bbo_dist(:,1);
                                        bbo_mean(i)=mean(error_all_bbo_dist(:,1));
                                        bbo_std(i)=std(error_all_bbo_dist(:,1));
                                        
                                        dist_error_all(1:n_frames,i) = error_all_bbo_dist(:,2);
                                        dist_error_mean(i)=mean(error_all_bbo_dist(:,2));
                                        dist_error_std(i)=std(error_all_bbo_dist(:,2));
 
                                    end
                                    seq_mean_error_bbo_dist=[bbo_mean',bbo_std',dist_error_mean',dist_error_std'];
                                    comb_mean_error_bbo_dist=[mean(bbo_mean),mean(dist_error_mean)];
                                    compiled_error_list(i,:)=[LF topNum SA_multiplier bb_H_W_std_Multiplier bb_learning_ratio max_iter error_thresh Q R mean(bbo_mean) mean(dist_error_mean)];
                                    %%%%%%%%%%%%%%%%%%%%%%%%%%%% Save Data %%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                    save_folder=[load_folder_path];
                                    SF_exists=exist(save_folder,'dir');
                                    
                                    if SF_exists~=7
                                        mkdir(save_folder);
                                    end
                                    
                                    %                                         save_name=[save_folder '/Separate_Clip_BBO_Ratio_w_LF_' num2str(LF) '_n_' num2str(topNum) '.fig'];
                                    %                                         savefig(h1, save_name);
                                    %                                         save_name=[save_folder '/Separate_Clip_Dist_Error_w_LF_' num2str(LF) '_n_' num2str(topNum) '.fig'];
                                    %                                         savefig(h2, save_name);
                                    %                                         save_name=[save_folder '/Together_BBO_Ratio_and Dist_Error_w_LF_' num2str(LF) '_n_' num2str(topNum) '.fig'];
                                    %                                         savefig(h3, save_name);
                                    %                                         save_name=[save_folder '/Mean_BBO_Ratio_and_Dist_Error_w_LF_' num2str(LF) '_n_' num2str(topNum) '.fig'];
                                    %                                         savefig(h4, save_name);
                                    save([save_folder '/Seq_Mean_BBO_Ratio and STD.mat'],'seq_mean_error_bbo_dist');
                                    save([save_folder '/Comb_Mean_BBO_Ratio and STD.mat'],'comb_mean_error_bbo_dist');


                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
if track_or_detect==1
    if BB_type==1
        load_folder_path=[data_folder_path 'tracking/square_BB_results/'];
    else
        load_folder_path=[data_folder_path 'tracking/rectangle_BB_results/'];
    end
else
    if BB_type==1
        load_folder_path=[data_folder_path 'detecting/square_BB_results/'];
    else
        load_folder_path=[data_folder_path 'detecting/rectangle_BB_results/'];
    end
end

save([load_folder_path '/Compiled_Mean_Error_List.mat'],'compiled_error_list');

end
