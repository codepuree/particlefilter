function [antw,theta_S,rho_S] = Test_Measure(Test_pose,grid,Init, process)
if process 
[theta_S,rho_S,~,~] = SimulateKinect(grid, Test_pose);    %,'maxrange',50
spektrum = theta_S - Test_pose(3);

numWorkers = 4;
% poolObj = parpool('local', numWorkers);
out = cell(numWorkers, 1);
for i = 1 : numWorkers
    range = floor(size(Init,1) / numWorkers);
    start = (i - 1) * range;
    
    if start == 0
        start = 1;
        range = range -1;
    end
    stop = start + range-1;
    if i == numWorkers
        stop = size(Init,1);
    end
%     disp([num2str(start) " bis " num2str(stop) " bei " num2str(i) " über " num2str(range)]);    
    
    out{i} = arrayfun(@(m) diffDist(grid, Init(m,:), theta_S, rho_S,spektrum), start:stop);
end
% delete(poolObj);

antw = NaN(0);
for i=1:length(out)
   antw = horzcat(antw,out{i}); 
end
antw = antw';
pause(5);
save('../Data/Test_MeasureV.mat','antw','theta_S','rho_S');
else 
    load('../Data/Test_MeasureV.mat','antw','theta_S','rho_S');
end
end


function [dist] = diffDist(grid, pose, theta_S, rho_S,spektrum)
    [~, rhos,~,~] = SimulateKinect(grid, pose,'angles',spektrum);
    distV = (rho_S - rhos).^2;
    if (nnz(~isnan(distV))/length(distV)) > 0.6
        distVnn = distV(~isnan(distV));
        dist = sqrt(sum(distVnn) / length(distVnn));
    else
        dist = NaN;
    end
end
