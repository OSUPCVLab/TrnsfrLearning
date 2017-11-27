function print_Image_w_CAM(sequence_name_list, topNum, LF, track_or_detect, BB_type, SA_multiplier, data_folder_path, clip_dir, full_or_cropped)
%%%%%%%%%%%%%%%%%%%%%%%% Load Constants %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rgb=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,5,9,13,17,21,25,29,33,37,41,45,49,53,57,61,65,69,73,77,81,85,89,93,97,101,105,109,113,117,121,125,129,133,137,141,145,149,153,157,161,165,169,173,177,181,185,189,193,197,201,205,209,213,217,221,225,229,233,237,241,245,249,253,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,251,247,243,239,235,231,227,223,219,215,211,207,203,199,195,191,187,183,179,175,171,167,163,159,155,151,147,143,139,135,131,127;0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,8,12,16,20,24,28,32,36,40,44,48,52,56,60,64,68,72,76,80,84,88,92,96,100,104,108,112,116,120,124,128,132,136,140,144,148,152,156,160,164,168,172,176,180,184,188,192,196,200,204,208,212,216,220,224,228,232,236,240,244,248,252,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,252,248,244,240,236,232,228,224,220,216,212,208,204,200,196,192,188,184,180,176,172,168,164,160,156,152,148,144,140,136,132,128,124,120,116,112,108,104,100,96,92,88,84,80,76,72,68,64,60,56,52,48,44,40,36,32,28,24,20,16,12,8,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;127,131,135,139,143,147,151,155,159,163,167,171,175,179,183,187,191,195,199,203,207,211,215,219,223,227,231,235,239,243,247,251,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,253,249,245,241,237,233,229,225,221,217,213,209,205,201,197,193,189,185,181,177,173,169,165,161,157,153,149,145,141,137,133,129,125,121,117,113,109,105,101,97,93,89,85,81,77,73,69,65,61,57,53,49,45,41,37,33,29,25,21,17,13,9,5,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];            rgb=rgb';
print_size=500;

%%%%%%%%%%%%%%%%%%%%%%%% Set Data Folder Path %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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



%%%%%%%%%%%%%%%%%%%%%%%%% Presets for Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ii=1:length(sequence_name_list)
    close all
    % Set Clip Directory
    sequence_name=sequence_name_list{ii};
    sequence_path=[clip_dir sequence_name '/'];
    Files = dir(strcat(sequence_path,'*.jpg'));
    ground_truth_path=[sequence_path 'groundtruth.txt'];
    true_boxes=load(ground_truth_path);
    LengthFiles = length(Files);
    sequence_n=LengthFiles;
    
    addpath([data_folder_path sequence_name '_results/LF' num2str(LF) 'n' num2str(topNum)]);
    load([sequence_name '_opt_CAM_all_' num2str(LF) '_w_' num2str(topNum) '_classes.mat']);
    load([sequence_name '_estimated_BB_all_w_LF_' num2str(LF) '_n_' num2str(topNum) '.mat']);
    img_volume=opt_CAM_all;
    [~,~,n_frames]=size(img_volume);
    
    
    % Calculate Estimated Bounding Box
    for i=2:n_frames
        % Load Image
        img1 = imread([sequence_path,Files(i).name]);
        
