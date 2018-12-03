function [Init] = Initialization(grid, orient, varargin)

%% Parse additional function inputs
p = inputParser();

% GridX name-value pair
defaultValGridX = 0.5;
validateGridX   = @(x) validateattributes(x, {'double','single'}, {'nonempty', 'positive'});
addParameter(p, 'gridx', defaultValGridX, validateGridX);

% GridY name-value pair
defaultValGridY = 10;
validateGridY   = @(x) validateattributes(x, {'double','single'}, {'nonempty', 'positive'});
addParameter(p, 'gridy', defaultValGridY, validateGridY);

parse(p, varargin{:})

gridX = p.Results.gridx;
gridY = p.Results.gridy;

%% Generate raster
[X, Y] = meshgrid(grid.XWorldLimits(1):gridX:grid.XWorldLimits(2),grid.YWorldLimits(1):gridY:grid.YWorldLimits(2));
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