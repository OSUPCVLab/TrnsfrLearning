function BoW=GEN_SS_BoW_Update(BoW, identity_results, value, LF, topNum)
%%%%%%%%%%%%%%%%%%%%%%%%%% Overview %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs: word_bag, word_bag_prob, top_classes, top_classes_values,topNum, LF
% Outputs: n_words, word_bag, word_bag_prob, top_class_estimation
top_classes=identity_results(1:topNum);
top_classes_values=value(1:topNum);
top_classes_values=top_classes_values/sum(top_classes_values);

BoW=BoW*(1-LF);
for j=1:topNum
        BoW(top_classes(j))=top_classes_values(j)*(LF);
end

BoW=BoW/sum(BoW);

end