function [GO_HP_vector]=GEN_SS_GO(clip_dir, sequence_name, start_frame, estimated_BB, frame_BoW, frame_qxy, frame_Pxy, max_frames, fixed, KF_switch, track_or_detect, net)
%%%%%%%%%%%%%%%%%%%%%%%% Initialize Genetic Optimizer %%%%%%%%%%%%%%%%%%%%
% Set genetic optimization input parameters
n_children=10;
n_parents=10;
param_limits=[0 1 1 .1 0; 1 200 10 20 1];
param_type_int=[0 1 0 0 0];
n_HP=length(param_type_int);
generation_limit=100;

% Genetic Optimization Initial Conditions
alpha=0.5;
parent1=param_limits(1,:);
parent2=param_limits(2,:);
initial_combination=[parent1; parent2];
Top_Combination_Parents=initial_combination;
Top_Combination_Parents_BBO=[0.0001 0.0001];

generation=0;
generation_top_combination=zeros(generation_limit,n_HP);
generation_top_bbo=zeros(generation_limit,1);
parent_pool_on=0;
parent_pool_store=zeros(n_parents,n_HP);
parent_pool_bbo_store=zeros(n_parents,1);
parents=0;
use_whole_pool_on=0;
generation_wo_improve=0;
improve=1;
% Begin Genetic Optimization
while generation<generation_limit&&Top_Combination_Parents_BBO(1)<0.99&&generation_wo_improve<10
    generation=generation+1;
    if improve==0
        generation_wo_improve=generation_wo_improve+1;
    else
        generation_wo_improve=0;
    end
    improve=0;
    
    if use_whole_pool_on==1
        parent_pool=parent_pool_store;
    else
        parent_pool=parent_pool_store(1:parents,:);
    end
    
    % Breed Child Combinations
    [combination_matrix]=breed(improve, alpha, Top_Combination_Parents(1,:), Top_Combination_Parents(2,:), param_limits, param_type_int, n_children, parent_pool_on, parent_pool);
    child_bbo=zeros(n_children,1);
    
    % Test performance of each child combination
    for iii=1:n_children
        HP_vector=combination_matrix(iii,:);
        algorithm_settings=[start_frame max_frames fixed KF_switch track_or_detect];
        [mean_bbo, BoW, qxy, Pxy]=GEN_SS_CLIP_ANALYSIS(clip_dir, sequence_name, estimated_BB, start_frame, max_frames, HP_vector, frame_BoW, frame_qxy, frame_Pxy, algorithm_settings, net);
        child_bbo(iii)=mean(mean_bbo);
%         [Top_Combination_Parents_BBO.*ones(n_children,1) child_bbo]
    end
    
    % Sort child combinations by performance
    [sort_bbo,sort_I]=sort(child_bbo,'descend');
    
    generation_top_combination(generation,:)=combination_matrix(sort_I(1),:);
    generation_top_bbo(generation)=sort_bbo(1);
    
    % Compare top performers to previous top performers
    if sort_bbo(1)>Top_Combination_Parents_BBO(1)
        improve=1;
        Top_Combination_Parents(2,:)=Top_Combination_Parents(1,:);
        Top_Combination_Parents_BBO(2)=Top_Combination_Parents_BBO(1);
        Top_Combination_Parents(1,:)=combination_matrix(sort_I(1),:);
        Top_Combination_Parents_BBO(1)=sort_bbo(1);
        if sort_bbo(2)>Top_Combination_Parents_BBO(2)
            improve=1;
            Top_Combination_Parents(2,:)=combination_matrix(sort_I(2),:);
            Top_Combination_Parents_BBO(2)=sort_bbo(2);
        end
    elseif sort_bbo(1)>Top_Combination_Parents_BBO(2)
        improve=1;
        Top_Combination_Parents(2,:)=combination_matrix(sort_I(1),:);
        Top_Combination_Parents_BBO(2)=sort_bbo(1);
    end
    

  
    
    % Compare child perfromance to parent pool and incorporate
    [parent_sort_bbo,~]=sort(parent_pool_bbo_store,'descend');
    for j=1:n_children
        parent_found=0;
        for ii=j:n_parents
            if parent_found==0
                if sort_bbo(j)>parent_sort_bbo(ii)
                    improve=1;
                    parent_found=1;
                    parent_pool_on=1;
                    if parents<n_parents
                        parents=parents+1;
                    end
                    
                    for iii=ii:n_parents-1
                        parent_pool_store(iii+1,:)=parent_pool_store(iii,:);
                        parent_pool_bbo_store(ii+1)=parent_pool_bbo_store(ii);
                    end
                    
                    parent_pool_store(ii,:)=combination_matrix(sort_I(j),:);
                    parent_pool_bbo_store(ii)=sort_bbo(j);
                end
            end
        end
        
%         
%         if sort_bbo(j)>parent_threshold
%             parents=parents+1;
%             if parents>n_parents
%                 parents=1;
%                 if parent_threshold<0.9
%                     parent_threshold=parent_threshold+.1*(1-parent_threshold);
%                 else
%                     parent_threshold=parent_threshold+.1*(1-parent_threshold);
%                 end
%                 use_whole_pool_on=1;
%             end
%             parent_pool_store(parents,:)=combination_matrix(sort_I(j),:);
%             parent_pool_bbo_store(parents)=sort_bbo(j);
%             parent_pool_on=1;
%         else
%             break
%         end
    end
    
end
GO_HP_vector=Top_Combination_Parents(1,:);
Top_Combination_Parents_BBO
end