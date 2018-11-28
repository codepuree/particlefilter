%% Setup Matlab environment
close all;
clear all;
clc;

% Setup paralell pool
poolObj = gcp('nocreate');
if isempty(poolObj)
    numWorkers = 4;
    poolObj = parpool('local', numWorkers);
end

%% Define Parameters
pose = [22.3764, 5.3612, -1.1+pi];
movement = [0, 0.5];

%% Load map
map = LoadMap('../../Data/Vorgabe_Rundgang.png','resolution',100);

%% Init particles
orient    = 0:2*pi/7:2*pi;
particles = Initialization(map, orient);

show(map);
hold on;
scatter(particles(:,1),particles(:,2), '*r');
hold off;

%% Do iterations
iteration     = 1;
max_iteration = 35;
while iteration < max_iteration
    % Get mesurement
    measurement = GetMeasurement('sim','pose',pose,'map',map, 'bins', 20);
    if iteration > 1 && ~isempty(movement)
        particles = Propagation(map, particles, movement);
        pose      = Propagation(map, pose,      movement);
    end
    particles = Particlefilter(map, particles,measurement);
    disp(['Iteration ' num2str(iteration) ': ' num2str(length(particles))]);
    figure()
    show(map);
    hold on;
    axis equal
    scatter(particles(:,1),particles(:,2),'.b');
    scatter(pose(1),pose(2),'xr');
    [u, v] = pol2cart(pose(3), 4);
    quiver(pose(1), pose(2), u, v);
    
    iteration = iteration + 1;
end