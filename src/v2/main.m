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
pose = [20.473, 8.36, -1.1+pi];
movement = [0, 0.5];

%% Load map
map = LoadMap('../../Data/Vorgabe_RundgangX50.png');

%% Init particles
orient    = 0:2*pi/7:2*pi;
particles = Initialization(map, orient, 'gridx', 1, 'gridy', 1);

Presentation(pose, particles, map);
title(['Initialisation: ' 10 'particles: ' num2str(length(particles))]);

%% Do iterations
iteration     = 1;
max_iteration = 35;
while iteration < max_iteration
    % Get mesurement
    tic
    
%     [thetas, radius] = GetMeasurement('sim','pose',pose,'map',map, 'bins', 10);
    [thetas, radius] = GetMeasurement('Rundgang', 'iteration', iteration);
    
    if iteration > 1 && ~isempty(movement)
%         particles = Propagation(map, particles, movement);
%         particles = ValidateParticles(map, particles);
        
        pose      = Propagation(map, pose, movement);
    end
        
    particles = Particlefilter(map, particles,thetas,radius);
    
    particles = ValidateParticles(map, particles);
    
    disp(['Iteration ' num2str(iteration) ': ' num2str(length(particles))]);
    
    Presentation(pose, particles, map);
    title(['Iteration ' num2str(iteration) ': ' 10 'particles: ' num2str(length(particles))]);
    
    iteration = iteration + 1;
    toc
end