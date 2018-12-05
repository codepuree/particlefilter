function [bool] = Presentation(pose, particles, map, varargin)
%PRESENTATION Summary of this function goes here
%   Detailed explanation goes here
p = inputParser();

defaultValThetas = zeros(0);
validateThetas   = @(x) validateattributes(x, {'single', 'double'}, {});
addOptional(p, 'thetas', defaultValThetas, validateThetas);

defaultValRadius = zeros(0);
validateRadius   = @(x) validateattributes(x, {'single', 'double'}, {});
addOptional(p, 'radius', defaultValRadius, validateRadius);

parse(p, varargin{:});

thetas = p.Results.thetas;
radius = p.Results.radius;

bool = true;
figure();
if ~isempty(thetas)
    subplot(1, 2, 1);
end
show(map);
hold on 
%% Classify the 
color = {'.g','.m','.c','.r','.y','.b','.w','.k'};
bin = (-pi/4) : 2*pi/4 : (7*pi/4);
for j = 1 : length(bin)-1
    class = particles((mod(particles(:,3),2*pi) >= bin(j) & mod(particles(:,3),2*pi) < bin(j+1)),:);
%     scatter(class(:,1),class(:,2),color{j}, 'DisplayName', [num2str(rad2deg(bin(j)),'%.2f') '° - ' num2str(rad2deg(bin(j + 1)),'%.2f'), '°: ' num2str(length(class))]);
    scatter(class(:,1),class(:,2),color{j});
end
% legend()

%% Plot pose with arrow
scatter(pose(1),pose(2),'xb');
[u,v] = pol2cart(pose(3), 5);
hold on
quiver(pose(1),pose(2), u, v)
hold off;

if ~isempty(thetas)
    subplot(1, 2, 2);
    polarplot(thetas(~isnan(radius)), radius(~isnan(radius)),'*');
end

end

