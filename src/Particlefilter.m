function [particles] = Particlefilter(varargin)
%% Parameter
% worker
% simulation : pose [x,y,o] + mov [o, s]
% weights: sigma & my
% Resampling: min Number Part 
%  noise [x,y,o]
%   factorPatricleReduction 
%LoadMap:   FilePath_map Resolution
%steps_orientation
%grid_x grid_y
%max_Iteration
% Get Measurement: SimFlag, Numb Bins, angleRange , min_y, max_y

%% Input Parser
p = inputParser;

% NumWorker name-value pair
defaultValnumWorkers = 4;
validatenumWorkers   = @(x) validateattributes(x, {'double','single'}, {'nonempty', 'positive'});
addParameter(p, 'numWorkers', defaultValnumWorkers, validatenumWorkers);

% Bins name-value pair
defaultValBins = 10;
validateBins   = @(x) validateattributes(x, {'double','single'}, {'nonempty', 'positive'});
addParameter(p, 'bins', defaultValBins, validateBins);

% min_y name-value pair
defaultValMin_y = -0.3;
validateMin_y   = @(x) validateattributes(x, {'double', 'single'}, {'nonempty'});
addParameter(p, 'min_y', defaultValMin_y, validateMin_y);

% max_y name-value pair
defaultValMax_y = 0.3;
validateMax_y   = @(x) validateattributes(x, {'double', 'single'}, {'nonempty'});
addParameter(p, 'max_y', defaultValMax_y, validateMax_y);

parse(p, varargin{:});

numWorkers = p.Results.numWorkers;
bins       = p.Results.bins;
min_y      = p.Results.min_y;
max_y      = p.Results.max_y;

pose = [22.473, 5.8, 1.9429];
movement = [0, 0.5];

% Normalize Weights
    sigma = 0.5;
    my = 0;
% Resampling
    minNumParticles = 1500;
    Streu = [0.5, 0.5, pi/64];

    factorParticleReduction = 1;
    
map_resolution = 20;
map_path = '../Data/Vorgabe_Rundgang.png';
max_iteration = 45;
orient    = 0:2*pi/31:2*pi;
gridX = 1;
gridY = 1;
SimFlag = 'Rundgang';
angleRange = 0.96;

%% Particle Filter

% Setup paralell pool
poolObj = gcp('nocreate');
if isempty(poolObj)
    poolObj = parpool('local', numWorkers);
end

%% Load map
map = LoadMap(map_path, 'resolution', map_resolution);

%% Init particles
particles = Initialization(map, orient, 'gridx', gridX, 'gridy', gridY);

Presentation(pose, particles, map);
title(['Initialisation: ' 10 'particles: ' num2str(length(particles))]);

%% Do iterations
iteration     = 1;
while iteration < max_iteration
    disp([10 'Iteration: ' num2str(iteration)]);
    tic
    %% Propagation
    if iteration > 1 && ~isempty(movement)
        particles = Propagation(map, particles, movement);
        particles = ValidateParticles(map, particles);
        
%         pose      = Propagation(map, pose, movement);
    end
    
    %% Get mesurement
%   [thetas, radius] = GetMeasurement('sim','pose',pose,'map',map, 'bins', 50, 'min_y', min_y,'max_y',max_y);    
    [thetas, radius] = GetMeasurement(SimFlag, 'iteration', iteration, 'bins', bins, 'anglerange', angleRange, 'min_y', min_y, 'max_y', max_y);
    
    if (isempty(thetas) && isempty(radius))
        disp('Done');
        verteilung(particles);
    end
    
    
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
        [particles, oldParticleIdx] = Resample(Number_of_Part,weights,particles,Streu);
        particles = ValidateParticles(map, particles);

    end
%     particles(1,:) = pose;

    %% Results    
    disp(['Number of particles: ' num2str(length(particles))]);
    
    Presentation(pose, particles, map, 'thetas', thetas, 'radius', radius, 'oldparticleidx',oldParticleIdx);
    title(['Iteration ' num2str(iteration) ': ' 10 'particles: ' num2str(length(particles))]);
    if (mod(iteration,44) == 0)
       disp(iteration); 
    end
    
    %% EOL
    iteration = iteration + 1;
    toc
end

end

