function visualQualityDistortion = visualQuality(Si)
% This function measures the image quality by calculate the incorrectness
% of the motion and the source image quality
    % Preset variables
    alpham = 1.0;
    alphav = 1.0;
    
    visualQualityDistortion = alpham * motionModel(Si) + alphav * sourcevisualDistortion(Si);
end

function res = motionModel(Si)
% This helper function computes the incorrectness of the motion model    
    for i = 1 : size(Si, 2)
        % First convert to gray scale image
        input1 = rgb2gray(Si{i});
        input2 = rbg2gray(Si{i+1});
        % Compute SIFT features from the input frame and its forward neighbor 
        [features1, descriptors1] = vl_sift(input1);
        [features2, descriptors2] = vl_sift(input2);
        % Match the SIFT features from two inputs
        [matches, scores] = vl_ubcmatch(descriptors1, descriptors2) ;
        im1_ftr_pts = features1([2 1], matches(1, :))';
        im2_ftr_pts = features2([2 1], matches(2, :))';
        % Calculate the homography using the matched features points
        h = calcHWithRANSAC(im1_ftr_pts, im2_ftr_pts);
        
    end
end

function error = sourcevisualDistortion(Si)
% This helper function computes the total visual quality distortion from each
% frame within segment
    % Preset variables
    gamma = 0.45;
    
    for i = 1 : size(Si, 2)
        error = error + gamma * blocknessEstmtn(Si{i}) + (1 - gamma) * blurinessEstimtn(Si{i});
    end
end