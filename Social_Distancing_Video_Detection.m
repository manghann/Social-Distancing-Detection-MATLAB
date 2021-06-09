% Social Distancing Detection (Video)
clear, clc, close all

% Read video file
vidfile = uigetfile({'.avi'});
video = vision.VideoFileReader(vidfile);        
%video = vision.VideoFileReader('distancing.avi')
videoPlayer = vision.VideoPlayer('Position', [300 100 1000 500]);

detector = peopleDetectorACF('caltech-50x21');

% Writes (new) detection video
writerObj = VideoWriter('VideoDetection.avi');
writerObj.FrameRate = 8;    % FPS

% Starts writing video
open(writerObj);

while ~isDone(video)
    frame = step(video);    % Get frame
    I = double(frame);
    [bboxes, scores] = detect(detector, I);
    
    condition = zeros(size(bboxes,1),1);
    
    if ~isempty(bboxes)
        for i=1:(size(bboxes,1)-1)
            for j = (i+1):(size(bboxes,1)-1)
                dis1_v = abs(bboxes(i,1)+bboxes(i,3)-bboxes(j,1));
                dis2_v = abs(bboxes(j,1)+bboxes(j,3)-bboxes(i,1));
                dis1_h = abs(bboxes(i,2)-bboxes(j,2));
                dis2_h = abs(bboxes(i,2)+bboxes(i,4)-bboxes(j,2)-bboxes(j,4));
                if ((dis1_v < 75 || dis2_v < 75) && (dis1_h < 50 || dis2_h < 50))
                    condition(i) = condition(i)+1;
                    condition(j) = condition(j)+1;
                else
                    condition(i) = condition(i)+0;
                end
            end
        end
    end    
          
    I = insertObjectAnnotation(I,'rectangle',bboxes((condition > 0),:),'Violator','color','r');
    I = insertObjectAnnotation(I,'rectangle',bboxes((condition == 0),:),'Non-violator','color','g');
    
    step(videoPlayer,I);
    frame = im2frame(I);
    
    % Stop writing video
    writeVideo(writerObj,frame);
        
end

% Display Video Detection
release(video);
release(videoPlayer);

% Close Video
close(writerObj);