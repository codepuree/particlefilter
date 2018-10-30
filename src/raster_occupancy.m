%% Clear matlab environment
clear all
close all
clc

%% load grid
axis equal
grid = LoadMap('..\Data\Vorgabe_update.png');
show(grid);
hold on

%% Generate raster
[X, Y] = meshgrid(grid.XWorldLimits(1):0.5:grid.XWorldLimits(2),grid.YWorldLimits(1):0.5:grid.YWorldLimits(2));
X      = reshape(X,numel(X),1);
Y      = reshape(Y,numel(Y),1);

mesh   = [X,Y];
raster = getOccupancy(grid, mesh);

rIdxOcc   = raster < 0.5;
rIdxUnOcc = raster > 0.5;
free_raster       = mesh(rIdxOcc, :);
% die       = mesh(rIdxUnOcc, :);


a = 0:pi/35:2*pi;
scatter(free_raster(:,1),free_raster(:,2), '*r');
% scatter(die(:,1),die(:,2), '*b');
[r_f,c_f]=size(free_raster);
orient = 0:pi/18:2*pi;%0:6*rho:60*rho;

%%  1.Initalisierung Matrix ( x, y, o)

Init = zeros(r_f,length(orient),3);
for i = 1:r_f
    for j = 1: length(orient)
       Init(i,j,1) = free_raster(i,1);
       Init(i,j,2) = free_raster(i,2);      
       Init(i,j,3) = orient(j);
    end
end
Init = reshape(Init,[r_f*length(orient),3]);

%% Weighting 
W_v(1:length(Init)) = (1/length(Init))';

%% Movement
move = [0.5,0,0];  % delta x,y[m] & o[rad]: 0.5,0 & 0 

%% Measurement
%CaptureKinnect

%% 4.Propagation
Init = Init + move;
Pose_occ = getOccupancy(grid,Init(:,1:2));
Pose_IdxOcc   = Pose_occ < 0.5;
Init = Init(Pose_IdxOcc,:);
% Sim for each Pose "measure"

%% Rating
% Simulation-Measurement
% a) Korrelation Angle-histo
% b) Linear weighting distance-difference
% c) innovation (script Abmayr)
% d) Non linear weighting distance difference 

% for i = 1:

[theta_S,rho_S,~,~] = SimulateKinect(grid, [32, 30, pi/4]);
% antw = NaN(length(Init),1);
% for i = 1:length(Init)
% [thetas, rhos,~,~] = SimulateKinect(grid, Init(i,:),'angles',theta_S);
% antw(i,1) = sum(abs(rho_S-rhos));
% end

profile on
numWorkers = 3;
poolObj = parpool('local', numWorkers);
out = cell(numWorkers, 1);
parfor i = 1 : numWorkers
    range = floor(size(Init,1) / numWorkers);
    start = (i - 1) * range;
    
    if start == 0
        start = 1;
    end
    
    if i == numWorkers
        range = size(Init,1) - (numWorkers - 1) * range;
    end
    
    stop = start + range;
    
    out{i} = arrayfun(@(m) diffDist(grid, Init(m,:), theta_S, rho_S), start:stop);
end
profile viewer
delete(poolObj);

nn = ~isnan(antw);
figure();
show(grid);
hold on
scatter(Init(nn, 1), Init(nn, 2), 'ob');
hold on
scatter(32, 30, 'xr')

% function [] = displ(x,y,a)
%     disp(x);
%     disp(y);
%     disp(a);
% end


function [dist] = diffDist(grid, pose, theta_S, rho_S)
    [~, rhos,~,~] = SimulateKinect(grid, pose,'angles',theta_S);
    dist = mean(abs(rho_S - rhos));
end
