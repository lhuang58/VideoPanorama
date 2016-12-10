function visualQualityDistortion = visualQuality(S)
% This function measures the image quality by calculate the incorrectness
% of the motion and the source image quality
    % Preset variables
    alpham = 1.0;
    alphav = 1.0;
    
    visualQualityDistortion = alpham * motionModel(S) + alphav * sourceVisualDistortion(S);
end

function distortionError = motionModel(S)
% This helper function computes the incorrectness of the motion model
    distortionError = 0;
    for i = 1 : (length(S) - 1)
        % First convert to gray scale image
        input1 = single(rgb2gray(S{i}));
        input2 = single(rgb2gray(S{i+1}));
        % Compute SIFT features from the input frame and its forward neighbor 
        [features1, descriptors1] = vl_sift(input1);
        [features2, descriptors2] = vl_sift(input2);
        % Match the SIFT features from two inputs
        [matches, scores] = vl_ubcmatch(descriptors1, descriptors2);
        im1_ftr_pts = features1([2 1], matches(1, :))';
        im2_ftr_pts = features2([2 1], matches(2, :))';
        numPts = size(im1_ftr_pts, 1);
        % Calculate the homography using the matched features points
        h = calcHWithRANSAC(im1_ftr_pts, im2_ftr_pts);
        if sum(h(:)) == 0
            distortionError = inf;
            return;
        end
        % Calculate mvh(pj,k)
        totalMvh = h * [im2_ftr_pts.'; ones(1, numPts)];
        % TODO: Compute the displacement between two SIFT feature points
        % Convert im_ftr_pts2 to image 1
        dist = sqrt(sum((totalMvh - [im1_ftr_pts.'; ones(1, size(im1_ftr_pts, 1))]).^2));
        % Compute visual quality distortion for frame k
        distortionError = distortionError + sum(dist(:)) / numPts;
    end
end

function error = sourceVisualDistortion(S)
% This helper function computes the total visual quality distortion from each
% frame within segment
    % Preset variables
    gamma = 0.45;
    error = 0;
    for i = 1 : length(S)
        % The blockiness from the paper is in [1, 10] 1 is worst, 10 is
        % best, here we might need take the reciprocal of the score to
        % obtain what Lui et al. suggests
        error = error + gamma * blocknessEstmtn(S{i}) + (1 - gamma) * blurinessEstimtn(S{i});
    end
end