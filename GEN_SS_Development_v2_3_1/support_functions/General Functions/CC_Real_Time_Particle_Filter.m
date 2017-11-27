function [n_words, word_bag, word_bag_prob, top_class_estimation]=CC_Real_Time_Particle_Filter(word_bag, word_bag_prob, top_classes, top_classes_values, LF)
%%%%%%%%%%%%%%%%%%%%%%%%%% Overview %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs: word_bag, word_bag_prob, top_classes, top_classes_values,topNum, LF
% Outputs: n_words, word_bag, word_bag_prob, top_class_estimation
[x,n_samples]=size(top_classes);
[x,n_words]=size(word_bag);

match_found=0;
top_classes_values=top_classes_values/sum(top_classes_values);

for j=1:n_samples
    
    for jj=1:n_words
        if top_classes(j)==word_bag(jj)&&match_found==0
            word_bag_prob(jj)=word_bag_prob(jj)*(1-LF)+top_classes_values(j)*(LF);
            match_found=1;
        end
    end
    
    if(match_found==0)
        n_words=n_words+1;
        word_bag(n_words)=top_classes(j);
        word_bag_prob(n_words)=top_classes_values(j)*(1-LF);
    end 
    match_found=0;
end

word_bag_prob=word_bag_prob/sum(word_bag_prob);

[sort_word_bag_prob,I]=sort(word_bag_prob,'descend');
top_class_estimation=[word_bag(I(1:n_words));sort_word_bag_prob(1:n_words)];

end