
function [q,P]=tracking_kalman_filter(Q,R,y,q,P)

A=[1 0 1 0 1/2 0; 0 1 0 1 0 1/2; 0 0 1 0 1 0  ; 0 0 0 1 0 1; 0 0 0 0 0 0; 0 0 0 0 0 0];
C=[1 1 0 0 0 0];

pred_x=A*q;
pred_cov_P=A*P*A'+Q;
K=(pred_cov_P*C')/(C*pred_cov_P*C'+R);
P=(eye(6)-K*C)*pred_cov_P;

q=pred_x+(K.*(y-pred_x));

end