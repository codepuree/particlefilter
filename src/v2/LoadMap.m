function [grid] = load_map(filepath)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
% load_map('C:\Users\Sysadmin\Downloads\Roessl\Vorgabe_update.png')
data_bin = imcomplement(imbinarize(rgb2gray(imread(filepath))));
%grid = robotics.BinaryOccupancyGrid(data_bin,10);
grid = robotics.OccupancyGrid(data_bin,10);
end

