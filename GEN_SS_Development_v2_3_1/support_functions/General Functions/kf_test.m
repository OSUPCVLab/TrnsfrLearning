close all; clear all; clc;
dt=.1;
t=0:dt:10;
g=1*dt;
wr=.05;
ax=0;
ay=-1;

Q=100;
R=0.01;
y=zeros(length(t),4);
y_meas=y;
filtered_y=zeros(length(t),4);

y(1,:)=[0 10 1 0];
y_meas(1,:)=y(1,:);
filtered_y(1,:)=y(1,:);


xy=[y(1,1) y(1,2)];
pre_xy=xy;
pre_pre_xy=pre_xy;
q=[xy 0 0 0 0]';
P=ones(6,6);

for i=2:length(t) 
    y(i,1)=y(i-1,1)+y(i-1,3);
    y(i,2)=y(i-1,2)+y(i-1,4);
    y(i,3)=(y(i-1,3)+ax)-wr*y(i-1,3);
    y(i,4)=y(i-1,4)+ay;
    
    if y(i,2)<0
        y(i,2)=0;
        y(i,4)=-0.6*y(i,4);
    end
    
    pre_pre_xy=pre_xy;
    pre_xy=xy;
    
    xy=[y(i,1)+rand y(i,2)+rand];
    v_xy=xy-pre_xy;
    a_xy=[0 0];%(xy-pre_xy)-(pre_xy-pre_pre_xy);
    
    meas=[xy v_xy a_xy]';
    y_meas(i,:)=meas(1:4);
    [q,P]=tracking_kalman_filter(Q,R,meas,q,P);
    
    filtered_y(i,:)=q(1:4);

end

figure
subplot(1,2,1)
plot(t,y(:,1))
hold on
plot(t,y_meas(:,1))
hold on
plot(t,filtered_y(:,1))
legend('True', 'Measured', 'Filtered')

subplot(1,2,2)
plot(t,y(:,2))
hold on
plot(t,y_meas(:,2))
hold on
plot(t,filtered_y(:,2))
legend('True', 'Measured', 'Filtered')


