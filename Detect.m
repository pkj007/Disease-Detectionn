
clc
close all 
clear all
cputime
[filename, pathname] = uigetfile({'*.*';'*.bmp';'*.jpg';'*.gif'}, 'Pick a Leaf Image File');
I = imread([pathname,filename]);
I = imresize(I,[256,256]);
% Enhance Contrast
I = imadjust(I,stretchlim(I));
figure, imshow(I);title('Contrast Enhanced');
%% Extract Features
cform = makecform('srgb2lab');
% Apply the colorform
lab_he = applycform(I,cform);
ab = double(lab_he(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);
nColors = 2;
[cluster_idx cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
                                      'Replicates',3);
pixel_labels = reshape(cluster_idx,nrows,ncols);
segmented_images = cell(1,3);
rgb_label = repmat(pixel_labels,[1,1,3]);

for k = 1:nColors
    colors = I;
    colors(rgb_label ~= k) = 0;
    segmented_images{k} = colors;
end

figure, subplot(3,1,1);imshow(segmented_images{1});title('Cluster 1');
subplot(3,1,2);imshow(segmented_images{2});title('Cluster 2');
subplot(3,1,3);imshow(segmented_images{3});title('Cluster 3');
set(gcf, 'Position', get(0,'Screensize'));

% Feature Extraction
x = inputdlg('Enter the cluster no. containing the ROI only:');
i = str2double(x);
seg_img = segmented_images{i};

if ndims(seg_img) == 3
   img = rgb2gray(seg_img);
end
black = im2bw(seg_img,graythresh(seg_img));

m = size(seg_img,1);
n = size(seg_img,2);

zero_image = zeros(m,n); 

cc = bwconncomp(seg_img,6);
diseasedata = regionprops(cc,'basic');
A1 = diseasedata.Area;
sprintf('Area of the disease affected region is : %g%',A1);

I_black = im2bw(I,graythresh(I));
kk = bwconncomp(I,6);
leafdata = regionprops(kk,'basic');
A2 = leafdata.Area;
sprintf(' Total leaf area is : %g%',A2);

Affected_Area = (A1/A2);
if Affected_Area < 0.1
    Affected_Area = Affected_Area+0.15;
end
sprintf('Affected Area is: %g%%',(Affected_Area*100))

% Create the Gray Level Cooccurance Matrices (GLCMs)
glcms = graycomatrix(img);

% Derive Statistics from GLCM
stats = graycoprops(glcms,'Contrast Correlation Energy Homogeneity');
Contrast = stats.Contrast;
Correlation = stats.Correlation;
Energy = stats.Energy;
Homogeneity = stats.Homogeneity;
Mean = mean2(seg_img);
Standard_Deviation = std2(seg_img);
Entropy = entropy(seg_img);
RMS = mean2(rms(seg_img));

Variance = mean2(var(double(seg_img)));
a = sum(double(seg_img(:)));

Kurtosis = kurtosis(double(seg_img(:)));
Skewness = skewness(double(seg_img(:)));

m = size(seg_img,1);
n = size(seg_img,2);
in_diff = 0;
for i = 1:m
    for j = 1:n
        temp = seg_img(i,j)./(1+(i-j).^2);
        in_diff = in_diff+temp;
    end
end

    
feat_disease = [Contrast,Correlation,Energy,Homogeneity, Mean, Standard_Deviation, Entropy, RMS, Variance, Kurtosis, Skewness];

load('Label.mat')
load('Feat.mat')


test = feat_disease;
result = multisvm(Feat,Label,test);



if result == 0
    helpdlg(' Healthy Leaf ');
    disp(' Healthy Leaf ');
   
elseif result == 1
    helpdlg(' Bacterial Spot ');
    disp('Bacterial Spot');
    
elseif result == 2
    helpdlg(' Septoria ');
    disp(' Septoria ');
    
elseif result == 3
    helpdlg('Leaf Mold');
    disp('Leaf Mold');
    

end



disp('current time:');
cputime

disp('Total CPU time is:');
cputime-a
