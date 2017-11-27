close all; clear all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%% Import and Initiate CNN %%%%%%%%%%%%%%%%%%%%%%%%
addpath('C:\libraries\caffe-windows-master\matlab');
net_weights = '../models/imagenet_googleletCAM_train_iter_120000.caffemodel';
net_model = '../models/deploy_googlenetCAM.prototxt';
net = caffe.Net(net_model, net_weights, 'test');
load('categories1000.mat');

%%%%%%%%%%%%%%%%%%%%%%%%% Presets for Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
folder_path='C:/data_sets/TB_50/';

sequence_name='Walking';
sequence_path=[folder_path,sequence_name,'/img/'];
Files = dir(strcat(sequence_path,'*.jpg'));
ground_truth_path=[folder_path,sequence_name,'/groundtruth_rect.txt'];
true_boxes=load(ground_truth_path);
LengthFiles = length(Files);
sequence_n=LengthFiles;

for i=1:sequence_n
    % Import Img and Ground Truth Bounding Box
    img1 = imread([sequence_path,Files(i).name]);
    initial_box=true_boxes(i,:);
    imshow(img1);
    hold on
    rectangle('Position',initial_box);
    hold on
    text(10,30,'Black=Current')
    if i~=1
        hold on
        rectangle('Position',prev_box,'EdgeColor',[1 1 1]);
        hold on
        text(10,40,'White=Previous')
    end
    prev_box=initial_box;
    
end