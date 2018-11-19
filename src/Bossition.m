close all;
clear all;
clc;

start = [29.5, 30];
stop  = [39.5, 10];
brea = 0;
[t, r] = cart2pol(stop(1) - start(1), stop(2) - start(2));
move = [0, 0.5];
grid = LoadMap('..\Data\Vorgabe_Update.png');
figure();
show(grid);
hold on;
scatter(stop(1), stop(2), 'or');
while start(2) > stop(2)
%     [res_1,res_2] = pol2cart(t + move(1),move(2))
%     start(1) = start(1) + res_1;
%     start(2) = start(2) +res_2;
    [x, y] = pol2cart(t + move(1),move(2));
    start(:) = start(:) + [x; y];
    scatter(start(1), start(2), 'og');
    brea = brea +1;
end
