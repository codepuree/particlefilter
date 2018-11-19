clc
clear all
close all
%% Start measurement
iteration = 1;
name = 'Rundgang';
folder = ['../Data/' name '/'];
mkdir(folder);

% Get device
colorDevice = imaq.VideoDevice('kinect',1);
depthDevice = imaq.VideoDevice('kinect',2);



while isempty(input(''))
    % Capture color & depth image 
    imgColor = step(colorDevice);
    imgDepth = step(depthDevice);
    
    % Point cloud 
    ptCloudAll = pcfromkinect(depthDevice, imgDepth, imgColor);
    figure('name', 'Unmodified point cloud');
    pcshow(ptCloudAll, 'VerticalAxis', 'Y', 'VerticalAxisDir', 'down');
    title('Unmodified point cloud');
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    
    % Save data
    temp = '';
    if (iteration < 10)
       temp = '0'; 
    end
    pcwrite(ptCloudAll, [folder name '_' temp num2str(iteration) '.ply']);
    
    disp("take measurement");
    iteration = iteration + 1;
end