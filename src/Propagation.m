function [particles] = Propagation(particles, movement)
%PROPAGATION Propagates the given particles.
%   Detailed explanation goes here

[dx, dy] = pol2cart(particles(:,3) + movement(1), movement(2));
particles(:,1:2) = particles(:,1:2) + [dx dy];

end

