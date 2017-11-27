function data = prepare_image_range(im)
% ------------------------------------------------------------------------
% caffe/matlab/+caffe/imagenet/ilsvrc_2012_mean.mat contains mean_data that
% is already in W x H x C with BGR channels
im_data = im;
      % permute channels from RGB to BGR for colored images
      if size(im_data, 3) == 3
        im_data = im_data(:, :, [3, 2, 1]);
      end
      % flip width and height to make width the fastest dimension
      im_data = permute(im_data, [2, 1, 3]);
      % convert from uint8 to single
      im_data = single(im_data);
im_data = single(im_data);  % convert from uint8 to single
% mean_data = caffe.io.read_mean('imagenet_mean_range.binaryproto');

% im_data =im_data - mean_data;  % subtract mean_data (already in W x H x C, BGR) 
data = imresize(im_data, [224 224], 'bilinear');  % resize im_data
