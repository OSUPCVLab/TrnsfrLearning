%%%% LF and N Peformance Analysis %%%%
function LF_and_N_Peformance_Analysis(topNum_Array, LF_Array, track_or_detect, BB_type, data_folder_path)
% Set Data Folder Path to Selected BB Type
if track_or_detect==1
    if BB_type==1
         data_folder_path=[data_folder_path 'tracking/square_BB_results/'];
    else
         data_folder_path=[data_folder_path 'tracking/rectangle_BB_results/'];
    end
else
    if BB_type==1
         data_folder_path=[data_folder_path 'detecting/square_BB_results/'];
    else
         data_folder_path=[data_folder_path 'detecting/rectangle_BB_results/'];
    end
end

all_comb=length(topNum_Array)*length(LF_Array);
bbo_mean_and_std_all_LF_n=ones(all_comb,2);
n=1;
for LF=LF_Array
    for topNum=topNum_Array
        addpath([data_folder_path '/LF' num2str(LF) 'n' num2str(topNum)]);
        load(['Mean_BBO_Ratio and STD_w_LF_' num2str(LF) '_n_' num2str(topNum) '.mat'])
        bbo_mean_and_std_all_LF_n(n,1)=mean(mean_error_bbo_dist(:,1));
        bbo_mean_and_std_all_LF_n(n,2)=sqrt(sum(mean_error_bbo_dist(:,2).^2))/length(mean_error_bbo_dist(:,2));

        dist_mean_and_std_all_LF_n(n,1)=mean(mean_error_bbo_dist(:,3));
        dist_mean_and_std_all_LF_n(n,2)=sqrt(sum(mean_error_bbo_dist(:,4).^2))/length(mean_error_bbo_dist(:,2));
        legend_string{n}=[num2str(LF) ',' num2str(topNum)];
        n=n+1;
    end
end

h1=figure
subplot(2,1,1)
errorbar(bbo_mean_and_std_all_LF_n(:,1),bbo_mean_and_std_all_LF_n(:,2),'k*','LineWidth',3)
if all_comb>1
    xticks(1:all_comb);
    xtickangle(45);
end

set(gca, 'XtickLabel',legend_string);
ylabel('BBO Ratio')
title('Analysis of LF and n on BBO Ratio')

subplot(2,1,2)
errorbar(dist_mean_and_std_all_LF_n(:,1),dist_mean_and_std_all_LF_n(:,2),'b*','LineWidth',3)
if all_comb>1
    xticks(1:all_comb);
    xtickangle(45);
end

set(gca, 'XtickLabel',legend_string);
ylabel('Distance Error [pixels]')
title('Analysis of LF and n on Distance Error')

savefig(h1, [data_folder_path '/LF_n_all_combination_mean_BBO.fig']);

end