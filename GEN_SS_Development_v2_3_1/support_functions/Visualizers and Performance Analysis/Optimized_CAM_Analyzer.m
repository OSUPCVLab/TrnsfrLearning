%%%%%% Optimized CAM Analyzer %%%%%
close all; clear all; clc;
addpath('support_functions/');
addpath('orig_img_results/');
load('SA_walking_opt_CAM_all_0.99_w_Unweighted_5_samples.mat');
img_volume=opt_CAM_all;

[~,~,n_frames]=size(img_volume);
%--------------------------------------------------------------------------
[X,Y] = meshgrid(1:14);
xdata = zeros(size(X,1),size(Y,2),2);
xdata(:,:,1) = X;
xdata(:,:,2) = Y;
[Xhr,Yhr] = meshgrid(linspace(1,14,300)); % generate high res grid for plot
xdatahr = zeros(300,300,2);
xdatahr(:,:,1) = Xhr;
xdatahr(:,:,2) = Yhr;

%---Generate noisy centroid---------------------
x_all=ones(n_frames,6);
for i=300
    img=img_volume(:,:,i);
    lb = [0,1,0,1,0,-pi/4];
    ub = [realmax('double'),7,(7)^2,7,(7)^2,pi/4];
    x0 = [255,5,3,7,4,1]; %Inital guess parameters
    [x,resnorm,residual,exitflag] = lsqcurvefit(@D2GaussFunctionRot,x0,xdata,img,lb,ub);
    x_all(i,:)=x;
end

save('SA_walking_2D_Gussian_Estimation_on_PEM_Opt_CAM.mat','x_all');

print=1;
if print == 1
    
    figure(1)
    contourf(img, 255,'LineColor', 'none');
    %%% ---------Plot 3D Image-------------
    figure(2)
    C = del2(img);
    surface(X,Y,img,'EdgeColor','k','FaceColor','none') %plot data
    hold on
    surface(Xhr,Yhr,D2GaussFunctionRot(x,xdatahr),'EdgeColor','none') %plot fit
    alpha(0.2)
    hold off
    
    %---------------------------------------------------------------------------
    %%% -----Plot profiles----------------
    hf2 = figure(3);
    set(hf2, 'Position', [20 20 950 900])
    alpha(0)
    subplot(4,4, [5,6,7,9,10,11,13,14,15])
    imagesc(X(1,:),Y(:,1)',img);
    % set(h1,'YDir','reverse')
    set(gca,'YDir','normal')
    colormap('jet')
    hold on
    
    string1 = ['       Amplitude','    X-Mu', '    X-Sigma','    Y-Mu','    Y-Sigma','     Angle'];
    % string2 = ['Set     ',num2str(xin(1), '% 100.3f'),'             ',num2str(xin(2), '% 100.3f'),'         ',num2str(xin(3), '% 100.3f'),'         ',num2str(xin(4), '% 100.3f'),'        ',num2str(xin(5), '% 100.3f'),'     ',num2str(xin(6), '% 100.3f')];
    string3 = ['Fit      ',num2str(x(1), '% 100.3f'),'             ',num2str(x(2), '% 100.3f'),'         ',num2str(x(3), '% 100.3f'),'         ',num2str(x(4), '% 100.3f'),'        ',num2str(x(5), '% 100.3f'),'     ',num2str(x(6), '% 100.3f')];
    
    text(1,14,string1,'Color','red')
    % text(-MdataSize/2*0.9,+MdataSize/2*1.2,string2,'Color','red')
    text(1,13,string3,'Color','red')
    hold on
    
    % %%% -----Calculate cross sections-------------
    % % generate points along horizontal axis
    m = -tan(x(6));% Point slope formula
    b = (-m*x(2) + x(4));
    xvh = 1:14;
    yvh = xvh*m + b;
    hPoints = interp2(X,Y,img,xvh,yvh,'Linear');
    % generate points along vertical axis
    mrot = -m;
    brot = (mrot*x(4) - x(2));
    yvv = 1:14;
    xvv = yvv*mrot - brot;
    vPoints = interp2(X,Y,img,xvv,yvv,'Linear');
    
    
    % % plot pints
    plot(xvh,yvh,'r.')
    hold on
    plot(xvv,yvv,'g.')
    
    % plot lins
    plot([xvh(1) xvh(size(xvh))],[yvh(1) yvh(size(yvh))],'r')
    plot([xvv(1) xvv(size(xvv))],[yvv(1) yvv(size(yvv))],'g')
    
    % % hold off
    % % axis([-MdataSize/2-0.5 MdataSize/2+0.5 -MdataSize/2-0.5 MdataSize/2+0.5])
    % % %%
    % %
    % % ymin = - noise * x(1);
    % % ymax = x(1)*(1+noise);
    xdatafit = linspace(1,14,300);
    hdatafit = x(1)*exp(-(xdatafit-x(2)).^2/(2*x(3)^2));
    vdatafit = x(1)*exp(-(xdatafit-x(4)).^2/(2*x(5)^2));
    
    subplot(4,4, [1:3])
    xposh = (xvh-x(2))/cos(x(6))+x(2);% correct for the longer diagonal if fi~=0
    plot(xposh,hPoints,'r.',xdatafit,hdatafit,'black')
    % % axis([-MdataSize/2-0.5 MdataSize/2+0.5 ymin*1.1 ymax*1.1])
    subplot(4,4,[8,12,16])
    xposv = (yvv-x(4))/cos(x(6))+x(4);% correct for the longer diagonal if fi~=0
    plot(vPoints,xposv,'g.',vdatafit,xdatafit,'black')
    % % axis([ymin*1.1 ymax*1.1 -MdataSize/2-0.5 MdataSize/2+0.5])
    % set(gca,'YDir','reverse')
    figure(gcf) % bring current figure to front
    
end

%  % Sum in the X direction
% [x,y]=size(img);
% x_vec=1:x;
% y_vec=1:y;
%
% x_sum_vect=zeros(1,x);
% for i=1:y
%     x_sum_vect=x_sum_vect+img(i,:);
% end
% f = fit(x_vec.',x_sum_vect.','gauss1');
%
% figure
% plot(x_sum_vect);
% xlabel('Position');
% ylabel('Occurrence')
%
% y_sum_vect=zeros(y,1);
% for i=1:y
%     y_sum_vect=y_sum_vect+img(:,i);
% end
% figure
% plot(y_sum_vect,y_vec);
% xlabel('Occurrence');
% ylabel('Position')