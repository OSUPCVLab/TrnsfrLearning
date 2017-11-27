%%%% LF and N Peformance Analysis %%%%
function LF_and_N_Peformance_Analysis_Across_Scenarios(topNum_Array, LF_Array, data_folder_path1, noise1, data_folder_path2, noise2)
close all; clc;
all_comb=length(topNum_Array)*length(LF_Array);

dist_mean_and_std_all_LF_n=ones(all_comb,2);
n=1;
for LF=LF_Array
    for topNum=topNum_Array
        addpath([data_folder_path1 '/LF' num2str(LF) 'n' num2str(topNum)]);
        load(['Mean_BBO_Ratio and STD_w_LF_' num2str(LF) '_n_' num2str(topNum) '.mat'])
 
        dist_mean_and_std_all_LF_n(n,1)=mean(mean_error_bbo_dist_mat(:,3));
        dist_mean_and_std_all_LF_n(n,2)=sqrt(sum(mean_error_bbo_dist_mat(:,4).^2))/length(mean_error_bbo_dist_mat(:,2));
        legend_string{n}=[num2str(LF) ',' num2str(topNum)];
        n=n+1;
    end
end

h1=figure
subplot(2,1,1)
errorbar(dist_mean_and_std_all_LF_n(:,1),dist_mean_and_std_all_LF_n(:,2),'*k','LineWidth',3)
xticks(1:all_comb);
xtickangle(45);
set(gca, 'XtickLabel',legend_string);
ylabel('Distance Error')
title(['Analysis of LF and n on Distance Error w/ ' num2str(noise1) ' Gaussian Noise'])
grid on
hold on

dist_mean_and_std_all_LF_n=ones(all_comb,2);
n=1;
for LF=LF_Array
    for topNum=topNum_Array
        addpath([data_folder_path2 '/LF' num2str(LF) 'n' num2str(topNum)]);
        load(['Mean_BBO_Ratio and STD_w_LF_' num2str(LF) '_n_' num2str(topNum) '.mat'])
        dist_mean_and_std_all_LF_n(n,1)=mean(mean_error_bbo_dist_mat(:,3));
        dist_mean_and_std_all_LF_n(n,2)=sqrt(sum(mean_error_bbo_dist_mat(:,4).^2))/length(mean_error_bbo_dist_mat(:,2));
        legend_string{n}=[num2str(LF) ',' num2str(topNum)];
        n=n+1;
    end
end


subplot(2,1,2)
errorbar(dist_mean_and_std_all_LF_n(:,1),dist_mean_and_std_all_LF_n(:,2),'ob','LineWidth',3)
xticks(1:all_comb);
xtickangle(45);
set(gca, 'XtickLabel',legend_string);
ylabel('Distance Error')
title(['Analysis of LF and n on Distance Error w/ ' num2str(noise2) ' Gaussian Noise'])
grid on

savefig(h1, [data_folder_path1 '/RT_vs_SQ_LF_n_all_combination_mean_dist.fig']);
savefig(h1, [data_folder_path2 '/RT_vs_SQ_LF_n_all_combination_mean_dist.fig']);
