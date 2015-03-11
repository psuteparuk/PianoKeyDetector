%% Load video

filepath = 'images/CallMeMaybe_Clip/';
videoFrames = dir([filepath '*.jpg']);
numFrames = length(videoFrames);

framesRGB = cell(1,numFrames);
framesGray = cell(1,numFrames);
framesBin = cell(1,numFrames);
framesMask = cell(1,numFrames);

%% Train MAP to detect hands as foreground

[centroidClass,centroids] = trainMAP();

%% Use first frame to find the rotation angle and crop the piano

initialFrame = im2double(imread('images/CallMeMaybe.jpg'));
initialFrameGray = rgb2gray(initialFrame);
grayThresh = graythresh(initialFrameGray);
initialFrameBin = im2bw(initialFrameGray,grayThresh);
initialFrameBin = removeSmallRegions(initialFrameBin,4);

% Rectify
[initialFrameRotate,initialFrameGrad,angle] = rectify(~initialFrameBin);
[height,width] = size(initialFrameRotate);

% Find bounds
horizontalErode = imerode(initialFrameGrad,ones(1,20));
horizontalClose = imclose(horizontalErode,ones(1,300));
initialFrameGradLine = max(initialFrameGrad,horizontalErode);
cuttingLines = findBounds(initialFrameGradLine,height,width);
cuttingLinesSorted = sort(cuttingLines);

% figure; imshow(initialFrameGray); hold on;
% plot([0;width],ones(2,1)*cuttingLines(1),'y-');
% plot([0;width],ones(2,1)*cuttingLines(2),'y-');
% plot([0;width],ones(2,1)*cuttingLines(3),'y-');

tmp = imrotate(initialFrame,angle,'bilinear','crop');
initialFrame = tmp(cuttingLinesSorted(1):cuttingLinesSorted(3),:,:);
keyboard.RGB = initialFrame;

initialFrameGray = rgb2gray(initialFrame);
keyboard.Gray = initialFrameGray;

grayThresh = graythresh(initialFrameGray);
initialFrameBin = im2bw(initialFrameGray,grayThresh);
initialFrameBin = removeSmallRegions(initialFrameBin,4);
keyboard.Bin = ~initialFrameBin;

keyboard.Mask = zeros(size(keyboard.Gray));

blackKeyLength = cuttingLinesSorted(2) - cuttingLinesSorted(1);

%% Apply to all frames

for i = 1:numFrames
    frame = im2double(imread([filepath videoFrames(i).name]));
    tmp = imrotate(frame,angle,'bilinear','crop');
    frame = tmp(cuttingLinesSorted(1):cuttingLinesSorted(3),:,:);
    framesRGB{i} = frame;
    
    frameGray = rgb2gray(frame);
    framesGray{i} = frameGray;
    
    grayThresh = graythresh(frameGray);
    frameBin = im2bw(frameGray,grayThresh);
    frameBin = removeSmallRegions(frameBin,4);
    framesBin{i} = ~frameBin;
    
    frameDouble = double(imread([filepath videoFrames(i).name]));
    tmp = imrotate(frameDouble,angle,'bilinear','crop');
    frameDouble = tmp(cuttingLinesSorted(1):cuttingLinesSorted(3),:,:);
    framesMask{i} = applyMAP(frameDouble,centroidClass,centroids);
end