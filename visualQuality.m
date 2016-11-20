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
    for i = 1 : (Size(S, 2) - 1)
        % First convert to gray scale image
        input1 = rgb2gray(S{i});
        input2 = rbg2gray(S{i+1});
        % Compute SFT features from the input frame and its forward neighbor 
        [features1, descriptors1] = vl_Sift(input1);
        [features2, descriptors2] = vl_Sift(input2);
        % Match the SFT features from two inputs
        [matches, scores] = vl_ubcmatch(descriptors1, descriptors2);
        im1_ftr_pts = features1([2 1], matches(1, :))';
        im2_ftr_pts = features2([2 1], matches(2, :))';
        numPts = size(im1_ftr_pts, 1);
        % Calculate the homography uSng the matched features points
        h = calcHWithRANSAC(im1_ftr_pts, im2_ftr_pts);
        % Calculate mvh(pj,k)
        totalMvh = sum(abs(h * [im1_ftr_pts.'; ones(1, numPts)]));
        
        % TODO: calculate motion vector for each feature points in frame
        % Convert to form [mv1, mv2, mv3, ...] [1, n] vectors
        motionVector = 0;
        
        % Compute visual quality distortion for frame k
        distortionError = distortionError + (totalMvh + motionVector) / numPts;
    end
end

function error = sourceVisualDistortion(S)
% This helper function computes the total visual quality distortion from each
% frame within segment
    % Preset variables
    gamma = 0.45;
    
    for i = 1 : Size(S, 2)
        error = error + gamma * blocknessEstmtn(S{i}) + (1 - gamma) * blurinessEstimtn(S{i});
    end
end