function [bool] = Presentation(pose, particles, map)
%PRESENTATION Summary of this function goes here
%   Detailed explanation goes here
bool = true;
figure();
show(map);
hold on 
%% Classify the 
color = {'.g','.m','.c','.r','.y','.b','.w','.k'};
bin = (-pi/4) : 2*pi/4 : (7*pi/4);
for j = 1 : length(bin)-1
    class = particles((mod(particles(:,3),2*pi) >= bin(j) & mod(particles(:,3),2*pi) < bin(j+1)),:);
    scatter(class(:,1),class(:,2),color{j}, 'DisplayName', [num2str(rad2deg(bin(j)),'%.2f') '° - ' num2str(rad2deg(bin(j + 1)),'%.2f'), '°: ' num2str(length(class))]);
end
legend()

%% Plot pose with arrow
% scatter(pose(1),pose(2),'xb');
% [u,v] = pol2cart(pose(3), 5);
% hold on
% quiver(pose(1),pose(2), u, v)

end

