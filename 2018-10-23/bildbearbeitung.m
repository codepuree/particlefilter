%% Reset Matlab environment
close all;
clear all;

%% Load image
img = imread('Vorgabe_erode.png');

figure('name', 'Original');
imshow(img);
title('Original');

% %% Convert image to grayscale
% imgGray = rgb2gray(img);
% 
% 
% 
% %% Convert image to binary
% imgBin = imbinarize(imgGray);
% 
% figure('name', 'Binary');
% imshow(imgBin);
% title('Binary');

%% Opening
imgOp=imclose(img,strel('disk',1));
% strRode = strel('square',2);
% %strdil = [strel('line',3,90) strel('line',3,0)];
% strdil = strel('square',2);
% imgOp = imdilate(imerode(imgBin,strRode),strdil);
figure
imshow(imgOp)


%% BWareaopen
imgBW = bwareaopen(imgBin,50);
figure
imshowpair(imgBin,imgBW,'montage');


%% Sobel Filter
[~, threshold] = edge(imgBin, 'sobel');
fudgeFactor = .8;
imgSobel = edge(imgBin,'sobel',threshold *fudgeFactor);
figure('name','Sobel');
imshow(imgSobel);

%% Dilate the image
imgDil = imdilate(imgSobel,[strel('line',3,90) strel('line',3,0)]);
figure, imshow(imgDil),title('Dilated');

%% Fill Gaps
imgFill = imfill(imgDil,'holes');
figure, imshow(imgFill),title('Filled');





% %% Canny Filter
% imgCany = edge(imgBin,'canny');
% figure('name','Canny');
% imshow(imgCany);
% 
% %% Dilate image
% imgdil = imdilate(imgBin,strel('square',2));
% 
% figure ('name', 'Dilate');
% imshow(imgdil);
% title('Dilated')
% 
% % %% Median filter to image
% % imgmed = medfilt2(imgGray);
% % figure('name','Median');
% % imshow(imgmed);
% % title('Median');
% 
% 
% %% Erode image
% imgErode = imerode(imgBin, strel('square',2));
% 
% figure('name', 'Eroded');
% imshow(imgErode);
% title('Eroded');
% 
% 
% %% Save new image
imwrite(imgErode, 'Vorgabe_erode.png');