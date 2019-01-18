%% Setup matlab environment
clear all;
close all;
clc;

%% Parameters
configPath = './TestConfig_2.dat';
resultPath = './Testergebnisse_2.csv';

%% Setup paralell pool
numWorkers = 8;

myCluster = parcluster('local');
myCluster.NumThreads = 4;
myCluster.NumWorkers = numWorkers;

poolObj = gcp('nocreate');
if isempty(poolObj)
    poolObj = parpool('local', numWorkers,'SpmdEnabled', false);
end

M = csvread(configPath);
[fin,~] = size(M);
result = zeros(fin,11);

for i = 1:fin
    disp([10 '==================== Case: ' num2str(i) ' ====================']);
    try
        gesamt = tic;
        sigma = M(i,1);
        bins = M(i,2);
        dispersion = [M(i,3),M(i,4),M(i,5)];
        stepsOrientation = M(i,6);
        movement = [M(i,7),M(i,8)];

        mapResolution = 20;
        angleRange = 0.96;  %rad
        dataRootFolder = '../../Data';
        mapPath = '../../Data/Vorgabe_Rundgang.png';
        particles = StartBenchmarkParticlefilter( ...  
            'mapPath',          mapPath, ...
            'mapResolution',    mapResolution, ...
            'numWorkers',       numWorkers, ...
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
        result(i,:) = [i, particles(1,1), particles(1,2), particles(1,3), mean(particles(:,1)),mean(particles(:,2)),mean(particles(:,3)),std(particles(:,1)),std(particles(:,2)),std(particles(:,3)),tElapsed];
    catch err
        disp([getReport(err, 'extended') '+++ Case: ' num2str(i)]);
    end
   
    csvwrite(resultPath, result) 
end

disp([10 '====== F I N I S H E D   A L L   C A S E S ======']);