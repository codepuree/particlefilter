function [antw,theta_S,rho_S,result] = Test_Measure(Test_pose,grid,Init, process,limes,measure, iteration)

result  = true;
antw    = NaN(0);
antw2   = NaN(0);
theta_S = NaN(0);
rho_S   = NaN(0);

    
if process
    if strcmpi(measure, 'simulate')
        [theta_S,rho_S,~,~] = SimulateKinect(grid, Test_pose, 'anglerange', deg2rad(180));    %,'maxrange',50
    elseif strcmpi(measure, 'measure')
        warning('Measure: Not implemented!');
    else
        iter = '';
        if iteration < 10
            iter = '0';
        end
       path = ['../Data/' measure '/' measure '_' iter num2str(iteration) '.ply'];
       if exist(path, 'file')
           ptcl = pcread(path);
           semi_range = 27.125 * pi/180;
           [theta_S,rho_S] = Pcprepare(ptcl, -0.3,0.3,20, pi/2-semi_range,pi/2+semi_range);  % minY, maxY, numEle;
           theta_S = theta_S - pi / 2;
           disp(['Number of NaN Values: ' num2str(nnz(isnan(rho_S))) ' out of ' num2str(length(rho_S)) ' = ' num2str(nnz(isnan(rho_S))/length(rho_S))]);
       else
           error(['Unable to load the file ''' path '''!']);
       end
    end

    if nnz(~isnan(rho_S)) / length(rho_S) < limes  - 0.05
            result = false;
    else 
        if nnz(~isnan(rho_S)) / length(rho_S) < limes
            warning('Limes needs to be reduced');
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
%             out2{i} = arrayfun(@(m) Dist_L(grid,Init(m,:), theta_S, rho_S,limes), start:stop);
        end

        for i=1:length(out)
           antw = horzcat(antw,out{i}); 
        end
        
%         for j = 1:length(out2)
%             antw2 = horzcat(antw2,out2{j});
%         end
        antw = antw';
%         antw= antw2';
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
    distV = abs(rho_S - rhos);
%     distV ( isnan(rho_S) & isnan(rhos) ) = 1;
    if (nnz(~isnan(distV))/length(distV)) > limes
        distVnn = distV(~isnan(distV));
        dist = sqrt(sum(distVnn) / length(distVnn));
    else
        dist = NaN;
    end
%     dist = nansum(1-abs(rho_S-rhos)./5) / length(rhos);
end

function [dist] = Dist_L(grid, pose, theta_S,rho_S,limes)
    [~, rhos,~,~] = SimulateKinect(grid, pose,'angles',theta_S);
    distance = abs(rho_S - rhos);
    distance ( isnan(rho_S) & isnan(rhos) ) = 1;
    if (nnz(~isnan(distance))/length(distance)) > limes
        distanceV = distance(~isnan(distance));
        dist = (sum(distanceV) / length(distanceV));
    else
        dist = NaN;
    end
end
