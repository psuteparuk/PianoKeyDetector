function [ frameAligned,maskAligned,dxOpt,dyOpt ] = alignFrame(frame1,mask1,frame2,mask2,dxRange,dyRange)

[height,width,channels] = size(frame1);
MSE = inf;
for dx = dxRange
    for dy = dyRange
        A = [1 0 dx; 0 1 dy; 0 0 1];
        tform = maketform('affine',A.');
        frame1Tform = imtransform(frame1,tform,'bilinear',...
                                'XData',[1 width],'YData',[1 height],...
                                'FillValues',zeros(channels,1));
        mask1Tform = imtransform(mask1,tform,'bilinear',...
                                'XData',[1 width],'YData',[1 height],...
                                'FillValues',zeros(channels,1));
        imgDiff = (frame1Tform - frame2) .* min(mask1,mask2);
        frameMSE = sum(sum(imgDiff.^2));
        if frameMSE < MSE
            MSE = frameMSE;
            dxOpt = dx;
            dyOpt = dy;
            frameAligned = frame1Tform;
            maskAligned = mask1Tform;
        end
    end
end