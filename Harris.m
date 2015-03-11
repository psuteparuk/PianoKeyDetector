function [x,y] = Harris(img)

C = cornermetric(im2double(img),'Harris','SensitivityFactor',0.04);
C(C < 1e-4) = 0;
peaks = imregionalmax(C);
ind = find(peaks);
[y,x] = ind2sub(size(img),ind);