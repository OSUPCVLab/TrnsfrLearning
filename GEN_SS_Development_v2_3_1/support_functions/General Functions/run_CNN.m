function [identities_results, value_category, CAM_volume]=run_CNN(CAM_net, img, box) 
    %%%%%%%%%%%%%%%%%%%%%%%% Overview %%%%%%%%%%%%%%%%%%%%%%%
    % Inputs: CAM_net, img, box, SA_multiplier, print
    % Dependencies: GenerateLargerBox(), returnCAMmap(), prepare_image_range()
    % Outputs: identities_results, value_category, box, img_w_CAM, CAM_volume

    % Create and Prepare Search Area for CAM_net Input
    search_area=imcrop(img,box);
    search_area=imgaussfilt(search_area,1);
    x_ratio=256/box(3);
    y_ratio=256/box(4);
    box=[box(1)*x_ratio,box(2)*y_ratio,box(3)*x_ratio,box(4)*y_ratio];
    search_area_rs = imresize(search_area, [256 256]);
    
    % Run CAM_net on Search Area
    weights_LR = CAM_net.params('CAM_fc',1).get_data();% get the softmax layer of the network
    scores = CAM_net.forward({prepare_image_range(search_area_rs)});% extract conv features online
    activation_lastconv = CAM_net.blobs('CAM_conv').get_data();
    scores = scores{1};
    scoresMean = mean(scores,2);
    
    % Sort Scores Highest to Lowest
    [value_category, IDX_category] = sort(scoresMean,'descend');
    identities_results=IDX_category;
    
    % Return CAM in Ranked Order
    [CAM_volume] = returnCAMmap(activation_lastconv, weights_LR);%(:,IDX_category))
end
    