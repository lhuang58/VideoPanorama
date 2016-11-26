function [index, referenceFrame] = refFrameDetect(S)
% This function will return a reference from a given video segment
    for i = 1 : length(S)
        % For all the frames in given segment find the reference frame with
        % minimum coverage
        % For example [f1, f2, f3, f4, ... fn], if f1 = fr, then align all
        % other frame fi to f1. And calculate all the frames in the segment
        % choose the one whose panorama is smallest
    end
   
end

