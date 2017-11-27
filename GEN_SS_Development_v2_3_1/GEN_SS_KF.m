function [qxy,Pxy]=GEN_SS_KF(xy_est, previous_positions, qxy, Pxy)
Q=400;
R=600;
pre_xy_est=previous_positions(1,:);
pre_pre_xy_est=previous_positions(2,:);

v_xy_est=xy_est-pre_xy_est;
a_xy_est=(xy_est-2*pre_xy_est+pre_pre_xy_est);

y=[xy_est v_xy_est a_xy_est];

% [qxy,Pxy]=tracking_kalman_filter(Q,R,BB_state',qxy,Pxy);

A=[1 0 1 0 1/2 0; 0 1 0 1 0 1/2; 0 0 1 0 1 0  ; 0 0 0 1 0 1; 0 0 0 0 0 0; 0 0 0 0 0 0];
C=[1 1 0 0 0 0];

pred_x=A*qxy;
pred_cov_Pxy=A*Pxy*A'+Q;
K=(pred_cov_Pxy*C')/(C*pred_cov_Pxy*C'+R);
Pxy=(eye(6)-K*C)*pred_cov_Pxy;
qxy=pred_x+(K.*(y'-pred_x));

end