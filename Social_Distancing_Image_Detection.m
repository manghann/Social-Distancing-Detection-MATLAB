% Social Distancing Detection (Image)
clear, clc, close all

% Image Selection
[filename,pathname] = uigetfile(fullfile(pwd,'Images','*.*'),'Select an Image')
fname = [filename]
filewithpath = strcat(pathname,filename);

image = imread(filewithpath);

% Create detector variable & boxes for people detected in the image
detector = peopleDetectorACF();
[bboxes,scores] = detect(detector,image);

% Check for all boxes and compare distances
cond = zeros(size(bboxes,1),1);
if ~isempty(bboxes)
    for i=1:(size(bboxes,1)-1)
        for j=(i+1):(size(bboxes,1)-1)
             dis1_v = abs(bboxes(i,1)+bboxes(i,3)-bboxes(j,1));
             dis2_v = abs(bboxes(j,1)+bboxes(j,3)-bboxes(i,1));
             dis1_h = abs(bboxes(i,2)-bboxes(j,2));
             dis2_h = abs(bboxes(i,2)+bboxes(i,4)-bboxes(j,2)-bboxes(j,4));
             if((dis1_v<75 || dis2_v<75) && (dis1_h<50 || dis2_h<50))
                cond(i)=cond(i)+1;
                cond(j)=cond(j)+1;
             else
                cond(i)=cond(i)+0; 
             end
        end
    end
end
image = insertObjectAnnotation(image,'rectangle',bboxes((cond>0),:),'unsafe','color','r');
image = insertObjectAnnotation(image,'rectangle',bboxes((cond==0),:),'safe','color','g');
 
% Display image detection
imshow(image);

% Save image
filename = strcat(fname,' (SD_Detection).jpg');
imwrite(image,filename);
