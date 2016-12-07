%% refFrameDetect unit test

% First read a test segment
testSeg = VideoReader('./testVideoSegs/testSeg2.avi');

% Convert the video into cell array
segment = {};
count = 1;
while hasFrame(testSeg)
    frame = readFrame(testSeg);
    segment{count} = frame;
    count = count + 1;
end

refeIndex = refFrameDetect(segment)