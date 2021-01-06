function [BW,maskedRGBImage] = createMask(RGB)
I = rgb2lab(RGB);
channel1Min = 7.354;
channel1Max = 56.906;
channel2Min = -30.800;
channel2Max = 11.739;
channel3Min = -11.990;
channel3Max = 36.104;
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;
maskedRGBImage = RGB;
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;
end
