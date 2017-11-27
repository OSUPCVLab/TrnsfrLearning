function [total_comb_table, output_vector] = Parameter_Tree_Performance_Visualization(bbo_or_dist, dim_visualized, sequence_name_list, default_combination, data_folder_path, track_or_detect, BB_type, LF_Array,  topNum_Array, SA_multiplier_Array, bb_H_W_std_Multiplier_Array, bb_learning_ratio_Array, max_iter_Array, error_thresh_Array, Q_Array, R_Array);

parameter_matrix=zeros(length(dim_visualized),100);
parameter_length_vector=zeros(length(dim_visualized));
x_label='Parameters: ';
for i=1:length(dim_visualized)
    if dim_visualized(i)==1
        parameter_matrix(i,1:length(LF_Array))=LF_Array;
        parameter_length_vector(i)=length(LF_Array);
        if i<length(dim_visualized)
            x_label=strcat(x_label,'LF, ');
        else
            x_label=strcat(x_label,'LF');
        end
        
    elseif dim_visualized(i)==2
        parameter_matrix(i,1:length(topNum_Array))=topNum_Array;
        parameter_length_vector(i)=length(topNum_Array);
        if i<length(dim_visualized)
            x_label=strcat(x_label,'topNum, ');
        else
            x_label=strcat(x_label,'topNum');
        end
        
    elseif dim_visualized(i)==3
        parameter_matrix(i,1:length(SA_multiplier_Array))=SA_multiplier_Array;
        parameter_length_vector(i)=length(SA_multiplier_Array);
        if i<length(dim_visualized)
            x_label=strcat(x_label,'SA Multi., ');
        else
            x_label=strcat(x_label,'SA Multi.');
        end
        
    elseif dim_visualized(i)==4
        parameter_matrix(i,1:length(bb_H_W_std_Multiplier_Array))=bb_H_W_std_Multiplier_Array;
        parameter_length_vector(i)=length(bb_H_W_std_Multiplier_Array);
        if i<length(dim_visualized)
            x_label=strcat(x_label,'HW Multi., ');
        else
            x_label=strcat(x_label,'HW Multi.');
        end
        
    elseif dim_visualized(i)==5
        parameter_matrix(i,1:length(bb_learning_ratio_Array))=bb_learning_ratio_Array;
        parameter_length_vector(i)=length(bb_learning_ratio_Array);
        if i<length(dim_visualized)
            x_label=strcat(x_label,'BB LF, ');
        else
            x_label=strcat(x_label,'BB LF');
        end
        
    elseif dim_visualized(i)==6
        parameter_matrix(i,1:length(max_iter_Array))=max_iter_Array;
        parameter_length_vector(i)=length(max_iter_Array);
        if i<length(dim_visualized)
            x_label=strcat(x_label,'Max Iter, ');
        else
            x_label=strcat(x_label,'Max Iter');
        end
        
    elseif dim_visualized(i)==7
        parameter_matrix(i,1:length(error_thresh_Array))=error_thresh_Array;
        parameter_length_vector(i)=length(error_thresh_Array);
        if i<length(dim_visualized)
            x_label=strcat(x_label,'Err. Thresh., ');
        else
            x_label=strcat(x_label,'Err. Thresh.');
        end
        
    elseif dim_visualized(i)==8
        parameter_matrix(i,1:length(Q_Array))=Q_Array;
        parameter_length_vector(i)=length(Q_Array);
        if i<length(dim_visualized)
            x_label=strcat(x_label,'Q, ');
        else
            x_label=strcat(x_label,'Q');
        end
        
    elseif dim_visualized(i)==9
        parameter_matrix(i,1:length(R_Array))=R_Array;
        parameter_length_vector(i)=length(R_Array);
        if i<length(dim_visualized)
            x_label=strcat(x_label,'R, ');
        else
            x_label=strcat(x_label,'R');
        end
        
    end
end

total_comb=1;
for i=1:length(dim_visualized)
    total_comb=total_comb*parameter_length_vector(i);
end

total_comb_table=zeros(total_comb,length(dim_visualized));
temp_comb=zeros(1,length(dim_visualized));
parameter_matrix_count=ones(length(dim_visualized));
i=1;
while i<=total_comb
    for j=1:length(dim_visualized)
        if length(dim_visualized)>1
            if parameter_matrix_count(j)>parameter_length_vector(j)
                parameter_matrix_count(j)=1;
                parameter_matrix_count(j-1)=parameter_matrix_count(j-1)+1;
            end
        end
        
        temp_comb(j)=parameter_matrix(j,parameter_matrix_count(j));
        if j==length(dim_visualized)
            parameter_matrix_count(j)=parameter_matrix_count(j)+1;
        end
        
        if length(dim_visualized)>1
            if parameter_matrix_count(j)>parameter_length_vector(j)
                parameter_matrix_count(j)=1;
                parameter_matrix_count(j-1)=parameter_matrix_count(j-1)+1;
            end
        end
        
    end
    total_comb_table(i,1:length(dim_visualized))=temp_comb;
    i=i+1;
end

current_comb=default_combination;
plot_vector=zeros(1,total_comb);
plot_labels=cell(1,total_comb);
for i=1:total_comb
    comb_label='[';
    for j=1:length(dim_visualized)
        current_comb(dim_visualized(j))=total_comb_table(i,j);
        if j<length(dim_visualized)
            comb_label = strcat(comb_label,[num2str(total_comb_table(i,j)) ', ']);
        else
            comb_label = strcat(comb_label,[num2str(total_comb_table(i,j)) ']']);
        end
    end
    
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
    plot_labels{i}=comb_label;
end

if bbo_or_dist==1
    y_label='Mean BBO';
else
    y_label='Mean Dist Error';
end

parameter_list={'LF','topNum','SA Multiplier','HW std Multiplier','BB LF','Max Iter','Error Tresh.','Q','R'};
title_str=[y_label ' with '];
match=0;
for i=1:9
    for j=1:length(dim_visualized)
        if i==dim_visualized(j)
            match=1;
        end
    end
    if match==0
        if i<9
            title_str=strcat(title_str,[' ' parameter_list{i} '=' num2str(current_comb(i)) ', ']);
        else
            title_str=strcat(title_str,[' ' parameter_list{i} '=' num2str(current_comb(i))]);
        end
    end
    match=0;
end

plot(plot_vector,'k-*');
if total_comb<10000
    xticks(1:total_comb);
    xticklabels(plot_labels);
    xtickangle(45)
    xlabel(x_label)
else
    xlabel(x_label)
end

ylabel(y_label)
title(title_str)
grid on

output_vector=plot_vector;
end