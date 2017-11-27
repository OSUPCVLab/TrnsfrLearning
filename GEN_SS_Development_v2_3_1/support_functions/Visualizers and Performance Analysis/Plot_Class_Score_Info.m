%%%%% Plot Class Score Info %%%%
function Plot_Class_Score_Info(sequence_name, val_mat, data_folder_path)
save_folder=[data_folder_path sequence_name '_results/'];
mean_val_mat = mean(val_mat,1);
std_val_mat=std(val_mat,0,1);

h=figure
plot(val_mat')
grid on
xlabel('Class Rank')
ylabel('Score')
title('Score vs. Class Rank')
savefig(h,[save_folder '/' sequence_name '_class_score_versus_rank.fig']);

h=figure
errorbar(mean_val_mat',std_val_mat')
xlabel('Class Rank')
ylabel('Score')
title('Mean Score vs. Class Rank')
grid on
savefig(h,[save_folder '/' sequence_name '_mean_class_score_versus_rank.fig']);

end
