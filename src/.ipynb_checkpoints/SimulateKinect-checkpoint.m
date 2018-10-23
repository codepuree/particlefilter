function [thetas, rhos, xs, ys] = SimulateKinect(map, x, y, theta, varargin)
%SimulateKinect - Simulates kinect meassurement
%
% Syntax: [thetas, rhos, xs, ys] = SimulateKinect(map, x, y, theta)
%
% Long description

p = inputParser;

% Max range name-value pair
defaultValMaxrange = 5;
validateMaxrange   = @(x) validateattributes(x, {'single', 'double'}, {'positive'});
addOptional(p, 'maxrange', defaultValMaxrange, validateMaxrange);

% Angles name-value pair
defaultValAngles = (theta - 0.48) : 2 * pi / 500 : (theta + 0.48);   % [0, pi/6, pi/3, pi/2, 4*pi/6, 5*pi/6, pi];
validateAngles   = @(x) validateattributes(x, {'double'}, {'nonempty'});
addOptional(p, 'angles', defaultValAngles, validateAngles);

parse(p, varargin{:});

maxrange  = p.Results.maxrange;
robotPose = [x, y, theta];

angles = p.Results.angles;
angles = angles + pi / 2;
angles = angles - theta;

intersectionPts = rayIntersection(map, robotPose, angles, maxrange);

pointsReduced = intersectionPts - [x, y];
pointsReduced = pointsReduced(~isnan(pointsReduced(:, 1)), :);

xs = intersectionPts(:, 1);
ys = intersectionPts(:, 2);

[thetas, rhos] = cart2pol(pointsReduced(:, 1), pointsReduced(:, 2));
end