function [thetasSampled,rhosSampled] = Pcprepare(ptcl, minY, maxY, numElements, thetaMin, thetaMax)
%PCPREPARE Summary of this function goes here
%   Detailed explanation goes here

ptclCross = pcdenoise(GetCrossProfile(ptcl, minY, maxY));
ptclFlattend = FlattenPointCloud(ptclCross);

[thetas, rhos] = cart2pol(ptclFlattend.Location(:, 1), ptclFlattend.Location(:, 3)); % (:, 1) = x; (:, 3) = y

if length(thetas) > numElements
    if isempty(thetaMin)
        thetaMin = min(thetas);
    end
    
    if isempty(thetaMax)
        thetaMax = max(thetas);
    end

    % rhoMin    = min(rhos);
    % rhoMax    = max(rhos);
    % rhoMean   = mean(rhos);
    % rhoMedian = median(rhos);

    thetaDiff = thetaMax - thetaMin;
%     rhoDiff   = rhoMax - rhoMin;
%     disp(['thetaMin: ' num2str(thetaMin) '(' num2str(rad2deg(thetaMin)) ')']);
%     disp(['thetaMax: ' num2str(thetaMax) '(' num2str(rad2deg(thetaMax)) ')']);

    thetasSampled = double(linspace(thetaMin, thetaMax, numElements-1)');
    rhosSampled   = double(arrayfun(@(x) nanmedian(rhos(thetas > x & thetas < (x + thetaDiff / numElements))), thetasSampled));
else
    warning(['length(thetas) > numElements is FALSE; thetas.length: ' length(thetas) ' numElements: ' numElements]);
    thetasSampled = double(thetas);
    rhosSampled   = double(rhos);
end

end

