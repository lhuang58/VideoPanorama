%% This is the unit test for visual quality measure function
sourceVideo = VideoReader('testSeg1.avi');

% Convert the video file into a cell array
index = 1;
while hasFrame(sourceVideo)
    tempFrame = readFrame(sourceVideo);
    Seg{index} = tempFrame;
    index = index + 1;
end

visualQualityMeasure = visualQuality(Seg);