mask1 = im2bw(rgb2gray(imread('mark1.png')),0.5);
mask2 = im2bw(rgb2gray(imread('mark2.png')),0.5);

mask = max(mask1,mask2);
mask = mask(36:191,103:956);

imwrite(mask,'mask3.png');