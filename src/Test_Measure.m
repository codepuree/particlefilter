function [antw,theta_S,rho_S,result] = Test_Measure(Test_pose,grid,Init, process,limes)

result = true;
antw = NaN(0);
theta_S = NaN(0);
rho_S = NaN(0);

    
if process 
    [theta_S,rho_S,~,~] = SimulateKinect(grid, Test_pose, 'anglerange', deg2rad(180));    %,'maxrange',50

    if nnz(~isnan(rho_S)) / length(rho_S) < limes  - 0.05
            result = false;
    else 
        if nnz(~isnan(rho_S)) / length(rho_S) < limes
            limes = limes -0.05;
        end
        
        numWorkers = 4;

        out = cell(numWorkers, 1);
        parfor i = 1 : numWorkers
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

            out{i} = arrayfun(@(m) diffDist(grid, Init(m,:), theta_S, rho_S,limes), start:stop);
        end

        for i=1:length(out)
           antw = horzcat(antw,out{i}); 
        end
        antw = antw';
        pause(1);
        save('../Data/Test_MeasureV.mat','antw','theta_S','rho_S');
    end
else 
    load('../Data/Test_MeasureV.mat','antw','theta_S','rho_S');
end
end


function [dist] = diffDist(grid, pose, theta_S, rho_S,limes)
    [~, rhos,~,~] = SimulateKinect(grid, pose,'angles',theta_S);
    distV = (rho_S - rhos).^2;
    if (nnz(~isnan(distV))/length(distV)) > limes
        distVnn = distV(~isnan(distV));
        dist = sqrt(sum(distVnn) / length(distVnn));
    else
        dist = NaN;
    end
end
