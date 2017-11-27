function [image]=image_normalization(img)
min_v=min(min(img));
img1=img-min_v;
max_v=max(max(img1));
image=img1*255/max_v;
image=uint8(image);
end