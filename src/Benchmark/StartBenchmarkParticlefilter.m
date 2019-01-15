function [particles] = StartBenchmarkParticlefilter(varargin)

%% Input Parser
p = inputParser;

% AxesStats name-value pair
defaultValAxesStats = struct();
validateAxesStats   = @(x) validateattributes(x, {'struct'}, {'nonempty'});
addParameter(p, 'AxesStats', defaultValAxesStats, validateAxesStats);

% AxesParticlet name-value pair
defaultValAxesParticle = zeros(0);
validateAxesParticle   = @(x) validateattributes(x, {'uifigure', 'figure', 'matlab.ui.container.Panel'}, {'nonempty'});
addParameter(p, 'AxesParticle', defaultValAxesParticle, validateAxesParticle);

% NumWorker name-value pair
defaultValnumWorkers = 4;
validatenumWorkers   = @(x) validateattributes(x, {'double','single'}, {'nonempty', 'positive'});
addParameter(p, 'numWorkers', defaultValnumWorkers, validatenumWorkers);

% Pose name-value pair
defaultValPose = [22.473, 5.8, 1.9429]; % maybe empty, to hide if not used
validatePose   = @(x) validateattributes(x, {'double'}, {'nonempty'});
addParameter(p, 'pose', defaultValPose, validatePose);

% Movement name-value pair
defaultValMovement = [0, 0.5];
validateMovement   = @(x) validateattributes(x, {'double','single'}, {'nonempty'});
addParameter(p, 'movement', defaultValMovement, validateMovement);

% Sigma name-value pair
defaultValSigma = 0.5;
validateSigma   = @(x) validateattributes(x, {'double','single'}, {'nonempty', 'positive'});
addParameter(p, 'sigma', defaultValSigma, validateSigma);

% Sigma name-value pair
defaultValMy = 0;
validateMy   = @(x) validateattributes(x, {'double','single'}, {'nonempty'});
addParameter(p, 'my', defaultValMy, validateMy);

% MinNumParticles name-value pair
defaultValMinNumParticles = 1500;
validateMinNumParticles   = @(x) validateattributes(x, {'double','single'}, {'nonempty', 'positive'});
addParameter(p, 'minNumParticles', defaultValMinNumParticles, validateMinNumParticles);

% Dispersion name-value pair
defaultValDispersion = [0.5, 0.5, pi/64];
validateDispersion   = @(x) validateattributes(x, {'double','single'}, {'nonempty'});
addParameter(p, 'dispersion', defaultValDispersion, validateDispersion);

% FactorParticleReduction name-value pair
defaultValFactorParticleReduction = 0.95;
validateFactorParticleReduction   = @(x) validateattributes(x, {'double','single'}, {'nonempty', 'positive'});
addParameter(p, 'factorParticleReduction', defaultValFactorParticleReduction, validateFactorParticleReduction);

% Bins name-value pair
defaultValBins = 10;
validateBins   = @(x) validateattributes(x, {'double','single'}, {'nonempty', 'positive'});
addParameter(p, 'bins', defaultValBins, validateBins);

% MinY name-value pair
defaultValMin_y = -0.3;
validateMin_y   = @(x) validateattributes(x, {'double', 'single'}, {'nonempty'});
addParameter(p, 'minY', defaultValMin_y, validateMin_y);

% MaxY name-value pair
defaultValMax_y = 0.3;
validateMax_y   = @(x) validateattributes(x, {'double', 'single'}, {'nonempty'});
addParameter(p, 'maxY', defaultValMax_y, validateMax_y);

% MapResolution name-value pair
defaultValMapResolution = 20;
validateMapResolution   = @(x) validateattributes(x, {'double', 'single'}, {'nonempty'});
addParameter(p, 'mapResolution', defaultValMapResolution, validateMapResolution);

% MapPath name-value pair
defaultValMapPath = '../Data/Vorgabe.png';
validateMapPath   = @(x) validateattributes(x, {'char'}, {'nonempty'});
addParameter(p, 'mapPath', defaultValMapPath, validateMapPath);

