function [grid] = load_map(filepath, varargin)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
% load_map('C:\Users\Sysadmin\Downloads\Roessl\Vorgabe_update.png')

p = inputParser();

defaultValResolution = 10;
validateResolution   = @(x) validateattributes(x, {'single', 'double'}, {'positive'});
addOptional(p, 'resolution', defaultValResolution, validateResolution);

parse(p, varargin{:});

data_bin = imcomplement(imbinarize(rgb2gray(imread(filepath))));
%grid = robotics.BinaryOccupancyGrid(data_bin,p.Results.resolution);
grid = robotics.OccupancyGrid(data_bin,p.Results.resolution);
end

