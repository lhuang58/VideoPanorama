%% This is the unit test for visual quality measure function
sourceVideo = VideoReader('./testVideoSegs/testSeg1.avi');

% Convert the video file into a cell array
index = 1;
while hasFrame(sourceVideo)
    tempFrame = readFrame(sourceVideo);
    Seg{index} = tempFrame;
    index = index + 1;
end
visualQualityMeasure = visualQuality(Seg);

%% This is for motion error test
imagepath = 'testImages';
imagelist = dir(imagepath);
% Remove invisible Thumbs.db file that's usually in Windows machines
imagelist = imagelist(arrayfun(@(x) ~strcmp(x.name, 'Thumbs.db'), imagelist));

% Remove files that start with '.', including '.' and '..'
imagelist = imagelist(arrayfun(@(x) x.name(1) ~= '.', imagelist));
for i = 1 : length(imagelist)
    filename = fullfile(imagepath, imagelist(i).name);
    input_image = imread(filename);
    Seg{i} = input_image;
end
visualQualityMeasure = visualQuality(Seg);