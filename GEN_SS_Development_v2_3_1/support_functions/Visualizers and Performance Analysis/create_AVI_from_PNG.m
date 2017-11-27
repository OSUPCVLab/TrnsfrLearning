function create_AVI_from_PNG(topNum, LF, sequence_name, track_or_detect, BB_type, data_folder_path)
% Set Data Folder Path to Selected BB Type
if track_or_detect==1
    if BB_type==1
        data_folder_path=[data_folder_path 'tracking/square_BB_results/'];
    else
        data_folder_path=[data_folder_path 'tracking/rectangle_BB_results/'];
    end
else
    if BB_type==1
        data_folder_path=[data_folder_path 'detecting/square_BB_results/'];
    else
        data_folder_path=[data_folder_path 'detecting/rectangle_BB_results/'];
    end
end

workingDir=[data_folder_path '/' sequence_name '_results/LF' num2str(LF) 'n' num2str(topNum) '/'];

imageNames = dir(fullfile(workingDir,'*.png'));
imageNames = {imageNames.name}';

str  = sprintf('%s#', imageNames{:});
num  = sscanf(str, '%d.png#');
[~, index] = sort(num);
imageNames = imageNames(index);

name_str=[sequence_name '_LF_' num2str(LF) '_n_' num2str(topNum)];
outputVideo = VideoWriter(fullfile(workingDir,[name_str '.avi']));
outputVideo.FrameRate = 15;
open(outputVideo)


for ii = 1:length(imageNames)
   img = imread(fullfile(workingDir,imageNames{ii}));
   writeVideo(outputVideo,img)
end


close(outputVideo)