%% Create video object for test videos
% Extract all the frame from test video
video = VideoReader('testVideo1.mp4');
count = 1;
filePath = './testVideo1';
if 7 ~= exist(filePath, 'dir')
    mkdir(filePath); 
end
type = '.jpg';
while hasFrame(video)
    frame = readFrame(video);
    imwrite(frame, fileName);
    count = count + 1;
    fileName = strcat(filePath, '/', int2str(int64(count)), type);
end
%% Convert image sequence into video
workingDir = 'testSeg1';
sourceVideo = VideoReader('testVideo1.mp4');
% Create a new test segment

imageNames = dir(fullfile('testSeg1','*.jpg'));
imageNames = {imageNames.name}';

outputVideo = VideoWriter(fullfile(workingDir,'shuttle_out.mp4'));
outputVideo.FrameRate = sourceVideo.FrameRate;
open(outputVideo)

for ii = 1:length(imageNames)
   img = imread(fullfile('testSeg1',imageNames{ii}));
   writeVideo(outputVideo,img)
end

close(outputVideo);
