%% Clear matlab environment
clear all
close all
clc
% set(groot, 'defaultFigureVisible','off');

poolObj = gcp('nocreate');
if isempty(poolObj)
    numWorkers = 4;
    poolObj = parpool('local', numWorkers);
end

%% load grid
axis equal
grid = LoadMap('..\Data\Vorgabe_Raum.png');
show(grid);
hold on

%% define Var
orient = 0:pi/18:2*pi;%0:6*rho:60*rho;
iteration = 1;
Streu = [0.5,pi];
Faktor = 0.8;

%%
Init = Initialization(grid,orient);

%% Weighting 
W_v(1:length(Init)) = (1/length(Init))';

%% Movement
move = [-0.5,0,0];  % delta x,y[m] & o[rad]: 0.5,0 & 0
Test_pose = [29.239,23.104,0.973];

n_0 = floor(length(Init)*Faktor);
n = n_0;

%% Measurement
%CaptureKinnect
while (iteration < 10)
tic
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

if (n ~= n_0)
Test_pose = Test_pose + move;
end
[antw,theta_S,rho_S] = Test_Measure(Test_pose,grid,Init,1); %process 1= calc;

nn = ~isnan(antw);
numberOfNonZeros = nnz(nn);
%w = zeros(numberOfNonZeros,1);
w = 1./antw(nn);
sW = sum(w);
wN = w./sW;
INN = Init(nn,:);
% figure();
% show(grid);
% hold on
% scatter3(INN(:,1),INN(:,2),wN);
% surf(INN(:,1),INN(:,2),wN);

figure();
show(grid);
hold on
scatter(INN(:,1),INN(:,2), [],wN);

scatter(Test_pose(1),Test_pose(2), 'xr')

%% 6.Resampling
% n & Streu should be reduced while iterating n(1) >>>> n(10...)
New_Pose = Resample(n,wN,INN,Streu);
hold on
scatter(New_Pose(:,1),New_Pose(:,2), '.b')

Init = New_Pose;
Streu = Streu * Faktor  ;
n = floor(n*Faktor);
iteration = iteration +1;
toc
end

delete(poolObj);



