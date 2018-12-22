%%
close all 
clc
figure()
% axis equal
axis off
hold on
scatter(Vorgabe(:,1),Vorgabe(:,2),'.k');
fig_name = 'Vorgabe2.png' ;
print('-bestfit','Title','-dpng');
savefigure(fig_name);

Bin = imbinarize(rgb2gray(imread(image)));