%%%%%%%%%%%%%%%%%%%%%%%% Create Search Area %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Load Bounding Box of Frame 1 and Format to Uniform Order
        % i-1 is used since the previous BB is used to create SA
        if track_or_detect==1
            current_BB=estimated_BB_all(i-1,:);
        else
            if BB_type==1 % Square
                corner_xs=[true_boxes(i-1,1), true_boxes(i-1,3), true_boxes(i-1,5), true_boxes(i-1,7)];
                corner_ys=[true_boxes(i-1,2), true_boxes(i-1,4), true_boxes(i-1,6), true_boxes(i-1,8)];
                
                if max(corner_xs)-min(corner_xs)>max(corner_ys)-min(corner_ys)
                    current_BB=[min(corner_xs),min(corner_ys),max(corner_xs)-min(corner_xs),max(corner_xs)-min(corner_xs)];
                else
                    current_BB=[min(corner_xs),min(corner_ys),max(corner_ys)-min(corner_ys),max(corner_ys)-min(corner_ys)];
                end
            else % Rectangular
                corner_xs=[true_boxes(i-1,1), true_boxes(i-1,3), true_boxes(i-1,5), true_boxes(i-1,7)];
                corner_ys=[true_boxes(i-1,2), true_boxes(i-1,4), true_boxes(i-1,6), true_boxes(i-1,8)];
                current_BB=[min(corner_xs),min(corner_ys),max(corner_xs)-min(corner_xs),max(corner_ys)-min(corner_ys)];
            end
        end
        
        [SA_box, ~]=GenerateLargerBox(current_BB, SA_multiplier);
        img_size=size(img1);

        % Check that the SA is Contained within the Frame
        if SA_box(1) < 1
            SA_box(1)=1;
        end
        if SA_box(2) < 1
            SA_box(2)=1;
        end
        
        SA_box_x_max=SA_box(1)+SA_box(3);
        SA_box_y_max=SA_box(2)+SA_box(4);
        if SA_box(1) > img_size(2) || SA_box_x_max > img_size(2)
            if SA_box(3)<img_size(2)
                SA_box(1)=img_size(2)-SA_box(3);
            else
                SA_box(1)=1;
                SA_box(3)=img_size(2);
            end
        end
        if SA_box(2) > img_size(1) || SA_box_y_max > img_size(1)
            if SA_box(4)<img_size(1)
                SA_box(2)=img_size(1)-SA_box(4);
            else
                 SA_box(2)=1;
                 SA_box(4)=img_size(1);
            end
        end

        % Load Optimized Class Activation Map
        opt_CAM=opt_CAM_all(:,:,i);
        
        % Resize CAM to Same Size as Search Region
        CAM_img_rs=imresize(opt_CAM,[SA_box(3), SA_box(4)]);
        CAM_img_rs=CAM_img_rs-min(CAM_img_rs(:));
        CAM_img_rs=CAM_img_rs/max(CAM_img_rs(:));
        SA_box=floor(SA_box);
        
        % Print CAM on Full Image or Cropped Search Region
        if full_or_cropped==1
            comb_img=img1;
            bw_comb_img=rgb2gray(comb_img);
            img_size=size(comb_img);
            
            SA_box
            for m=1:SA_box(4)-1
                for n=1:SA_box(3)-1
                    if SA_box(2)+m < img_size(1) && SA_box(1)+n < img_size(2)
                        l=bw_comb_img(SA_box(2)+m,SA_box(1)+n,:);
                        jet_rgb=rgb(1+floor(CAM_img_rs(n,m,1)*254),:);
                        comb_img(SA_box(2)+m,SA_box(1)+n,:)=uint8(jet_rgb.*double(l)/255);
                    end
                end
            end
        else
            comb_img=imcrop(img1,SA_box);
            bw_comb_img=rgb2gray(comb_img);
            img_size=size(comb_img);
            
            for m=1:SA_box(4)-1
                for n=1:SA_box(3)-1
                    if m < img_size(1) && n < img_size(2)
                        l=bw_comb_img(m,n,:);
                        jet_rgb=rgb(1+floor(CAM_img_rs(n,m,1)*254),:);
                        comb_img(m,n,:)=uint8(jet_rgb.*double(l)/255);
                    end
                end
            end
            % Find Largest Dimension of Cropped Image
            [~,ind]=max(img_size);
            % Calculate Relative Size of Cropped to Full Image
            
            rel_size=print_size/img_size(ind);
            comb_img_resize=imresize(comb_img,rel_size);
            CI_rs_size=size(comb_img_resize);
            dw=(print_size-CI_rs_size(1))/2;
            dh=(print_size-CI_rs_size(2))/2;
            
            blank_canvas=uint8(zeros(print_size,print_size,3));
            blank_canvas(1+dw:print_size-dw,1+dh:print_size-dh,:)=comb_img_resize;
            clear comb_img;
            comb_img=blank_canvas;
        end
        
        % Ground Truth BB
        if BB_type==1 % Square
            corner_xs=[true_boxes(i,1), true_boxes(i,3), true_boxes(i,5), true_boxes(i,7)];
            corner_ys=[true_boxes(i,2), true_boxes(i,4), true_boxes(i,6), true_boxes(i,8)];
            
            if max(corner_xs)-min(corner_xs)>max(corner_ys)-min(corner_ys)
                gt_BB=[min(corner_xs),min(corner_ys),max(corner_xs)-min(corner_xs),max(corner_xs)-min(corner_xs)];
            else
                gt_BB=[min(corner_xs),min(corner_ys),max(corner_ys)-min(corner_ys),max(corner_ys)-min(corner_ys)];
            end
        else % Rectangular
            corner_xs=[true_boxes(i,1), true_boxes(i,3), true_boxes(i,5), true_boxes(i,7)];
            corner_ys=[true_boxes(i,2), true_boxes(i,4), true_boxes(i,6), true_boxes(i,8)];
            gt_BB=[min(corner_xs),min(corner_ys),max(corner_xs)-min(corner_xs),max(corner_ys)-min(corner_ys)];
        end

        current_BB=estimated_BB_all(i,:);
        
        %%%% Print and Save Figure
        figure(1)
        imshow(comb_img)
        text(10,10,['LF' num2str(LF) 'n' num2str(topNum)],'Color','w');
        hold on
        text(10,30,['Frame: ' num2str(i)],'Color','w');
        hold on
        rectangle('Position',gt_BB,'EdgeColor',[1 1 1],'LineStyle','--','LineWidth',2)
        hold on
        rectangle('Position',current_BB,'EdgeColor',[0 0 0],'LineWidth',2)
        
        saveas(gcf,[data_folder_path sequence_name '_results/LF' num2str(LF) 'n' num2str(topNum) '/' num2str(i)],'png')
        
    end
end
end