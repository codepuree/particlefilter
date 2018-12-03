function [thetas, radius] = GetMeasurement(simFlag, varargin)
%GETMEASUREMENT Summary of this function goes here
%   Detailed explanation goes here

p = inputParser;

% Min range name-value pair
defaultValRootFolder = '../../Data';
validateRootFolder   = @(x) validateattributes(x, {'char'}, {'nonempty'});
addParameter(p, 'rootfolder', defaultValRootFolder, validateRootFolder);

% Min range name-value pair
defaultValIteration = 1;
validateIteration   = @(x) validateattributes(x, {'double', 'single'}, {'positive'});
addParameter(p, 'iteration', defaultValIteration, validateIteration);

% Map name-value pair
defaultValMap = zeros(0);
validateMap   = @(x) validateattributes(x, {'robotics.OccupancyGrid'}, {'nonempty'});
addParameter(p, 'map', defaultValMap, validateMap);

% Pose name-value pair
defaultValPose = zeros(0);
validatePose   = @(x) validateattributes(x, {'double'}, {'nonempty'});
addParameter(p, 'pose', defaultValPose, validatePose);

% Angle range name-value pair
defaultValAngleRange = 0.96;
validateAngleRange   = @(x) validateattributes(x, {'double','single'}, {'nonempty', 'positive'});
addParameter(p, 'anglerange', defaultValAngleRange, validateAngleRange);

% Bins name-value pair
defaultValBins = 10;
validateBins   = @(x) validateattributes(x, {'double','single'}, {'nonempty', 'positive'});
addParameter(p, 'bins', defaultValBins, validateBins);

parse(p, varargin{:});

rootFolder = p.Results.rootfolder;
iteration  = p.Results.iteration;
map        = p.Results.map;
pose       = p.Results.pose;
angleRange = p.Results.anglerange;
bins       = p.Results.bins;

if strcmpi(simFlag,'sim')
    if ~isempty(map) && ~isempty(pose)
        [thetas, radius, ~, ~] = SimulateKinect(map, pose, 'anglerange', angleRange, 'anglesteps', bins);
    else
        error('There occupancy grid is empty!');
    end
elseif strcmpi(simFlag,'Take')
    %% last task; real time 
    warning('No implemented');
elseif exist([rootFolder '/' simFlag '/' simFlag '_' num2str(iteration, '%02.f') '.ply'], 'file')
    filePath = [rootFolder '/' simFlag '/' simFlag '_' num2str(iteration, '%02.f') '.ply'];
    disp(['Loading ''' filePath '''...']);
    pc = pcread(filePath);
    semi_range = angleRange / 2;
    [thetas,radius] = Pcprepare(pc, -0.3,0.3,20, pi/2-semi_range,pi/2+semi_range);
    thetas = thetas - pi / 2;
else
    warning('No valid input');
end

% measurement = [thetas, radius];
end

