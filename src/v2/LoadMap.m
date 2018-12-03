function [grid] = LoadMap(filepath, varargin)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
% load_map('C:\Users\Sysadmin\Downloads\Roessl\Vorgabe_update.png')

p = inputParser();

defaultValResolution = 10;
validateResolution   = @(x) validateattributes(x, {'single', 'double'}, {'positive'});
addOptional(p, 'resolution', defaultValResolution, validateResolution);

parse(p, varargin{:});

regFilepath = regexp(filepath, 'X(?<resolution>\d+)', 'names');
if ~isempty(regFilepath) && isfield(regFilepath, 'resolution')
    resolution = str2double(regFilepath.resolution);
else
    resolution = p.Results.resolution;
end

data_bin = imcomplement(imbinarize(rgb2gray(imread(filepath))));

grid = robotics.OccupancyGrid(data_bin, resolution);
end

