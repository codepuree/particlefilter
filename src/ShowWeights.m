function [] = ShowWeights(AxesStat, MeanDist, n_weights)
%ShowWeights:   Plot statistical Information of weigths
    

% figure();

% subplot(1,3,1);
binsHisto = 50;
histogram(AxesStat.LeftAxes,MeanDist(~isnan(MeanDist)),binsHisto);
xlabel(AxesStat.LeftAxes,'Bins = SummeDiffs²/AnzahlSummanden [m²]');ylabel(AxesStat.LeftAxes,'Anzahl');
title(AxesStat.LeftAxes,['Sum MeanDist not nan: ' num2str(sum(MeanDist(~isnan(MeanDist))))]);
% ylim(AxesStat.LeftAxes,[0 40]);

% subplot(1,3,2);
histogram(AxesStat.MiddleAxes, n_weights,binsHisto);
xlabel(AxesStat.MiddleAxes,'Bins = nach e-Fktn ');ylabel(AxesStat.MiddleAxes,'Anzahl');
title(AxesStat.MiddleAxes,['Sum MeanDist: ' num2str(sum(n_weights))]);
% ylim(AxesStat.MiddleAxes,[0 400]);

% subplot(1,3,3);
m = sort(n_weights);
plot(AxesStat.RightAxes, m);
xlabel(AxesStat.RightAxes,'Index');
ylabel(AxesStat.RightAxes,'Gewicht');
title(AxesStat.RightAxes,['Sortierte Gewichte, Summe: ' num2str(sum(n_weights))]);
% ylim(AxesStat.RightAxes,[0 0.01]);

end

