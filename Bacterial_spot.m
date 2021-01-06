clc
close all 
clear all
[filename, pathname] = uigetfile({'*.*';'*.bmp';'*.jpg';'*.gif'}, 'Pick a Leaf Image File');
items=dir(pathname);
final=double.empty(0,30);
for(i=3:size(items))
    clc
    close all 
    I = imread([pathname,items(i).name]);
    I = imresize(I,[256,256]);
    I = imadjust(I,stretchlim(I));
    figure, imshow(I);title('Contrast Enhanced');
    I_Otsu = im2bw(I,graythresh(I));
    I_HIS = rgb2hsi(I);
    [feat_disease seg_img]=EvaluateFeatures(I);
    final=[final;feat_disease];
end
xlswrite('Bacterial_spot.xlsx',final);