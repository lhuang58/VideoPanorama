%% This is the main function for assessing given video segments
% Read given video segments
video = VideoReader('./testVideoSegs/twoSeg2.avi');
%video = VideoReader('./testVideoSegs/testSeg1.avi');
%video = VideoReader('./testVideoSegs/testSeg2.avi');

% Convert video to cell array
source = {};
count = 1;
% put every frame in source{} array
while hasFrame(video)
    frame = readFrame(video);
    source{count} = frame;
    count = count + 1;
end

sLength = length(source);
% every 20 frames form one segment, this is the smallest unit of processing
% panorama
for i = 1: 20: sLength
    % in case the last segment has less than 20 frames, prevent index out of
    % bound 
    if i+20 > sLength
        endingFrame = sLength;
    else
        endingFrame = i+20;
    end
    counter =1;
    
    for j=i:endingFrame
        seg{counter}=source{j};
        counter= counter+1;
    end
    % store the distortion result of every segment in an array
    distortion{ceil(i/20)} = visualQuality(seg);
end

% set threshhold to be 250, segments which distortion  
% larger than this value are considered bad
% and should not be used to synthesized panorama.
% threshhold is used for dividing different panoramas
threshhold = 250;
startSeg = 1;
panoramaCounter = 1;
for i = 1: length(distortion)
    % divide segment by threshhold
    if distortion{i} > threshhold || i == length(distortion)
        % if less than 3 segments, we ignore these segment because they are
        % having small depth of view (only 60 frames).
        if i-startSeg < 3
            startSeg = i+1;
        else
            % synthesize the panorama
            for j = 1: (i-startSeg)*20
                panoSeg{j} = source{j+(startSeg-1)*20};
            end
            [panoramas{panoramaCounter},~] = extentOfScene(panoSeg);
            panoSeg ={};
            panoramaCounter = panoramaCounter+1;
        end
    end
end

for i=1: length(panoramas)
    imgPath = strcat(int2str(i), '.jpg');
    imwrite(panoramas{i}, imgPath, 'jpg');
end
