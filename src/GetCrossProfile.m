function [ ptCloudCrossProfile ] = GetCrossProfile( ptCloud, minimum, maximum)
%GETCROSSPROFILE Summary of this function goes here
%   Detailed explanation goes here

indexLocation = ptCloud.Location(:, 2) > minimum & ptCloud.Location(:, 2) < maximum;
location      = ptCloud.Location(indexLocation, :);
[uniqueLocation, indexUniqueLocation, ~] = unique(location, 'rows');
location      = location(indexUniqueLocation, :);
color         = ptCloud.Color(indexUniqueLocation, :);

ptCloudCrossProfile       = pointCloud(location);
ptCloudCrossProfile.Color = color;

end