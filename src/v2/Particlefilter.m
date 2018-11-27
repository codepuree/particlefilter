function [particles] = Particlefilter(grid, particles, mesurement, varargin)
%PARTICLEFILTER returns the good particles
%   Detailed explanation goes here

% p = inputParser();

% parse(p, varargin{:});


%% Rating 

numWorkers = 4;

out = cell(numWorkers, 1);
parfor i = 1 : numWorkers
    range = floor(size(particles,1) / numWorkers);
    start = (i - 1) * range;

    if start == 0
        start = 1;
        range = range -1;
    end
    stop = start + range-1;
    if i == numWorkers
        stop = size(particles,1);
    end

    limes = 0.2;
    out{i} = arrayfun(@(m) diffDist(grid, particles(m,:), mesurement, limes), start:stop);
%             out2{i} = arrayfun(@(m) Dist_L(grid,Init(m,:), theta_S, rho_S,limes), start:stop);
end

for i=1:length(out)
   MeanDist = horzcat(MeanDist,out{i}); 
end
MeanDist = MeanDist';

%% Normalize Weights:
sigma = 0.5;
mue = 0;
weights = 1/sqrt(2*pi*sigma^2)*exp(-1/2*(MeanDist-mue)^2/sigma^2);



end

function [dist] = diffDist(grid, pose, measurement, limes)
    theta_S = measurement(1);
    rho_S   = measurement(2);
    [~, rhos,~,~] = SimulateKinect(grid, pose,'angles',theta_S);
    distV = (rho_S - rhos).^2;
    distV = abs(rho_S - rhos);
%     distV ( isnan(rho_S) & isnan(rhos) ) = 1;
    if (nnz(~isnan(distV))/length(distV)) > limes
        distVnn = distV(~isnan(distV));
        dist = sqrt(sum(distVnn) / length(distVnn));
    else
        dist = NaN;
    end
%     dist = nansum(1-abs(rho_S-rhos)./5) / length(rhos);
end



function [dist] = Dist_L(grid, pose, measurement, limes)
    theta_S = measurement(1);
    rho_S   = measurement(2);
    [~, rhos,~,~] = SimulateKinect(grid, pose,'angles',theta_S);
    distance = abs(rho_S - rhos);
    distance ( isnan(rho_S) & isnan(rhos) ) = 1;
    if (nnz(~isnan(distance))/length(distance)) > limes
        distanceV = distance(~isnan(distance));
        dist = (sum(distanceV) / length(distanceV));
    else
        dist = NaN;
    end
end