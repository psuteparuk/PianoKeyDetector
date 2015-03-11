function mask = applyMAP( img,centroidClass,centroids )

% Apply MAP detector

[height,width,channels] = size(img);
imgClassify = zeros(height,width);
for y = 1:height
    for x = 1:width
        pix = img(y,x,:);
        indRGB = zeros(1,3);
        for c = 1:channels
            [minDist,indRGB(c)] = min(abs(pix(c) - centroids));
        end
        pixClass = centroidClass(indRGB(1),indRGB(2),indRGB(3));
        imgClassify(y,x) = pixClass;
    end
end

% Clean up results using region labeling

imgClassifyPost = imgClassify;

% Remove small positive regions
[imgLabels,numLabels] = bwlabel(imgClassifyPost,4);
for j = 1:numLabels
    ind = find(imgLabels == j);
    if numel(ind) < 50
        imgClassifyPost(ind) = 0;
    end
end

% Remove small negative regions
[imgLabels,numLabels] = bwlabel(~imgClassifyPost,4);
for j = 1:numLabels
    ind = find(imgLabels == j);
    if numel(ind) < 50
        imgClassifyPost(ind) = 1;
    end
end

% Dilate
SE = ones(5);
imgClassifyPost = imdilate(imgClassifyPost,SE);

mask = imgClassifyPost;