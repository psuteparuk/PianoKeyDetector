function img = removeSmallRegions(img,neighbors)

% Remove small regions
[imgLabels,numLabels] = bwlabel(img,neighbors);
for i = 1:numLabels
    ind = find(imgLabels == i);
    if numel(ind) < 150
        img(ind) = 0;
    end
end
[imgLabels,numLabels] = bwlabel(~img,neighbors);
for i = 1:numLabels
    ind = find(imgLabels == i);
    if numel(ind) < 150
        img(ind) = 1;
    end
end