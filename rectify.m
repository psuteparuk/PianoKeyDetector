function [ imgRotate,imgGradient,angle ] = rectify(imgNeg,angle)

% Use Sobel filter to find horizontal gradient
sobel = fspecial('sobel');
imgSobel = imfilter(imgNeg,sobel);

if nargin < 2
    % Hough
    thetaRange = -90:89;
    [H,theta,rho] = hough(imgSobel,'Theta',thetaRange);
    peaks = houghpeaks(H,20,'Threshold',0.3*max(H(:)));
    % figure(1);
    % imshow(imadjust(mat2gray(H)),'InitialMagnification','fit',...
    %     'XData',theta,'YData',rho); axis normal; axis on; hold on;
    % plot(theta(peaks(:,2)),rho(peaks(:,1)),'go');
    % xlabel('\theta'); ylabel('\rho');

    % Find the angle
    [~,ind] = max(hist(theta(peaks(:,2)),thetaRange));
    angle = thetaRange(ind) + 90;
end

% Rotate image
imgRotate = imrotate(imgNeg,angle,'bilinear','crop');
imgGradient = imrotate(imgSobel,angle,'bilinear','crop');