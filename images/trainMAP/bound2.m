masks{1} = im2bw(rgb2gray(imread('mark1.png')),0.5);
masks{2} = im2bw(rgb2gray(imread('mark2.png')),0.5);
masks{3} = im2bw(rgb2gray(imread('mark3.png')),0.5);
masks{4} = im2bw(rgb2gray(imread('mark4.png')),0.5);
masks{5} = im2bw(rgb2gray(imread('mark5.png')),0.5);
% masks{6} = im2bw(rgb2gray(imread('mark6.png')),0.5);

mask = masks{1};
for i = 2:5
    mask = max(mask,masks{i});
end
mask = mask(36:156,103:956);

imwrite(mask,'mask5.png');