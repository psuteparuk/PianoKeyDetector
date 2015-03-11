function [ blackKeys,numBlackKeys ] = findBlackKeys(img,L)

top = round(0.1*L); bottom = L;
crop = img(top:bottom,:);
[imgLabels,numLabels] = bwlabel(crop,4);
for i = 1:numLabels
    ind = find(imgLabels == i);
    if numel(ind) < 50
        crop(ind) = 0;
    end
end

blackKeys = zeros(size(img));
[blackLabels,numBlackKeys] = bwlabel(crop,4);
blackKeys(top:bottom,:) = blackLabels;

% % Plot
% figure; imshow(img,'Border','tight'); hold on;
% for i = 1:numBlackKeys
%     [r,c] = find(blackKeys == i);
%     k = convhull(r,c);
%     plot(c(k),r(k),'y-');
% end