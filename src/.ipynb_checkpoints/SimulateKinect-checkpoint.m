function [thetas, rhos, xs, ys] = SimulateKinect(map, x, y, theta, varargin)
%SimulateKinect - Simulates kinect meassurement
%
% Syntax: [thetas, rhos, xs, ys] = SimulateKinect(map, x, y, theta)
%
% Long description

p = inputParser;
addParameter(p, 'maxrange', 5, @isnumeric);
parse(p, varargin{:});

p.Results

robotPose = [x, y, theta];

angle = [0, pi/6, pi/3, pi/2, 4*pi/6, 5*pi/6, pi];
angle = angle + pi / 2;
angle = angle - theta;

% maxrange = p.Results.maxrange;
maxrange = 5;

intersectionPts = rayIntersection(map, robotPose, angle, maxrange);

pointsReduced = intersectionPts - [x, y];
pointsReduced = pointsReduced(~isnan(pointsReduced(:, 1)), :);

xs = intersectionPts(:, 1);
ys = intersectionPts(:, 2);

[thetas, rhos] = cart2pol(pointsReduced(:, 1), pointsReduced(:, 2));
end