clear all
close all
clc

%% Load the data into the workspace
% or load corresponding ptcl for each iteration

name = 'Rundgang';
files = dir(['../Data/' name '/*.ply' ]);
countScans = 0;

for file = files'
    disp(file.name);
    ptCloudLoaded = pcdenoise(pcread(['../Data/' name '/' file.name]));
%     ptCloudFlipped = FlipYZ(ptCloudLoad);
%     temp =ptCloudLoaded.Location(:,2);
%     ptCloudLoaded.Location(:,2) = ptCloudLoaded.Location(:,3);  %read only
%     ptCloudLoaded.Location(:,3) = temp;
%     figure('name', 'Flipped point cloud');
%     pcshow(ptCloudLoaded, 'VerticalAxis', 'Y');
%     title('Flipped point cloud');
%     xlabel('X');
%     ylabel('Y');
%     zlabel('Z');
    [thetas, rhos] = Pcprepare(ptCloudLoaded, -0.3, 0.3, 20,'','');
    thetas = thetas - pi/2;
    figure(1);
    subplot(1, 3, 1);
    pcshow(ptCloudLoaded, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down');
    title(file.name);
    subplot(1, 3, 2);
    ptCloudFlattend = FlattenPointCloud(GetCrossProfile(ptCloudLoaded, -0.3, 0.3));
    scatter(ptCloudFlattend.Location(:, 1), ptCloudFlattend.Location(:, 3), '.');
    [winkel,Radius] = cart2pol(ptCloudFlattend.Location(:, 1), ptCloudFlattend.Location(:, 3));
    half_range = 28;
    bin = deg2rad(-half_range:half_range/30:half_range)+pi/2;
    for i = 1:length(Radius)-1
       subplot(1,3,3);
       output = (Radius(winkel(:) > bin(i) & winkel(:)< bin(i+1) ))
%        histogram (Radius(winkel(:) > bin(i) & winkel(:)< bin(i+1) ));
    end
%     daspect([1, 1, 1])
%     subplot(1, 3, 3);
%     polarplot(thetas, rhos, 'xb');
%     countScans = countScans +1;
    pause(0.25);
end

%%
% cd(oldDir);