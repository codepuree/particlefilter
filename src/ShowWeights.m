function [] = ShowWeights(MeanDist, n_weights, varargin)
%ShowWeights:   Plot statistical Information of weigths
p = inputParser();

defaultValParent = zeros(0);
validateParent   = @(x) validateattributes(x, {'matlab.ui.Figure', 'uifigure', 'matlab.ui.container.Panel'}, {});
addOptional(p, 'Parent', defaultValParent, validateParent);

parse(p, varargin{:});

Parent = p.Results.Parent;

if isempty(Parent)
    Parent = figure();
end

ax1 = subplot(1, 3, 1, axes(Parent));
binsHisto = 50;
histogram(ax1,MeanDist(~isnan(MeanDist)),binsHisto);
xlabel(ax1,'Bins = SummeDiffs²/AnzahlSummanden [m²]');ylabel(ax1,'Anzahl');
title(ax1,['Sum MeanDist not nan: ' num2str(sum(MeanDist(~isnan(MeanDist))))]);
% ylim(ax1,[0 40]);

ax2 = subplot(1, 3, 2, axes(Parent));
histogram(ax2, n_weights,binsHisto);
xlabel(ax2,'Bins = nach e-Fktn ');ylabel(ax2,'Anzahl');
title(ax2,['Sum MeanDist: ' num2str(sum(n_weights))]);
% ylim(ax2,[0 400]);

ax3 = subplot(1, 3, 3, axes(Parent));
m = sort(n_weights);
plot(ax3, m);
xlabel(ax3,'Index');
ylabel(ax3,'Gewicht');
title(ax3,['Sortierte Gewichte, Summe: ' num2str(sum(n_weights))]);
% ylim(ax3,[0 0.01]);

end

