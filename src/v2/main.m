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
pose = [22.473, 5.8, 1.9429];
movement = [0, 0.5];

% Normalize Weights
    sigma = 0.5;
    my = 0;
% Resampling
    minNumParticles = 1000;
    Streu = [0.5, 0.5, pi/16];

    factorParticleReduction = 0.95;

%% Load map
map = LoadMap('../../Data/Vorgabe_Rundgang.png', 'resolution', 20);

%% Init particles
orient    = 0:2*pi/15:2*pi;
particles = Initialization(map, orient, 'gridx', 1, 'gridy', 1);

Presentation(pose, particles, map);
title(['Initialisation: ' 10 'particles: ' num2str(length(particles))]);

%% Do iterations
iteration     = 1;
max_iteration = 30;
while iteration < max_iteration
    disp([10 'Iteration: ' num2str(iteration)]);
    tic
    %% Propagation
    if iteration > 1 && ~isempty(movement)
        particles = Propagation(map, particles, movement);
        particles = ValidateParticles(map, particles);
        
        pose      = Propagation(map, pose, movement);
    end
%     particles(1,:) = pose;
    
    %% Get mesurement
%   [thetas, radius] = GetMeasurement('sim','pose',pose,'map',map, 'bins', 50);
    [thetas, radius] = GetMeasurement('Rundgang', 'iteration', iteration);
    
    %% Rating 
    MeanDist = Rating(map, particles,thetas,radius);
    
    if nnz(isnan(MeanDist)) == length(MeanDist)
        %% toDo: Resample particles mit größerer Streuung
        warning(['Achtung alle Gewichte sind NaN, iteration = ' num2str(iteration)]);
    else
        %% Normalize
        weights =  NormalizeWeights(MeanDist,sigma,my);

        %% Resampling & Validation
        Number_of_Part = max(minNumParticles, floor(length(particles) * factorParticleReduction));
        particles = Resample(Number_of_Part,weights,particles,Streu);
        particles = ValidateParticles(map, particles);

    end
%     particles(1,:) = pose;
    %% Results    
    disp(['Number of particles: ' num2str(length(particles))]);
    
    Presentation(pose, particles, map, 'thetas', thetas, 'radius', radius);
    title(['Iteration ' num2str(iteration) ': ' 10 'particles: ' num2str(length(particles))]);
    if (mod(iteration,20) == 0)
       disp(iteration); 
    end
    
    %% EOL
    iteration = iteration + 1;
    toc
end