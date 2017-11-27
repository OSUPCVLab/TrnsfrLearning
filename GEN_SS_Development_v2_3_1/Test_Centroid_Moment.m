% Test Calculate Centroid and Momet Function
close all; clear all; clc;
heatMap = fspecial('gaussian', 14, 2);
[moment,centroid]=calculateCentroidAndMoment(heatMap);
