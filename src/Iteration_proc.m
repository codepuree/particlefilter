function [New_Pose,Test_pose,iteration] = Iteration_proc(Init,move,grid,n,num_subp,Test_pose,iteration,Streu,process,limes,max_i)
%%  Propagation
%   Simualtion of the Kinect
%   Rating
%   Resampling

tic

%% 4.Propagation
tpo = Test_pose;
if (iteration ~= 1)
%     Test_pose = Test_pose + move;
%     Init = Init + move;
%     [x1,y1]
%     Init(:,1) = Init(:,1)
    [dx, dy] = pol2cart(Init(:,3) + move(1), move(2));
    Init(:,1:2) = Init(:,1:2) + [dx dy];
    
    [dx, dy] = pol2cart(Test_pose(3) + move(1), move(2));
    Test_pose(1:2) = Test_pose(1:2) + [dx dy];
    
end

Pose_occ = getOccupancy(grid,Init(:,1:2));
Pose_IdxOcc   = Pose_occ < 0.5;
Init = Init(Pose_IdxOcc,:);
length(Init);
%% Rating
% Simulation-Measurement
% a) Korrelation Angle-histo
% b) Linear weighting distance-difference
% c) innovation (script Abmayr)
% d) Non linear weighting distance difference 


%   Simulation of the Kinect
[antw,theta_S,rho_S, isValid] = Test_Measure(Test_pose,grid,Init,process,limes); %process 1= calc;

if ~isValid
    warning(['Invalid measurement in iteration ' num2str(iteration) '.']);
    iteration = iteration +1; 
    New_Pose = Init;
    return
end
    
nn = ~isnan(antw);
numberOfNonZeros = nnz(nn);
%w = zeros(numberOfNonZeros,1);
w = 1./antw(nn);
sW = sum(w);
wN = w./sW;
INN = Init(nn,:);
figure(1);
% show(grid);
% hold on
% scatter3(INN(:,1),INN(:,2),wN);
% surf(INN(:,1),INN(:,2),wN);

% i_modu = mod(iteration,num_subp) ;
% if (i_modu == 1)
%     figure();
% elseif (i_modu == 0)
%     i_modu = 4;
% end
% subplot(2,2,i_modu);
show(grid);
hold on
% scatter(INN(:,1),INN(:,2), [],wN);


%% 6.Resampling
% n & Streu should be reduced while iterating n(1) >>>> n(10...)
New_Pose = Resample(n,wN,INN,Streu);
% scatter(Init(:,1),Init(:,2), '.g')
hold on
% Scatter_Hot(New_Pose(:,1),New_Pose(:,2));
scatter(New_Pose(:,1),New_Pose(:,2), '.b')
hold on
scatter(Test_pose(1),Test_pose(2), 'xr')
% hold on
% scatter(tpo(1),tpo(2), 'xy')
title(['Iteration: ',num2str(iteration) 10 'Particle: ' num2str(length(New_Pose))]);

%% Return Values
iteration = iteration +1;
if iteration == max_i
   verteilung(New_Pose,Test_pose);
end
% New_Pose
toc
end

