%%%% LF and N Peformance Analysis %%%%
function LF_and_N_Peformance_Analysis_Across_Scenarios(topNum_Array, LF_Array, data_folder_path1, data_folder_path2, noise)
close all; clc;
all_comb=length(topNum_Array)*length(LF_Array);

bbo_mean_and_std_all_LF_n=ones(all_comb,2);
n=1;
for LF=LF_Array
    for topNum=topNum_Array
        addpath([data_folder_path1 '/LF' num2str(LF) 'n' num2str(topNum)]);
        load(['Mean_BBO_Ratio and STD_w_LF_' num2str(LF) '_n_' num2str(topNum) '.mat'])
 
        bbo_mean_and_std_all_LF_n(n,1)=mean(mean_error_bbo_dist(:,1));
        bbo_mean_and_std_all_LF_n(n,2)=sqrt(sum(mean_error_bbo_dist(:,2).^2))/length(mean_error_bbo_dist(:,2));
        legend_string{n}=[num2str(LF) ',' num2str(topNum)];
        n=n+1;
    end
end

h1=figure
subplot(2,1,1)
errorbar(bbo_mean_and_std_all_LF_n(:,1),bbo_mean_and_std_all_LF_n(:,2),'*k','LineWidth',3)
xticks(1:all_comb);
xtickangle(45);
set(gca, 'XtickLabel',legend_string);
ylabel('BBO Ratio')
title(['Analysis of LF and n on BBO Ratio w/ Rectangle BB'])
grid on
hold on

bbo_mean_and_std_all_LF_n=ones(all_comb,2);
n=1;
for LF=LF_Array
    for topNum=topNum_Array
        addpath([data_folder_path2 '/LF' num2str(LF) 'n' num2str(topNum)]);
        load(['Mean_BBO_Ratio and STD_w_LF_' num2str(LF) '_n_' num2str(topNum) '.mat'])
        bbo_mean_and_std_all_LF_n(n,1)=mean(mean_error_bbo_dist(:,1));
        bbo_mean_and_std_all_LF_n(n,2)=sqrt(sum(mean_error_bbo_dist(:,2).^2))/length(mean_error_bbo_dist(:,2));
        legend_string{n}=[num2str(LF) ',' num2str(topNum)];
        n=n+1;
    end
end


subplot(2,1,2)
errorbar(bbo_mean_and_std_all_LF_n(:,1),bbo_mean_and_std_all_LF_n(:,2),'ob','LineWidth',3)
xticks(1:all_comb);
xtickangle(45);
set(gca, 'XtickLabel',legend_string);
ylabel('BBO Ratio')
title(['Analysis of LF and n on BBO Ratio w/ Square BB'])
grid on

savefig(h1, [data_folder_path1 '/RT_vs_SQ_LF_n_all_combination_mean_dist.fig']);
savefig(h1, [data_folder_path2 '/RT_vs_SQ_LF_n_all_combination_mean_dist.fig']);
