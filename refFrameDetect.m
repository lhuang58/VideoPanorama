function referenceFrame = refFrameDetect(S)
% This function will return a reference from a given video segment
    for i = 1 : length(S)
        input_image = single(rgb2gray(S{i}));
        [keypoints{i}, descriptors{i}] = vl_sift(input_image);
    end
    % Preallocate for performance
    H_list = cell(1, length(S) - 1);
    
    for i=1:length(S)-1

        % Assign relevant data structures to variables for convenience
        descriptors1 = descriptors{i};
        descriptors2 = descriptors{i + 1};
        keypoints1 = keypoints{i};
        keypoints2 = keypoints{i + 1};

        % Find matching feature points between current two images. Note that this
        % code does NOT include the use of RANSAC to find and use only good
        % matches.
        [matches, scores] = vl_ubcmatch(descriptors1, descriptors2) ;
        im1_ftr_pts = keypoints1([2 1], matches(1, :))';
        im2_ftr_pts = keypoints2([2 1], matches(2, :))';

        % Calculate 3x3 homography matrix, H, mapping coordinates in image2
        % into coordinates in image1. Function calcHWithRANSAC currently uses all
        % pairs of matching feature points returned by the SIFT algorithm.
        % Modify the calcHWithRANSAC function to add code for implementing RANSAC.
        H_list{i} = calcHWithRANSAC(im1_ftr_pts, im2_ftr_pts);
    end
    
    frameDistances = cell(1, length(S));
    for i = 1 : length(S)
        % For all the frames in given segment find the reference frame with
        % minimum coverage
        % For example [f1, f2, f3, f4, ... fn], if f1 = fr, then align all
        % other frame fi to f1. And calculate all the frames in the segment
        % choose the one whose panorama is smallest
        H_map = calHomography(H_list, i);
        frameDistances{i} = centerDistance(H_map, S);  
    end
    % Find the smallest distance and return the index accordingly.
    referenceFrame = 0;
    minDistance = inf;
    for i = 1 : length(frameDistances)
        curDistance = frameDistances;
        if frameDistances{i} < curDistance
            minDistance = frameDistances{i};
            referenceFrame = i;
        end
    end
end

function H_map = calHomography(H_list, referenceIndex)
% This function will return a list of homography 
    % Calculate homography according to reference frame index
    H_map = {};
    % The homography for the reference frame is identity matrix
    H_map{referenceIndex} = eye(size(H_list{1}));
    
    % Recalculate the homography for frames' index before the reference
    % frame
    
    % If reference frame is at index i, then we calculate the homography
    % for frames from 1 to i by Hi-1i*Hi-2i-1*...*H23H12 where Hij is the
    % homography mapping i to j
    if referenceIndex > 1
        for i = referenceIndex : -1 : 2
            base = H_map{i};
            base = H_list{i - 1} * base;
            H_map{i - 1} = base;
        end
    end
    
    for i = referenceIndex : length(H_list)
        base = H_map{i};
        base = H_list{i} * base;
        H_map{i + 1} = base;
    end
end

function frameDistance = centerDistance(H_map, S)
% The extract the center pixel, then transform to reference frame
% coordinates
    assert(length(H_map) == length(S));
    % Obtain the size of frame
    [width, height, ~] = size(S{1});
    centerPixel = [floor(width / 2), floor(height / 2), 1]';
    % Calculate the total distance
    frameDistance = 0;
    for i = 1 : length(H_map)
        frameDistance = frameDistance + norm(centerPixel - H_map{i} * centerPixel);
    end
    % Take the average length of each frame
    frameDistance = frameDistance / length(H_map);
end