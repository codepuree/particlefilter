function [particles] = ValidateParticles(map, particles)
%VALIDATEPARTICLES Summary of this function goes here
%   Detailed explanation goes here
% Filter paricles inside world coordinates
piw = particles(:, 1) > map.XWorldLimits(1) & particles(:, 1) < map.XWorldLimits(2) & particles(:, 2) > map.XWorldLimits(1) & particles(:, 2) < map.YWorldLimits(2);

if sum(~piw) > 0
    warning(['There are ' num2str(sum(~piw)) ' particles not inside the world coordinates!']);
end

particles = particles(piw, :);

particles = particles(getOccupancy(map,particles(:,1:2)) < 0.5,:);

end

