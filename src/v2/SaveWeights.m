function [bool] = SaveWeights(MeanDist, n_weights)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
bool = true;
figure();

subplot(1,3,1);
bins = 50;
histogram(MeanDist(~isnan(MeanDist)),bins);
xlabel('Bins = SummeDiffs�/AnzahlSummanden [m�]');ylabel('Anzahl');
title(['Sum MeanDist not nan: ' sum(MeanDist(~isnan(MeanDist)))]);

subplot(1,3,2);
histogram(n_weights,bins);
xlabel('Bins = nach e-Fktn ');ylabel('Anzahl');
title(['Sum MeanDist: ' sum(n_weights)]);

subplot(1,3,3);
m = sort(MeanDist);
plot(m);
xlabel('Index');
ylabel('Gewicht');

end

