%%%% VOT Clip Display %%%%

folder_path='C:/Users/karne/Documents/MATLAB/Development Projects/CAM Localization/vot2015_clip_analysis/clips/';
sequence_name_list={'basketball/', 'car1/', 'car2/', 'pedestrian1/','pedestrian2/','road/','racing/','gymnastics1/'};
sequence_name=sequence_name_list{1};
sequence_path=[folder_path,sequence_name];
Files = dir(strcat(sequence_path,'*.jpg'));
ground_truth_path=[folder_path,sequence_name,'/groundtruth.txt'];
true_boxes=load(ground_truth_path);
LengthFiles = length(Files);
sequence_n=LengthFiles;

img1 = imread([sequence_path,Files(2).name]);
corner_xs=[true_boxes(1,1), true_boxes(1,3), true_boxes(1,5), true_boxes(1,7)];
corner_ys=[true_boxes(1,2), true_boxes(1,4), true_boxes(5,6), true_boxes(7,8)];
initial_box=[min(corner_xs),min(corner_ys),max(corner_xs)-min(corner_xs),max(corner_ys)-min(corner_ys)];
[initial_box, ture_here]=GenerateLargerBox(initial_box, 2);

imshow(img1);
rectangle('Position',initial_box,'EdgeColor',[0 0 1]);
