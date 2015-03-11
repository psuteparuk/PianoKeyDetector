%% Find keys

% Black Keys

[blackKeys,numBlackKeys] = findBlackKeys(keyboard.Bin,...
    cuttingLinesSorted(2)-cuttingLinesSorted(1));

% Plot
figure; imshow(keyboard.RGB,'Border','tight'); hold on;
for i = 1:numBlackKeys
    [r,c] = find(blackKeys == i);
    k = convhull(c,r);
    h = plot(c(k),r(k),'y-');
    set(h,'LineWidth',2);
end

% White keys

[whiteKeys,numWhiteKeys] = ...
    findWhiteKeys(blackKeys,numBlackKeys,size(blackKeys,1));

% Erode black keys to create buffer between white and black
SE = ones(7);
blackKeys = imerode(blackKeys,SE);

% Plot
figure; imshow(keyboard.RGB,'Border','tight'); hold on;
for i = 1:numWhiteKeys
    [r,c] = find(whiteKeys == i);
    k = convhull(c,r);
    h = plot(c(k),r(k),'y-');
    set(h,'LineWidth',2);
end

% Plot
figure; imshow(keyboard.RGB,'Border','tight'); hold on;
for i = 1:numBlackKeys
    [r,c] = find(blackKeys == i);
    k = convhull(c,r);
    h = plot(c(k),r(k),'y-');
    set(h,'LineWidth',1);
end