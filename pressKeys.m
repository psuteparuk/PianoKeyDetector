function [ pressedWhite,pressedBlack ] = pressKeys(frame1,mask1,frame2,mask2,whiteKeys,numWhiteKeys,blackKeys,numBlackKeys)

dxRange = -3:3;
dyRange = -3:3;
[frameAligned,maskAligned,dxOpt,dyOpt] = alignFrame(frame1,mask1,frame2,mask2,dxRange,dyRange);
imgDiff = abs(frame2 - frameAligned);
bgDiff = imgDiff .* min(maskAligned,mask2);
kernel = fspecial('average',3);
bgDiff = imfilter(bgDiff,kernel);
% figure; imshow(bgDiff,'Border','tight'); hold on;

scoresWhite = zeros(1,numWhiteKeys);
pressedWhite = zeros(1,numWhiteKeys);
for i = 1:numWhiteKeys
    keys = whiteKeys == i;
    change = sum(sum(keys .* bgDiff));
    area = sum(sum(keys .* min(maskAligned,mask2)));
    scoresWhite(i) = change / area;
    if scoresWhite(i) >= 0.03
%         [r,c] = find(whiteKeys == i);
%         k = convhull(c,r);
%         plot(c(k),r(k),'y-');
        pressedWhite(i) = 1;
    end
end

% [scoresWhiteSorted,ind] = sort(scoresWhite);
% figure; plot(1:numWhiteKeys,scoresWhiteSorted);
% disp(scoresWhiteSorted);

% figure; imshow(bgDiff,'Border','tight'); hold on;

scoresBlack = zeros(1,numBlackKeys);
pressedBlack = zeros(1,numBlackKeys);
for i = 1:numBlackKeys
    keys = blackKeys == i;
    change = sum(sum(keys .* bgDiff));
    area = sum(sum(keys .* min(maskAligned,mask2)));
    scoresBlack(i) = change / area;
    if scoresBlack(i) >= 0.03
%         [r,c] = find(blackKeys == i);
%         k = convhull(c,r);
%         plot(c(k),r(k),'y-');
        pressedBlack(i) = 1;
    end
end

% [scoresBlackSorted,ind] = sort(scoresBlack);
% figure; plot(1:numBlackKeys,scoresBlackSorted);
% disp(scoresBlackSorted);