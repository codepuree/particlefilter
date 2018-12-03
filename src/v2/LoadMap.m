function [grid] = LoadMap(filepath, varargin)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
% load_map('C:\Users\Sysadmin\Downloads\Roessl\Vorgabe_update.png')

p = inputParser();

defaultValResolution = 100;
validateResolution   = @(x) validateattributes(x, {'single', 'double'}, {'positive'});
addOptional(p, 'resolution', defaultValResolution, validateResolution);

parse(p, varargin{:});

resolution = p.Results.resolution;

regFilepath = regexp(filepath, 'X(?<resolution>\d+)', 'names');
if ~isempty(regFilepath) && isfield(regFilepath, 'resolution')
    imgResolution = str2double(regFilepath.resolution);
else
    imgResolution = defaultValResolution;
end

data_bin = imcomplement(imbinarize(rgb2gray(imread(filepath))));

if resolution ~= imgResolution
    % Resize the image to the desired resolution
    data_bin = imresize(data_bin, resolution / imgResolution);
end

grid = robotics.OccupancyGrid(data_bin, resolution);
end

