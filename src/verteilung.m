function [] = verteilung(New_Pose,Test_pose)


figure()
title("Wahrscheinlichkeitsverteilung der Neuen Posen");
N = hist3([New_Pose(:,1),New_Pose(:,2)]);
N_pcolor = N';
N_pcolor(size(N_pcolor,1)+1,size(N_pcolor,2)+1) = 0;
xl = linspace(min(New_Pose(:,1)),max(New_Pose(:,1)),size(N_pcolor,2)); % Columns of N_pcolor
yl = linspace(min(New_Pose(:,2)),max(New_Pose(:,2)),size(N_pcolor,1)); % Rows of N_pcolor
h = pcolor(xl,yl,N_pcolor);
colormap('hot') % Change color scheme 
colorbar % Display colorbar
h.ZData = -max(N_pcolor(:))*ones(size(N_pcolor));
ax = gca;
ax.ZTick(ax.ZTick < 0) = [];
hold on
scatter(Test_pose(1),Test_pose(2),'*b');

figure()
hist3([New_Pose(:,1),New_Pose(:,2)],'Nbins',[10,10],'CDataMode','auto','FaceColor','interp');
xlabel('X-Achse');
ylabel('Y-Achse');
end

