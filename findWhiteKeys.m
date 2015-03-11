function [ whiteKeys,numWhiteKeys ] = findWhiteKeys(blackKeys,numBlackKeys,lowerBound)

blackR = cell(1,numBlackKeys);
blackC = cell(1,numBlackKeys);
blackXPos = zeros(1,numBlackKeys);
blackYPos = zeros(1,numBlackKeys);
blackMaxR = zeros(1,numBlackKeys);
blackMinR = zeros(1,numBlackKeys);
heightBlack = zeros(1,numBlackKeys);
widthBlack = zeros(1,numBlackKeys);
for i = 1:numBlackKeys
    [r,c] = find(blackKeys == i);
    k = convhull(c,r);
    blackR{i} = r;
    blackC{i} = c;
    blackXPos(i) = (max(c(k)) + min(c(k))) / 2;
    blackYPos(i) = (max(r(k)) + min(r(k))) / 2;
    blackMaxR(i) = max(r(k));
    blackMinR(i) = min(r(k));
    ind = find(r(k) == blackMinR(i));
    heightBlack(i) = blackMaxR(i) - blackMinR(i) + 1;
    cc = c(k);
    widthBlack(i) = max(cc(ind)) - min(cc(ind)) + 1;
end
blackXDiff = blackXPos(2:end) - blackXPos(1:end-1);
figure; plot(1:numBlackKeys-1,blackXDiff);

minDiff = min(blackXDiff); maxDiff = max(blackXDiff);
middleDiff = (minDiff + maxDiff) / 2;
bigDiff = blackXDiff > middleDiff;
pattern = bigDiff(6:10);
numPattern = floor(length(bigDiff) / 5);
rem = length(bigDiff) - 5*numPattern;
bigDiff = [repmat(pattern,[1 numPattern]) pattern(1:rem)];
smallDiff = ~bigDiff;
numWhiteKeys = 2*sum(bigDiff) + sum(smallDiff);

whiteKeys = zeros(size(blackKeys));
blackCtr = 1;
left = true;
for i = 1:numWhiteKeys
    if ~left && bigDiff(blackCtr)
        r = blackR{blackCtr+1};
        c = blackC{blackCtr+1};
        y = blackYPos(blackCtr+1);
        x = blackXPos(blackCtr+1);
        ym = (lowerBound + blackMinR(blackCtr+1)) / 2;
        xm = (blackXPos(blackCtr) + 4*blackXPos(blackCtr+1)) / 5;
        heightWhite = lowerBound - blackMinR(blackCtr+1);
        widthWhite = (blackXPos(blackCtr+1) - blackXPos(blackCtr)) / 2;
        scaleY = heightWhite / heightBlack(blackCtr+1);
        scaleX = widthWhite / widthBlack(blackCtr+1);
        blackCtr = blackCtr + 1;
        left = true;
    else
        r = blackR{blackCtr};
        c = blackC{blackCtr};
        y = blackYPos(blackCtr);
        x = blackXPos(blackCtr);
        ym = (lowerBound + blackMinR(blackCtr)) / 2;
        if bigDiff(blackCtr)
            xm = (4*blackXPos(blackCtr) + blackXPos(blackCtr+1)) / 5;
        else
            xm = (blackXPos(blackCtr) + blackXPos(blackCtr+1)) / 2;
        end
        heightWhite = lowerBound - blackMinR(blackCtr);
        if bigDiff(blackCtr)
            widthWhite = (blackXPos(blackCtr+1) - blackXPos(blackCtr)) / 2;
        else
            widthWhite = (blackXPos(blackCtr+1) - blackXPos(blackCtr));
        end
        scaleY = heightWhite / heightBlack(blackCtr);
        scaleX = widthWhite / widthBlack(blackCtr);
        if bigDiff(blackCtr)
            left = false;
        else
            blackCtr = blackCtr + 1;
        end
    end
    [rm,cm] = scaleArea(r,c,y,x,ym,xm,scaleY,scaleX);
    for j = 1:length(rm)
        if cm(j) >= 1 && cm(j) <= size(whiteKeys,2)
            whiteKeys(rm(j),cm(j)) = i;
        end
    end
end

% Separate white and black
whiteKeys = whiteKeys .* (blackKeys == 0);

function [ rm,cm ] = scaleArea(r,c,y,x,ym,xm,scaleY,scaleX)
    
rm = round(scaleY*(r-y) + ym);
cm = round(scaleX*(c-x) + xm);