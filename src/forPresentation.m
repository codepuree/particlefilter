%% Setup matlab environment
close all;
clear all;
clc;

% Get movement figure
grid = LoadMap('..\Data\Vorgabe_Update.png');
orient = 0:pi/18:2*pi;
move = [-0.5,-0.10,0];  % delta x,y[m] & o[rad]: 0.5,0 & 0
Test_pose = [29.39,24.104,0.953];

poses = Initialization(grid,orient);

iteration = 1;
while (iteration < 18)
    figure(1);
    show(grid);
    hold on;
    scatter(poses(:, 1), poses(:, 2), '.blue');
%     robot = '\\\_O\_/';
%     title([robot ' movement']);
%     text(Test_pose(1), Test_pose(2), robot, 'Color', 'blue', 'FontSize', 8);
%     Test_pose = Test_pose + move;
    poses = poses + move;
    raster = getOccupancy(grid, poses(:, 1:2));
    rIdxOcc   = raster < 0.5;
    poses = poses(rIdxOcc, :);
    iteration = iteration + 1;
    title('Particle propagation');
    frames(iteration) = getframe(gcf);
end

writerObj = VideoWriter('./particlePropagation.mp4', 'MPEG-4');
writerObj.FrameRate = 2; % sets the seconds per image

open(writerObj);
for i = 2 : length(frames)
    writeVideo(writerObj, frames(i));
end
close(writerObj);