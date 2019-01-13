function [bool] = Presentation(AxesParticle,pose, particles, map, varargin)
%PRESENTATION Summary of this function goes here
%   Detailed explanation goes here
p = inputParser();

defaultValThetas = zeros(0);
validateThetas   = @(x) validateattributes(x, {'single', 'double'}, {});
addOptional(p, 'thetas', defaultValThetas, validateThetas);

defaultValRadius = zeros(0);
validateRadius   = @(x) validateattributes(x, {'single', 'double'}, {});
addOptional(p, 'radius', defaultValRadius, validateRadius);

defaultValRadius = zeros(0);
validateRadius   = @(x) validateattributes(x, {'logical'}, {});
addOptional(p, 'oldparticleidx', defaultValRadius, validateRadius);

parse(p, varargin{:});

thetas = p.Results.thetas;
radius = p.Results.radius;
oldParticleIdx = p.Results.oldparticleidx;

bool = true;
figure();
if ~isempty(thetas)
    subplot(1, 2, 1);
end
show(map,'Parent',AxesParticle.LeftAxes);
% show(map);
hold (AxesParticle.LeftAxes, 'on')
%% Classify the 
color = {'.g','.m','.c','.r','.y','.b','.w','.k'};
bin = (-pi/4) : 2*pi/4 : (7*pi/4);
for j = 1 : length(bin)-1
    class = particles((mod(particles(:,3),2*pi) >= bin(j) & mod(particles(:,3),2*pi) < bin(j+1)),:);
    scatter(AxesParticle.LeftAxes,class(:,1),class(:,2),color{j}, 'DisplayName', [num2str(rad2deg(bin(j)),'%.2f') '° - ' num2str(rad2deg(bin(j + 1)),'%.2f'), '°: ' num2str(length(class))]);
%     scatter(class(:,1),class(:,2),color{j}, 'DisplayName', [num2str(rad2deg(bin(j)),'%.2f') '° - ' num2str(rad2deg(bin(j + 1)),'%.2f'), '°: ' num2str(length(class))]);
    %     scatter(class(:,1),class(:,2),color{j});
end
legend(AxesParticle.LeftAxes,'Location','southwest')

%% Plot pose with arrow
scatter(AxesParticle.LeftAxes,pose(1),pose(2),'xb');
[u,v] = pol2cart(pose(3), 5);
hold (AxesParticle.LeftAxes, 'on')
quiver(AxesParticle.LeftAxes,pose(1),pose(2), u, v)
if ~isempty(oldParticleIdx)
    scatter(AxesParticle.LeftAxes,particles(oldParticleIdx, 1), particles(oldParticleIdx, 2), 'Or');
end
hold (AxesParticle.LeftAxes, 'off')

%% AxesParticle.RightAxes
if ~isempty(thetas)
    subplot(1, 2, 2);
    polarplot(thetas(~isnan(radius)), radius(~isnan(radius)),'*');
end

end

