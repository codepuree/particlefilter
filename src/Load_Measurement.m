clear all
close all
clc

%% Load the data into the workspace
% or load corresponding ptcl for each iteration

name = 'Rundgang';
oldDir = cd;
newDir = cd(['../Data/' name]);
files = dir('*.ply');
countScans = 0;

for file = files'
    disp(file.name);
    ptCloudLoaded = pcdenoise(pcread(file.name));
%     ptCloudFlipped = FlipYZ(ptCloudLoad);
    temp =ptCloudLoaded.Location(:,2);
    ptCloudLoaded.Location(:,2) = ptCloudLoaded.Location(:,3);  %read only
    ptCloudLoaded.Location(:,3) = temp;
    figure('name', 'Flipped point cloud');
    pcshow(ptCloudLoaded, 'VerticalAxis', 'Y');
    title('Flipped point cloud');
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    countScans = countScans +1;
end

%%
cd(oldDir);