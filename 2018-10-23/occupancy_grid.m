close all
clear all
file = 'Vorgabe_update.png';
data_bin = imcomplement(imbinarize(rgb2gray(imread(file))));

[r,c] = size(data_bin);
%grid = robotics.BinaryOccupancyGrid(data_bin,10);
grid = robotics.OccupancyGrid(data_bin,10);
writeOccupancyGrid
show(grid)
hold on
maxrange = 5;
%%angles = [pi/4,-pi/4,0,-pi/8];
% robotPose = [37,27,-pi/8];
% intersectionPts = rayIntersection(grid,robotPose,angles,maxrange);
% %intersectionPts = robotics.OccupancyGrid.raycast.rayIntersection(grid,robotPose,angles,maxrange,0.7);
% plot(robotPose(1),robotPose(2),'ob') % Robot pose
% hold on
% for i = 1:numel(intersectionPts)
%     plot([robotPose(1),intersectionPts(i,1)],...
%         [robotPose(2),intersectionPts(i,2)],'-bx') % Plot intersecting rays
% end

%% define trajektorie
points = [41 27;42 26; 47 17; 47 15; 46 14; 42 12; 40 13; 39 14; 33 24;33 27; 34 28;41 27];
t = 0:1:length(points)-1;
l_t=numel(t);
angles = zeros(l_t,1);  %Richtungswinkel

%   Calculate Angle
for i=1:l_t
    if i == l_t
        angles(i)=angles(i-1) + 0.002;
    else
        angles(i) = atan2(points(i+1,2)-points(i,2), points(i+1,1)-points(i,1));
    end
end


intervall = 0:0.5:l_t;
xq = interp1(t,points(:,1),intervall,'line');
yq = interp1(t,points(:,2),intervall,'line');
aq = interp1(t,angles(:),intervall,'line');

angle = [0,pi/6,pi/3,pi/2,4*pi/6,5*pi/6,pi];
angle = angle + pi / 2;
aq =  aq + pi / 2;
for j=1:numel(intervall)
   figure(1);
   show(grid)
   hold on   
   robotPose = [xq(j),yq(j),aq(j)];
   intersectionPts =  rayIntersection(grid,robotPose,angle,maxrange);
   direction = rayIntersection(grid,robotPose,-pi/2,30);   %direction
   plot(robotPose(1),robotPose(2),'ob') % Robot pose
   hold on
   for i = 1:size(intersectionPts)
        plot([robotPose(1),intersectionPts(i,1)],...
            [robotPose(2),intersectionPts(i,2)],'-bx') % Plot intersecting rays
   end
   plot(xq, yq);
   plot([robotPose(1),direction(1,1)],...
            [robotPose(2),direction(1,2)],'-rx') % Plot direction
%     pause(1/2);
%     hold off
%     F(j) = getframe(gcf);
    drawnow
end

% %% Store as video
% 
% % Create the video writer with 1 fps
% writerObj = VideoWriter('./myVideo.avi');
% writerObj.FrameRate = 10; % sets the seconds per image
% 
% % Open the video writer
% open(writerObj);
% for i = 1 : length(F)
%     writeVideo(writerObj, F(i));
% end
% close(writerObj);
%%



