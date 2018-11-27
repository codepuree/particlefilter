function [Init] = Initialization(grid,orient)
%% Generate raster
[X, Y] = meshgrid(grid.XWorldLimits(1):0.5:grid.XWorldLimits(2),grid.YWorldLimits(1):0.5:grid.YWorldLimits(2));
X      = reshape(X,numel(X),1);
Y      = reshape(Y,numel(Y),1);

mesh   = [X,Y];
tic1 = tic;
raster = getOccupancy(grid, mesh);
toc(tic1)
rIdxOcc   = raster < 0.5;
free_raster       = mesh(rIdxOcc, :);

[r_f,~]=size(free_raster);

%%  1.Initalisierung Matrix ( x, y, o)

Init = zeros(r_f,length(orient),3);
for i = 1:r_f
    for j = 1: length(orient)
       Init(i,j,1) = free_raster(i,1);
       Init(i,j,2) = free_raster(i,2);      
       Init(i,j,3) = orient(j);
    end
end
Init = reshape(Init,[r_f*length(orient),3]);

end

