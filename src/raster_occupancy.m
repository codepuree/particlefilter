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
figure();
axis equal
grid = LoadMap('..\Data\Vorgabe_Rundgang.png');
show(grid);
hold on

%% define Var
orient = 0:2*pi/7:2*pi;%0:6*rho:60*rho;
iteration = 1;
num_subp = 4;
Streu3 = [0.5,0.5,pi/8];
Faktor = 0.95;
process = 1;    %%process 1 = calc, 0 = load data;
limes = 0.2;

%%
Init = Initialization(grid,orient);

%% Weighting 
% W_v(1:length(Init)) = (1/length(Init))';

%% Movement
move = [0, 0.5];  % delta x,y[m] & o[rad]: 0.5,0 & 0
Test_pose = [39.83, 10.47, -1.1];

n_0 = floor(length(Init)*Faktor);
n = n_0;
measure = 'kurve';   % Simualtion = simulate; Load = name {kurve,Rundgang}; Measurement = 'measure';
if ~strcmpi(measure,'simualte') && ~strcmpi(measure,'measure')
    max_i = length(dir(['../Data/' measure '/*.ply']));
else
    max_i = 14;
end
%%

while (iteration < max_i)
    tps(iteration, :) = Test_pose;
    [New_Pose,Test_pose,iteration] = Iteration_proc(Init,move,grid,n,num_subp,Test_pose,iteration,Streu3,process,limes,max_i,measure);   
    Init = New_Pose;
    n = max(floor(n*Faktor), 1000);
    % if (iteration == 10)
    %     move = [0,0,0];
    % end
    fprintf('TP(%.3f/%.3f) - Mean X: %.3f - Mean Y: %.3f\n',Test_pose(1),Test_pose(2), mean(Init(:,1)),mean(Init(:,2)));
    frames(iteration) = getframe(gcf);
end
delete(poolObj);

% figure();
% show(grid);
% hold on;
% scatter(tps(:, 1), tps(:, 2), 'xg');

writerObj = VideoWriter('./particleFilter.mp4', 'MPEG-4');
writerObj.FrameRate = 2; % sets the seconds per image

open(writerObj);
for i = 2 : length(frames)
    writeVideo(writerObj, frames(i));
end
close(writerObj);