function [particles, weights] = Particlefilter(map, particles, thetas, radius, pose, movement, varargin)
%STARTPARTICLEFILTER Summary of this function goes here
%   Detailed explanation goes here

%% Input parameters
p = inputParser;

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

% Iteration name-value pair
defaultValIteration = 10;
validateIteration   = @(x) validateattributes(x, {'double','single'}, {'nonempty', 'positive'});
addParameter(p, 'iteration', defaultValIteration, validateIteration);

% MinY name-value pair
defaultValMin_y = -0.3;
validateMin_y   = @(x) validateattributes(x, {'double', 'single'}, {'nonempty'});
addParameter(p, 'minY', defaultValMin_y, validateMin_y);

% MaxY name-value pair
defaultValMax_y = 0.3;
validateMax_y   = @(x) validateattributes(x, {'double', 'single'}, {'nonempty'});
addParameter(p, 'maxY', defaultValMax_y, validateMax_y);

% AngleRange name-value pair
defaultValAngleRange = 0.96;
validateAngleRange   = @(x) validateattributes(x, {'double', 'single'}, {'nonempty'});
addParameter(p, 'angleRange', defaultValAngleRange, validateAngleRange);

parse(p, varargin{:});

% Assign input parameters
sigma                   = p.Results.sigma;
my                      = p.Results.my;
minNumParticles         = p.Results.minNumParticles;
dispersion              = p.Results.dispersion;
factorParticleReduction = p.Results.factorParticleReduction;
bins                    = p.Results.bins;
iteration               = p.Results.iteration;
minY                    = p.Results.minY;
maxY                    = p.Results.maxY;
angleRange              = p.Results.angleRange;

% %% Propagation
% if iteration > 1 && ~isempty(movement)
%     particles = Propagation(particles, movement);
%     particles = ValidateParticles(map, particles);
% 
%     if ~isempty(pose)
%         pose = Propagation(pose, movement);
%     end
% end

if (isempty(thetas) && isempty(radius))
    disp('Done');
    verteilung(particles);
end


%% Rating 
MeanDist = Rating(map, particles, thetas, radius);

if nnz(isnan(MeanDist)) == length(MeanDist)
    %% toDo: Resample particles mit größerer Streuung
    warning(['Achtung alle Gewichte sind NaN, iteration = ' num2str(iteration)]);
else
    %% Normalize
    weights = NormalizeWeights(MeanDist,sigma,my);

    %% Resampling & Validation
    Number_of_Part = max(minNumParticles, floor(length(particles) * factorParticleReduction));
    particles      = Resample(Number_of_Part, weights, particles, dispersion);
    particles      = ValidateParticles(map, particles);

end

end

