%% Create video object for test videos
% Extract all the frame from test video
video = VideoReader('./testVideoSegs/longSeg.mp4');
count = 1;
filePath = './longSeg';
if 7 ~= exist(filePath, 'dir')
    mkdir(filePath); 
end
type = '.jpg';
while hasFrame(video)
    frame = readFrame(video);
    fileName = strcat(filePath, '/', int2str(int64(count)), type);
    imwrite(frame, fileName);
    count = count + 1;
end
%% Convert image sequence into video
workingDir = 'testSeg1';
sourceVideo = VideoReader('testVideo1.mp4');
% Create a new test segment

imageNames = dir(fullfile('testImages','*.jpg'));
imageNames = {imageNames.name}';

outputVideo = VideoWriter(fullfile(workingDir,'shuttle_out.mp4'));
outputVideo.FrameRate = sourceVideo.FrameRate;
open(outputVideo)

for ii = 1:length(imageNames)
   img = imread(fullfile('testImages',imageNames{ii}));
   writeVideo(outputVideo,img)
end

close(outputVideo);
