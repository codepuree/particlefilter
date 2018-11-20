clc
clear all
close all
%% Start measurement
iteration = 1;
name = 'kurve';
folder = ['../Data/' name '/'];
mkdir(folder);

% Get device
colorDevice = imaq.VideoDevice('kinect',1);
depthDevice = imaq.VideoDevice('kinect',2);

disp([datestr(now, 'yyyy-mm-dd HH:MM:SS:FFF') '> Starting measure point cloud mission ''' name '''...']);

while isempty(input(''))
    disp([datestr(now, 'yyyy-mm-dd HH:MM:SS:FFF') '> Taking measurement ' num2str(iteration) '...']);
    % Capture color & depth image 
    imgColor = step(colorDevice);
    imgDepth = step(depthDevice);
    
    % Point cloud 
    ptCloudAll = pcfromkinect(depthDevice, imgDepth, imgColor);
    
    % Save data
    temp = '';
    if (iteration < 10)
       temp = '0'; 
    end
    pcpath = [folder name '_' temp num2str(iteration) '.ply'];
    pcwrite(ptCloudAll, pcpath);
    
    pc = reshape(ptCloudAll.Location, 480*640, 3);
    pcnn = pc(~isnan(pc(:, 1)));
    disp([datestr(now, 'yyyy-mm-dd HH:MM:SS:FFF') '> The point cloud consists of ' num2str(length(pcnn)) ' points.']);
    
    % Display point cloud
    iname = ['Iteration: ' num2str(iteration)];
    figure();
    pcshow(ptCloudAll, 'VerticalAxis', 'Y', 'VerticalAxisDir', 'down');
    title([iname 10 'points: ' num2str(length(pcnn))]);
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    
    disp([datestr(now, 'yyyy-mm-dd HH:MM:SS:FFF') '> Finished writing point cloud number ' num2str(iteration) ' to ''' pcpath '''.']);
    iteration = iteration + 1;
end