function [dist] = diffDist(grid, pose, thetas, radius, limes)
    theta_S = thetas;
    rho_S   = radius;
    [~, rhos,~,~] = SimulateKinect(grid, pose,'angles',theta_S);
    distV = (rho_S - rhos).^2;
%     distV = abs(rho_S - rhos);
%     distV ( isnan(rho_S) & isnan(rhos) ) = 1;
    if (nnz(~isnan(distV))/length(distV)) > limes
        distVnn = distV(~isnan(distV));
        dist = sqrt(sum(distVnn) / length(distVnn));
    else
        dist = NaN;
    end
%     dist = nansum(1-abs(rho_S-rhos)./5) / length(rhos);
end