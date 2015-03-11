function [centroidClass,centroids] = trainMAP(p)

if nargin < 1
    p = 0;
end

% Load training images

numTraining = 5;
imgTrain = cell(1,numTraining);
imgTrainMask = cell(1,numTraining);
for i = 1:numTraining
    imgTrain{i} = double(imread(['images/trainMAP/img' num2str(i) '.jpg']));
    imgTrainMask{i} = imread(['images/trainMAP/mask' num2str(i) '.png']);
    imgTrainMask{i} = imgTrainMask{i} > 0;
end

% Train MAP detector

step = 16;
centroids = step/2:step:256;
numCentroids = length(centroids);
countsSign = zeros(numCentroids,numCentroids,numCentroids);
countsNonSign = zeros(numCentroids,numCentroids,numCentroids);
for i = 1:numTraining
    [height,width,channels] = size(imgTrain{i});
    for y = 1:height
        for x = 1:width
            pix = imgTrain{i}(y,x,:);
            indRGB = zeros(1,channels);
            for c = 1:channels
                [minDist,indRGB(c)] = min(abs(pix(c) - centroids));
            end
            if imgTrainMask{i}(y,x) == 1
                k = countsSign(indRGB(1),indRGB(2),indRGB(3));
                countsSign(indRGB(1),indRGB(2),indRGB(3)) = k + 1;
            else
                k = countsNonSign(indRGB(1),indRGB(2),indRGB(3));
                countsNonSign(indRGB(1),indRGB(2),indRGB(3)) = k + 1;
            end
        end
    end
end
centroidClass = countsSign > countsNonSign;

if p == 1
    % Collect samples
    numSignSamples = 0;
    numNonSignSamples = 0;
    for i = 1:numTraining
        numSignSamples = numSignSamples + numel(find(imgTrainMask{i} == 1));
        numNonSignSamples = numNonSignSamples + numel(find(imgTrainMask{i} == 0));
    end
    RGBSign = zeros(numSignSamples,3);
    RGBNonSign = zeros(numNonSignSamples,3);
    counterSign = 1;
    counterNonSign = 1;
    skipY = 5;
    skipX = 5;
    for i = 1:numTraining
        [height,width,channels] = size(imgTrain{i});
        for y = 1:skipY:height
            for x = 1:skipX:width
                pix = imgTrain{i}(y,x,:);
                if imgTrainMask{i}(y,x) == 1
                    RGBSign(counterSign,:) = pix;
                    counterSign = counterSign + 1;
                else
                    RGBNonSign(counterNonSign,:) = pix;
                    counterNonSign = counterNonSign + 1;
                end
            end
        end
    end
    RGBSign = RGBSign(1:counterSign-1,:);
    RGBNonSign = RGBNonSign(1:counterNonSign-1,:);

    % Plot samples
    figure(1);
    scatter3(RGBSign(:,1),RGBSign(:,2),RGBSign(:,3),10,[1 0 0]); hold on;
    scatter3(RGBNonSign(:,1),RGBNonSign(:,2),RGBNonSign(:,3),10,[0 0 1]); hold on;
    set(gca,'XTick',0:32:256,'YTick',0:32:256,'ZTick',0:32:256);
    xlabel('R'); ylabel('G'); zlabel('B');
    axis square; axis([0 256 0 256 0 256]);
end