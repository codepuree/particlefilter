function [ ptCloudFlatten ] = FlattenPointCloud( ptCloud )
%GETCROSSPROFILE Summary of this function goes here
%   Detailed explanation goes here

location = ptCloud.Location;
location(:, 2) = 0;

[uniqueLocation, uniqueIndex, ~] = unique(location, 'rows');
location = location(uniqueIndex, :);
color = ptCloud.Color(uniqueIndex, :);

ptCloudFlatten = pointCloud(location);
ptCloudFlatten.Color = color;
