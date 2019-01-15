clear all 
close all
clc


% Setup paralell pool
numWorkers = 4;
poolObj = gcp('nocreate');
if isempty(poolObj)
    poolObj = parpool('local', numWorkers,'SpmdEnabled', false);
end
filename = 'TestConfig.dat';
M = csvread(filename);
[fin,~] = size(M);
result = zeros(fin,4);

for i = 1:fin
gesamt = tic;
sigma = M(i,1);
bins = M(i,2);
dispersion = [M(i,3),M(i,4),M(i,5)];
stepsOrientation = M(i,6);
movement = [M(i,7),M(i,8)];

mapResolution = 20;
angleRange = 0.96;  %rad
dataRootFolder = 'D:\Desktop\Studium\7_Semester\Matlab_Nav_App\2019\ParticleFilter\Data';
mapPath = 'D:\Desktop\Studium\7_Semester\Matlab_Nav_App\2019\ParticleFilter\Data\Vorgabe_Rundgang.png';
particles = StartParticlefilter( ...  
                'mapPath',          mapPath, ...
                'mapResolution',    mapResolution, ...
                'numWorkers',       4, ...
                'pose',             [0,0,0], ...
                'movement',         movement, ...
                'sigma',            sigma, ...
                'my',               0, ...
                'minNumParticles',  1500, ...
                'bins',             bins, ...
                ... % 'minY', app., ...
                ... % 'maxY', ...
                'dispersion',       dispersion, ...
                ... % 'factorParticleReduction', ...
                'gridX',            1, ...
                'gridY',            1, ...
                'maxIteration',     41, ...
                'angleRange',       angleRange, ...
                'simFlag',          'Rundgang', ...
                'stepsOrientation', stepsOrientation, ...
                'dataRootFolder',   dataRootFolder ...
            );
        tElapsed = toc(gesamt);
%         disp(nnz(isnan(particles)));
        result(i,:) = [mean(particles(:,1)),mean(particles(:,2)),mean(particles(:,3)),tElapsed];
        
end
csvwrite('Testergebnisse.txt',result)