function extent = extentOfScene(S)
% This function returns the extent of the scene given a video segment S
    [index, ref] = refFrameDetect(S);
    
    % TODO: Perform a polygon clipping method, or a panorama warping method
    % with reference frame ref
end

