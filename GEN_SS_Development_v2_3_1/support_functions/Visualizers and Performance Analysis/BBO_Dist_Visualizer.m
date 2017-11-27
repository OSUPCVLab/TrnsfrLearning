function BBO_Dist_Visualizer(bbo_or_dist, dim_visualized, sequence_name_list, default_combination, data_folder_path, track_or_detect, BB_type, LF_Array,  topNum_Array, SA_multiplier_Array, bb_H_W_std_Multiplier_Array, bb_learning_ratio_Array, max_iter_Array, error_thresh_Array, Q_Array, R_Array);

parameter_list={'LF','topNum','SA Multiplier','HW std Multiplier','BB LF','Max Iter','Error Tresh.','Q','R'};

if length(dim_visualized) >1
    if dim_visualized(1)==1
        x_array=LF_Array;
    elseif dim_visualized(1)==2
        x_array=topNum_Array;
    elseif dim_visualized(1)==3
        x_array=SA_multiplier_Array;
    elseif dim_visualized(1)==4
        x_array=bb_H_W_std_Multiplier_Array;
    elseif dim_visualized(1)==5
        x_array=bb_learning_ratio_Array;
    elseif dim_visualized(1)==6
        x_array=max_iter_Array
    elseif dim_visualized(1)==7
        x_array=error_thresh_Array;
    elseif dim_visualized(1)==8
        x_array=Q_Array;
    elseif dim_visualized(1)==9
        x_array=R_Array;
    end
    
    if dim_visualized(2)==1
        y_array=LF_Array;
    elseif dim_visualized(2)==2
        y_array=topNum_Array;
    elseif dim_visualized(2)==3
        y_array=SA_multiplier_Array;
    elseif dim_visualized(2)==4
        y_array=bb_H_W_std_Multiplier_Array;
    elseif dim_visualized(2)==5
        y_array=bb_learning_ratio_Array;
    elseif dim_visualized(2)==6
        y_array=max_iter_Array
    elseif dim_visualized(2)==7
        y_array=error_thresh_Array;
    elseif dim_visualized(2)==8
        y_array=Q_Array;
    elseif dim_visualized(2)==9
        y_array=R_Array;
    end
    
else
    if dim_visualized(1)==1
        x_array=LF_Array;
    elseif dim_visualized(1)==2
        x_array=topNum_Array;
    elseif dim_visualized(1)==3
        x_array=SA_multiplier_Array;
    elseif dim_visualized(1)==4
        x_array=bb_H_W_std_Multiplier_Array;
    elseif dim_visualized(1)==5
        x_array=bb_learning_ratio_Array;
    elseif dim_visualized(1)==6
        x_array=max_iter_Array
    elseif dim_visualized(1)==7
        x_array=error_thresh_Array;
    elseif dim_visualized(1)==8
        x_array=Q_Array;
    elseif dim_visualized(1)==9
        x_array=R_Array;
    end 
end



current_comb=default_combination;
if length(dim_visualized)==2
    plot_plane=zeros(length(x_array),length(y_array));
    for i=1:length(x_array)
        for j=1:length(y_array)
            current_comb(dim_visualized(1))=x_array(i);
            current_comb(dim_visualized(2))=y_array(j);
            
            LF=current_comb(1);
            topNum=current_comb(2);
            SA_multiplier=current_comb(3);
            bb_H_W_std_Multiplier=current_comb(4);
            bb_learning_ratio=current_comb(5);
            max_iter=current_comb(6);
            error_thresh=current_comb(7);
            Q=current_comb(8);
            R=current_comb(9);
            
            combination_data_label=['LF_' num2str(LF) '_topNum_' num2str(topNum) '_SA_multiplier_' num2str(SA_multiplier) '_HW_Multiplier_' num2str(bb_H_W_std_Multiplier) '_WH_LF_' num2str(bb_learning_ratio) '_Max_Iter_' num2str(max_iter) '_Err_Thresh_' num2str(error_thresh) '_Q_' num2str(Q) '_R_' num2str(R) '/']; % Where the results are saved
            mean_bbo=zeros(1,length(sequence_name_list));
            for ii=1:length(sequence_name_list)
                sequence_name=sequence_name_list{ii};
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
                
                
                load([ load_folder_path sequence_name '_results/' sequence_name '_error_all_bbo_dist.mat'])
                
                mean_bbo(ii)=mean(error_all_bbo_dist(2:end,1));
                mean_dist(ii)=mean(error_all_bbo_dist(2:end,2));
                
            end
            
            if bbo_or_dist==1
                plot_plane(i,j)=mean(mean_bbo);
                z_str='Mean BBO';
            else
                plot_plane(i,j)=mean(mean_dist);
                z_str='Mean Dist Error';
            end
        end
    end
    
    figure
    [X,Y]=meshgrid(x_array, y_array);
    surf(X',Y',plot_plane)
    xlabel(parameter_list{dim_visualized(1)})
    ylabel(parameter_list{dim_visualized(2)})
    zlabel(z_str)
    
else
    plot_vector=zeros(1,length(x_array));
    
    for i=1:length(x_array)
        current_comb(dim_visualized(1))=x_array(i);
        
        LF=current_comb(1);
        topNum=current_comb(2);
        SA_multiplier=current_comb(3);
        bb_H_W_std_Multiplier=current_comb(4);
        bb_learning_ratio=current_comb(5);
        max_iter=current_comb(6);
        error_thresh=current_comb(7);
        Q=current_comb(8);
        R=current_comb(9);
        
        combination_data_label=['LF_' num2str(LF) '_topNum_' num2str(topNum) '_SA_multiplier_' num2str(SA_multiplier) '_HW_Multiplier_' num2str(bb_H_W_std_Multiplier) '_WH_LF_' num2str(bb_learning_ratio) '_Max_Iter_' num2str(max_iter) '_Err_Thresh_' num2str(error_thresh) '_Q_' num2str(Q) '_R_' num2str(R) '/']; % Where the results are saved
        mean_bbo=zeros(1,length(sequence_name_list));
        for ii=1:length(sequence_name_list)
            sequence_name=sequence_name_list{ii};
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
            
            load([load_folder_path sequence_name '_results/' sequence_name '_error_all_bbo_dist.mat'])
            
            mean_bbo(ii)=mean(error_all_bbo_dist(2:end,bbo_or_dist));
        end
        plot_vector(i)=mean(mean_bbo);

    end
    if bbo_or_dist==1
        y_str='Mean BBO';
    else
        y_str='Mean Dist Error';
    end
    
    plot_vector
    plot(x_array,plot_vector);
    xlabel(parameter_list{dim_visualized(1)})
    ylabel(y_str)
end