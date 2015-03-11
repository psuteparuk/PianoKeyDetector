function cuttingLines = findBounds(imgGrad,height,width)

sumGrad = sum(imgGrad,2);
[~,idx] = sort(sumGrad,'descend');
firstNonZero = find(sumGrad < 0.1*width,1,'first');
lastNonZero = find(sumGrad < 0.1*width,1,'last');
cuttingLines = zeros(1,3);
count = 0;
ctr = 1;
thresh = 20;
while count < 3
    if idx(ctr) >= firstNonZero && idx(ctr) <= lastNonZero
        if count == 0
            count = count + 1;
            cuttingLines(count) = idx(ctr);
            ctr = ctr + 1;
            continue;
        end
        diff = abs(cuttingLines(1:count) - idx(ctr));
        if sum(diff < thresh) == 0
            count = count + 1;
            cuttingLines(count) = idx(ctr);
        end
    end
    ctr = ctr + 1;
end

curImg = zeros(size(imgGrad));
curImg(cuttingLines,:) = 1;