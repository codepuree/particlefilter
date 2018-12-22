function [bool] = SaveWeights(MeanDist, n_weights)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
bool = true;
figure();

subplot(1,3,1);
bins = 50;
histogram(MeanDist(~isnan(MeanDist)),bins);
xlabel('Bins = SummeDiffs²/AnzahlSummanden [m²]');ylabel('Anzahl');
title(['Sum MeanDist not nan: ' num2str(sum(MeanDist(~isnan(MeanDist))))]);
ylim([0 40]);

subplot(1,3,2);
histogram(n_weights,bins);
xlabel('Bins = nach e-Fktn ');ylabel('Anzahl');
title(['Sum MeanDist: ' num2str(sum(n_weights))]);
ylim([0 400]);

subplot(1,3,3);
m = sort(n_weights);
plot(m);
xlabel('Index');
ylabel('Gewicht');
% ylim([0 0.01]);

end