% GridX name-value pair
defaultValGridX = 1;
validateGridX   = @(x) validateattributes(x, {'double', 'single'}, {'nonempty'});
addParameter(p, 'gridX', defaultValGridX, validateGridX);

% GridY name-value pair
defaultValGridY = 1;
validateGridY   = @(x) validateattributes(x, {'double', 'single'}, {'nonempty'});
addParameter(p, 'gridY', defaultValGridY, validateGridY);

% MaxIteration name-value pair
defaultValMaxIteration = 45;
validateMaxIteration   = @(x) validateattributes(x, {'double', 'single'}, {'nonempty'});
addParameter(p, 'maxIteration', defaultValMaxIteration, validateMaxIteration);

% AngleRange name-value pair
defaultValAngleRange = 0.96;
validateAngleRange   = @(x) validateattributes(x, {'double', 'single'}, {'nonempty'});
addParameter(p, 'angleRange', defaultValAngleRange, validateAngleRange);

% SimFlag name-value pair
defaultValSimFlag = 'sim';
validateSimFlag   = @(x) validateattributes(x, {'char'}, {'nonempty'});
addParameter(p, 'simFlag', defaultValSimFlag, validateSimFlag);

% rootfolder name-value pair
defaultValrootfolder = '../Data';
validaterootfolder   = @(x) validateattributes(x, {'char'}, {});
addParameter(p, 'dataRootFolder', defaultValrootfolder, validaterootfolder);

% StepsOrientation name-value pair
defaultValStepsOrientation = 31;
validateStepsOrientation   = @(x) validateattributes(x, {'double', 'single'}, {'nonempty'});
addParameter(p, 'stepsOrientation', defaultValStepsOrientation, validateStepsOrientation);

parse(p, varargin{:});

% Asign parameters
% AxesStats               = p.Results.AxesStats;
% AxesParticle            = p.Results.AxesParticle;
% numWorkers              = p.Results.numWorkers;
pose                    = p.Results.pose;
movement                = p.Results.movement;
sigma                   = p.Results.sigma;
my                      = p.Results.my;
minNumParticles         = p.Results.minNumParticles;
bins                    = p.Results.bins;
minY                    = p.Results.minY;
maxY                    = p.Results.maxY;
dispersion              = p.Results.dispersion;
factorParticleReduction = p.Results.factorParticleReduction;
mapResolution           = p.Results.mapResolution;
mapPath                 = p.Results.mapPath;
gridX                   = p.Results.gridX;
gridY                   = p.Results.gridY;
maxIteration            = p.Results.maxIteration;
angleRange              = p.Results.angleRange;
simFlag                 = p.Results.simFlag;
stepsOrientation        = p.Results.stepsOrientation;
rootfolder              = p.Results.dataRootFolder;


%% Load map
map = LoadMap(mapPath, 'resolution', mapResolution);
%% Init particles
orient    = 0:2*pi/stepsOrientation:2*pi;
particles = Initialization(map, orient, 'gridx', gridX, 'gridy', gridY);

%% Do iterations
iteration     = 1;
while iteration < maxIteration
    disp([10 'Iteration: ' num2str(iteration)]);
    %% Propagation
    if iteration > 1 && ~isempty(movement)
        particles = Propagation(particles, movement);
        particles = ValidateParticles(map, particles);
        
        if ~isempty(pose)
            pose = Propagation(pose, movement);
        end
    end
    
    %% Get mesurement
    [thetas, radius] = GetMeasurement(simFlag, ...
        'iteration',  iteration, ...
        'pose',       pose, ...
        'map',        map, ...
        'bins',       bins, ...
        'anglerange', angleRange, ...
        'min_y',      minY, ...
        'max_y',      maxY, ...
        'rootfolder', rootfolder ...
    );    
    %% ToDo: ResampleUpdate
    [particles, particleDist, normalizedWeights] = Particlefilter(map, particles, thetas, radius,...
        'sigma',                   sigma, ...
        'my',                      my, ...
        'minNumParticles',         minNumParticles, ...
        'dispersion',              dispersion, ...
        'factorParticleReduction', factorParticleReduction ...
    );
    iteration = iteration + 1;
end
end