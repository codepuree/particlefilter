%% Setup Matlab environment
close all;
clear all;
clc;

%% Load map
map = LoadMap('../../Data/Vorgabe_Rundgang.png');

%% Init particles
orient    = 0:2*pi/7:2*pi;
particles = Initialization(map, orient);

%% Do iterations
iteration     = 1;
max_iteration = 35;
while iteration < max_iteration
    % Get mesurement
    measurement = GetMeasurement();
    
    particles = Particlefilter(map, particles,measurement);
    disp(['Iteration ' num2str(iteration) ': ' num2str(length(particles))]);
    
    iteration = iteration + 1;
end