function Plot_class_Hist_and_Scatter(sequence_name,list,value, topNum, LF, type, data_folder_path)
[n_frames,~]=size(list);
list_mat=list(:,1:topNum,:);
list_vec=list_mat(:);
[list_vec_sort sort_ind]=sort(list_vec);

value_mat=value(:,1:topNum,:);
value_vec=value_mat(:);


save_folder=[data_folder_path sequence_name '_results/LF' num2str(LF) 'n' num2str(topNum)];
SF_exists= exist(save_folder, 'dir');
if SF_exists~=7
    mkdir(save_folder);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h=figure
histogram(list_vec,1000);
xlabel('Class')
ylabel('Count')

if type==1
    title([sequence_name ' Class Occurrence over 412 Frames w/ n' num2str(topNum)])
    save_name=[save_folder '/' sequence_name '_unweighted_histo_w_n_' num2str(topNum) '.fig'];
    savefig(h, save_name);
else
    title([sequence_name ' BoW Class Occurrence over 412 Frames w/ LF ' num2str(LF) ' n ' num2str(topNum)])
    save_name=[save_folder '/' sequence_name '_Bow_unweighted_histo_w_LF_' num2str(LF) '_n_' num2str(topNum) '.fig'];
    savefig(h, save_name);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=1;
for i=1:length(list_vec_sort)
    if i==1
        class_ind(n)=list_vec_sort(i);
        class_ind_count(n)=1*value_vec(sort_ind(i));
    elseif  class_ind(n)==list_vec_sort(i)
        class_ind_count(n)=class_ind_count(n)+1*value_vec(sort_ind(i));
    elseif class_ind(n)~=list_vec_sort(i)
        n=n+1;
        class_ind(n)=list_vec_sort(i);
        class_ind_count(n)=1*value_vec(sort_ind(i));
    end
end

class_ind_count=round(class_ind_count/sum(class_ind_count)*1000);

n=1;
for i=1:length(class_ind_count)
    for j=1:class_ind_count(i);
        class_ind_count_dist_vect(n)=class_ind(i);
        n=n+1;
    end
end

h=figure
histogram(class_ind_count_dist_vect,1000)
xlabel('Class')
ylabel('Count out of 1000')

if type==1
    title([sequence_name ' Weighted Class Occurrence over 412 Frames w/ n ' num2str(topNum)])
    savefig(h,[save_folder '/' sequence_name '_weighted_histo_w_n_' num2str(topNum) '.fig']);
else
    title([sequence_name ' BoW Weighted Class Occurrence over 412 Frames w/ LF ' num2str(LF) ' n ' num2str(topNum)])
    savefig(h,[save_folder '/' sequence_name '_weighted_histo__w_LF_' num2str(LF) '_n_' num2str(topNum) '.fig']);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h=figure
x=ones(1,topNum);
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
if type==1
    title([sequence_name ' Class Occurrence in Each Frame w/ n ' num2str(topNum)])
    savefig(h,[save_folder '/' sequence_name '_scatter_plot_class_scores_w_n_' num2str(topNum) '.fig']);
else
    title([sequence_name ' BoW Class Occurrence in Each Frame w/ LF ' num2str(LF) ' n ' num2str(topNum)])
    savefig(h,[save_folder '/' sequence_name '_scatter_plot_class_scores_ w_LF_' num2str(LF) '_n_' num2str(topNum) '.fig']);
end

end