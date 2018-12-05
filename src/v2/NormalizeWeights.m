function [n_weights] = NormalizeWeights(values, sigma, my)
%%

weights = 1/sqrt(2*pi*sigma^2)*exp(-1/2*(values-my).^2/sigma^2);
weights(isnan(weights)) = 0;
n_weights = weights./sum(weights) * 10000;


disp(['Summe der normalisierten Gewichte: ' num2str(sum(n_weights)) ';' 10 'Anzahl an NaN: ' num2str(numel(weights(isnan(weights))))  ]);
SaveWeights(values, n_weights);

end