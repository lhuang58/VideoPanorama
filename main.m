%% This is the main function for assessing given video segments
% Read given video segments
video = VideoReader('./testVideoSegs/testSeg1.avi');
% Convert video to cell array
source = {};
count = 1;
while hasFrame(video)
    frame = readFrame(video);
    source{count} = frame;
    count = count + 1;
end

% Find the extent of scene
[extent, refereneFrame] = extentOfScene(source);
% Start from the referene frame as initial segment, append S with its
% nearest neighbor
threshold = 0;
alpha = 0;
leftFrame = {};

while(threshold < alpha)
    % First append two adjacent frames of initial segment
    
    % Calculate the visual distortion value
    visualError = visualQuality()
end