function [] = verteilung(particles)


figure()
title("Wahrscheinlichkeitsverteilung der Neuen Posen");
N = hist3([particles(:,1),particles(:,2)]);
N_pcolor = N';
N_pcolor(size(N_pcolor,1)+1,size(N_pcolor,2)+1) = 0;
xl = linspace(min(particles(:,1)),max(particles(:,1)),size(N_pcolor,2)); % Columns of N_pcolor
yl = linspace(min(particles(:,2)),max(particles(:,2)),size(N_pcolor,1)); % Rows of N_pcolor
h = pcolor(xl,yl,N_pcolor);
colormap('hot') % Change color scheme 
colorbar % Display colorbar
h.ZData = -max(N_pcolor(:))*ones(size(N_pcolor));
ax = gca;
ax.ZTick(ax.ZTick < 0) = [];
hold on
% scatter(Test_pose(1),Test_pose(2),'*b');

figure()
hist3([particles(:,1),particles(:,2)],'Nbins',[100,100],'CDataMode','auto','FaceColor','interp');
xlabel('X-Achse');
ylabel('Y-Achse');
end

