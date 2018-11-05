function [thetas, rhos, xs, ys] = SimulateKinect(map, pose, varargin)
%SimulateKinect - Simulates kinect meassurement
%
% Syntax: [thetas, rhos, xs, ys] = SimulateKinect(map, pose)
%
% Long description

x     = pose(1);
y     = pose(2);
theta = pose(3);

p = inputParser;

% Min range name-value pair
defaultValMinrange = 0.5;
validateMinrange   = @(x) validateattributes(x, {'single', 'double'}, {'positive'});
addOptional(p, 'minrange', defaultValMinrange, validateMinrange);

% Max range name-value pair
defaultValMaxrange = 4;
validateMaxrange   = @(x) validateattributes(x, {'single', 'double'}, {'positive'});
addOptional(p, 'maxrange', defaultValMaxrange, validateMaxrange);

% Angles name-value pair
defaultValAngles = zeros(0);   % [0, pi/6, pi/3, pi/2, 4*pi/6, 5*pi/6, pi];
validateAngles   = @(x) validateattributes(x, {'double'}, {'nonempty'});
addOptional(p, 'angles', defaultValAngles, validateAngles);

% Angle steps name-value pair
defaultValAnglesteps = 50;
validateAnglesteps   = @(x) validateattributes(x, {'double'}, {'nonempty'});
addOptional(p, 'anglesteps', defaultValAnglesteps, validateAnglesteps);

% Angle range name-value pair
defaultValAnglerange = 0.96;
validateAnglerange   = @(x) validateattributes(x, {'double'}, {'nonempty'});
addOptional(p, 'anglerange', defaultValAnglerange, validateAnglerange);

parse(p, varargin{:});

maxRange   = p.Results.maxrange;
minRange   = p.Results.minrange;
%robotPose  = [x, y, theta];
angles     = p.Results.angles;
angleSteps = p.Results.anglesteps;
angleRange = p.Results.anglerange;

if isempty(angles)
    angles = -angleRange / 2 : angleRange / angleSteps : angleRange / 2;
else
    angles = p.Results.angles;
end

idnn = ~isnan(angles);

intersectionPts = NaN(length(angles), 2);
intersectionPts(idnn, :) = rayIntersection(map, pose, angles(idnn), maxRange);

pointsReduced = intersectionPts - [x, y];

[thetas, rhos] = cart2pol(pointsReduced(:, 1), pointsReduced(:, 2));

% Filter distance between min range 0.5 m and max range 4 m
rhosIndices = rhos < minRange;

thetas(rhosIndices) = NaN;
rhos(rhosIndices)   = NaN;

thetas = thetas - theta;

intersectionPts(rhosIndices, 1) = NaN;
intersectionPts(rhosIndices, 2) = NaN;

xs = intersectionPts(:, 1);
ys = intersectionPts(:, 2);

end