function [particles, MeanDist, weights] = Particlefilter(map, particles, thetas, radius,varargin)
%Particlefilter:
%   Calc Weights
%   Normalize Weights
%   Resample

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

parse(p, varargin{:});

%% Assign input parameters
sigma                   = p.Results.sigma;
my                      = p.Results.my;
minNumParticles         = p.Results.minNumParticles;
dispersion              = p.Results.dispersion;
factorParticleReduction = p.Results.factorParticleReduction;

if (isempty(thetas) && isempty(radius))
    disp('Done');
    verteilung(particles);
end


%% Rating 
MeanDist = Rating(map, particles, thetas, radius);

if nnz(isnan(MeanDist)) == length(MeanDist)
    warning('Achtung alle Gewichte sind NaN.');
else
    %% Normalize
    weights = NormalizeWeights(MeanDist,sigma,my);

    %% Resampling & Validation
    Number_of_Part = max(minNumParticles, floor(length(particles) * factorParticleReduction));
    particles      = Resample(Number_of_Part, weights, particles, dispersion);
    particles      = ValidateParticles(map, particles);

end

end

