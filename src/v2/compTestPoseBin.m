% Setup
close all;
clear all;
clc;

% Compare bins to single
map  = LoadMap('../../Data/Vorgabe.png',100);

% pose = [39.83, 10.47, -1.1+pi];
pose = [22.3764, 5.3612, -1.1-pi/4];

figure();
show(map);
hold on;
scatter(pose(1), pose(2), 'Or')
[u, v] = pol2cart(pose(3), 1);
quiver(pose(1), pose(2), u, v);

[thetas_all, rhos_all, x, y] = SimulateKinect(map, pose, 'anglesteps', 500);
scatter(x, y, '.b');

% Generate bins
numElements = 11;
semi_range  = 27.125 * pi / 180;
% thetaMin    = pi / 2 - semi_range;
% thetaMax    = pi / 2 + semi_range;
thetaMin    = min(thetas_all);
thetaMax    = max(thetas_all);
thetaDiff   = thetaMax - thetaMin;
thetas_bins = double(linspace(thetaMin, thetaMax, numElements)');
rhos_bins   = double(arrayfun(@(x) nanmedian(rhos_all(thetas_all > x & thetas_all < (x + thetaDiff / numElements))), thetas_bins));

% Simultate
[thetas_sim, rhos_sim] = SimulateKinect(map, pose, 'angles', thetas_bins);

theta_diff = thetas_bins - thetas_sim;
rhos_diff  =   rhos_bins - rhos_sim;

disp(['Thetas ' num2str(length(thetas_bins))]);