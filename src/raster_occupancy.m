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
num_subp = 4;
Streu = [0.4,pi/16];
Streu3 = [0.1,0.1,pi/16];
Faktor = 0.8;
process = 1;    %%process 1 = calc, 0 = load data;
limes = 0.7;

%%
Init = Initialization(grid,orient);

%% Weighting 
W_v(1:length(Init)) = (1/length(Init))';

%% Movement
move = [-0.5,0,0];  % delta x,y[m] & o[rad]: 0.5,0 & 0
Test_pose = [29.39,24.104,0.953];

n_0 = floor(length(Init)*Faktor);
n = n_0;
%%

while (iteration < 25)
[New_Pose,Test_pose,iteration] = Iteration_proc(Init,move,grid,n,num_subp,Test_pose,iteration,Streu3,process,limes);   
Init = New_Pose;
n = max(floor(n*Faktor), 500);
if (iteration == 10)
    move = [0,0,0];
end
end
delete(poolObj);



