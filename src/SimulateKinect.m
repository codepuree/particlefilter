function [thetas, rhos, xs, ys] = SimulateKinect(map, x, y, theta, varargin)
%SimulateKinect - Simulates kinect meassurement
%
% Syntax: [thetas, rhos, xs, ys] = SimulateKinect(map, x, y, theta)
%
% Long description

p = inputParser;

% Max range name-value pair
defaultValMaxrange = 0;
validateMaxrange   = validateattributes();
addParameter(p, 'maxrange', defaultValMaxrange)

addParameter(p, 'maxrange', 5, @isnumeric);
addParameter(p, 'angles',   [0, pi/6, pi/3, pi/2, 4*pi/6, 5*pi/6, pi], @isnumeric);
parse(p, varargin{:});

p.Results

maxrange = p.Results.maxrange;
robotPose = [x, y, theta];

angles = [0, pi/6, pi/3, pi/2, 4*pi/6, 5*pi/6, pi];
angles = angles + pi / 2;
angles = angles - theta;

intersectionPts = rayIntersection(map, robotPose, angles, maxrange);

pointsReduced = intersectionPts - [x, y];
pointsReduced = pointsReduced(~isnan(pointsReduced(:, 1)), :);

xs = intersectionPts(:, 1);
ys = intersectionPts(:, 2);

[thetas, rhos] = cart2pol(pointsReduced(:, 1), pointsReduced(:, 2));
end