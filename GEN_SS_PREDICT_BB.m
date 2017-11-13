function [estimated_BB, qxy, Pxy]=GEN_SS_PREDICT_BB(CAM_volume, BoW, qxy, Pxy, SA_box, Gauss_fit_inputs, KF_inputs, previous_positions, img_size)
        % Create Optimized CAM of SA with BoW at Frame 'i'
        opt_CAM=zeros(14,14);
        for j=1:length(BoW)
            opt_CAM=opt_CAM+CAM_volume(:,:,j)*BoW(j);
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%% Predict BB with 2D Gaussian Fit %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Normalize Optimized CAM
        opt_CAM=opt_CAM-min(opt_CAM(:));
        opt_CAM=double(opt_CAM/max(opt_CAM(:)));
        
        % Create Meshgrid for 2D Gaussian Fit
        [X,Y] = meshgrid(1:14);
        xdata = zeros(size(X,1),size(Y,2),2);
        xdata(:,:,1) = X;
        xdata(:,:,2) = Y;
        
        % Fit CAM to 2D Guassian and Estimate Center Location
        max_iter=Gauss_fit_inputs(1);
        error_thresh=Gauss_fit_inputs(2);
        bb_H_W_std_Multiplier=Gauss_fit_inputs(3);
        bb_learning_ratio=Gauss_fit_inputs(4);
        lb = [0,0,0,0,0];%,-pi/4
        ub = [255,7.5,7^2,7.5,7^2];%,pi/4
        options=optimoptions('lsqcurvefit','Algorithm','levenberg-marquardt','MaxIterations',max_iter,'FunctionTolerance',error_thresh,'Display','none');
        x0 = [255,7,1,7,1]; %Inital guess parameters
        [x,~,~,~] = lsqcurvefit(@D2GaussFunction,x0,xdata,opt_CAM,lb,ub,options);
        
        % Scale Estimated BB to SA
        fixed=2; % This controls the BB HW method. If 1, then BB WH do not change. If 2 BB WH are updated each frame
        if fixed==1
            estimated_w=first_BB(3);
            estimated_h=first_BB(4);
        elseif fixed==2
            estimated_w=x(3)/14*SA_box(3)*bb_H_W_std_Multiplier;
            estimated_h=x(5)/14*SA_box(4)*bb_H_W_std_Multiplier;
        else
            estimated_w=(bb_learning_ratio)*x(3)/14*SA_box(3)*bb_H_W_std_Multiplier+(1-bb_learning_ratio)*previous_BB(3);
            estimated_h=(bb_learning_ratio)*x(5)/14*SA_box(4)*bb_H_W_std_Multiplier+(1-bb_learning_ratio)*previous_BB(4);
        end
        
        estimated_x=x(2)/14*SA_box(3)+SA_box(1);
        estimated_y=x(4)/14*SA_box(4)+SA_box(2);
        
        estimated_BB=[estimated_x-estimated_w/2,estimated_y-estimated_h/2,estimated_w,estimated_h];
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Kalman Filter
        KF_switch=1; % This variable turns the Kalman Filter on and off
        if KF_switch==1
            xy_est=[estimated_BB(1)+estimated_BB(3)/2 estimated_BB(2)+estimated_BB(4)/2];
            [qxy,Pxy]=GEN_SS_KF(xy_est, previous_positions, qxy, Pxy, KF_inputs(1), KF_inputs(2));
            estimated_BB=[qxy(1)-estimated_BB(3)/2 qxy(2)-estimated_BB(4)/2 estimated_BB(3) estimated_BB(4)];
        end
        
        % Check that the Estimated Bounding Box is in Bounds
        if estimated_BB(1) < 1
            estimated_BB(1)=1;
        end
        if estimated_BB(2) < 1
            estimated_BB(2)=1;
        end
        
        estimated_BB_x_max=estimated_BB(1)+estimated_BB(3);
        estimated_BB_y_max=estimated_BB(2)+estimated_BB(4);
        if estimated_BB(1) > img_size(2) || estimated_BB_x_max > img_size(2)
            if estimated_BB(3)<img_size(2)
                estimated_BB(1)=img_size(2)-estimated_BB(3);
            else
                estimated_BB(1)=1;
                estimated_BB(3)=img_size(2);
            end
        end
        if estimated_BB(2) > img_size(1) || estimated_BB_y_max > img_size(1)
            if estimated_BB(4)<img_size(1)
                estimated_BB(2)=img_size(1)-estimated_BB(4);
            else
                estimated_BB(2)=1;
                estimated_BB(4)=img_size(1);
            end
        end
end