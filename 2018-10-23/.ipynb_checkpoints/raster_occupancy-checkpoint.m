%% Clear matlab environment
clear all;
close all;
clc;

%% load grid
axis equal
grid = load_map('C:\Users\Sysadmin\Downloads\Roessl\Vorgabe_update.png');
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

%% Rating










