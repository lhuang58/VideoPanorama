% Create video object for test videos
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

% Create a new test segment
li = 1206;
imageNames = dir(fullfile(workingDir,'images','*.jpg'));
imageNames = {imageNames.name}';