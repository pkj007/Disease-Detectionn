clc
close all 
clear all

[filename, pathname] = uigetfile({'*.*';'*.bmp';'*.jpg';'*.gif'}, 'Pick a Leaf Image File');
I = imread([pathname,filename]);
I = imresize(I,[256,256]);
figure, imshow(I);title('normal image');
[bw, rgb]=BackgroundSegmentation(I);    
figure, subplot(2,1,1);imshow(bw);title('segmented'); subplot(2,1,2);imshow(rgb);title('Cluster 2');