function [measurement] = GetMeasurement(simFlag, varargin)
%GETMEASUREMENT Summary of this function goes here
%   Detailed explanation goes here

p = inputParser;

% Min range name-value pair
defaultValRootFolder = '../../Data';
validateRootFolder   = @(x) validateattributes(x, {'char'}, {});
addParameter(p, 'rootfolder', defaultValRootFolder, validateRootFolder);

% Min range name-value pair
defaultValIteration = 1;
validateIteration   = @(x) validateattributes(x, {'double', 'single'}, {'positive'});
addParameter(p, 'iteration', defaultValIteration, validateIteration);

parse(p, varargin{:});

rootFolder = p.Results.rootfolder;
iteration  = p.Results.iteration;

if isempty(simFlag)
    SimulateKinect();
elseif strcmpi(simFlag,'Take')
    warning('No implemented');
elseif exist([rootFolder '/' simFlag '/' simFlag '_' num2str(iteration, '%02.f') '.ply'], 'file')
    filePath = [rootFolder '/' simFlag '/' simFlag '_' num2str(iteration, '%02.f') '.ply'];
    disp(['Loading ''' filePath '''...']);
    pc = pcread(filePath);
    semi_range = 27.125 * pi/180;
    [thetas,radius] = Pcprepare(pc, -0.3,0.3,20, pi/2-semi_range,pi/2+semi_range);
    thetas = thetas - pi / 2;
else
    warning('No valid input');
end

measurement = [thetas, radius];
end

