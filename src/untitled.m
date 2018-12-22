close all


MeanDist = linspace(0, 2, 1000);
figure();
% histogram(MeanDist);
plot(MeanDist);

Sigma = 0.5;
mue = 0;
weights = 1/sqrt(2*pi*Sigma^2)*exp(-1/2*(MeanDist-mue).^2/Sigma^2);
figure();
subplot(1,2,1)
histogram(weights);
subplot(1,2,2)
plot(weights);