% Social Distancing Detection (Image)
clear, clc, close all

detector = peopleDetectorACF();

% Image Selection
imgfile = uigetfile({'.jpg'});
image = imread(imgfile);
%image = imread('distancing1.jpg');

% Create boxes for people detected in the image
[bboxes, scores] = detect(detector,image);

% Check for all boxes and compare distances
for i = 2:size(bboxes,1)
    dis1_v = abs(bboxes(1,1)+bboxes(1,3)-bboxes(1,1));
    dis2_v = abs(bboxes(i,1)+bboxes(i,3)-bboxes(1,1));
    dis1_h = abs(bboxes(1,2)-bboxes(i,2));
    dis2_h = abs(bboxes(1,2)+bboxes(1,4)-bboxes(i,2)-bboxes(i,4));
    if ((dis1_v < 75 || dis2_v < 75) && (dis1_h < 50 || dis2_h < 50))
        image = insertObjectAnnotation(image,'rectangle',bboxes(i,:),i,'color','r');
        image = insertObjectAnnotation(image,'rectangle',bboxes(i,:),i,'color','r');
    else
        image = insertObjectAnnotation(image,'rectangle',bboxes(i,:),i,'color','g'); 
    end
end

% Display image detection
imshow(image);

