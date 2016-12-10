function [extent, ref] = extentOfScene(S)
% This function returns the extent of the scene given a video segment S
    [index, H_map] = refFrameDetect(S);
    ref = index;
    % Compute the size of the output panorama image
    min_row = 1;
    min_col = 1;
    max_row = 0;
    max_col = 0;

    % for each input image
    for i=1:length(H_map)
        cur_image = S{i};
        [rows,cols,~] = size(cur_image);

        % create a matrix with the coordinates of the four corners of the
        % current image
        pt_matrix = cat(3, [1,1,1]', [1,cols,1]', [rows, 1,1]', [rows,cols,1]');

        % Map each of the 4 corner's coordinates into the coordinate system of
        % the reference image
        for j=1:4
            result = H_map{i}*pt_matrix(:,:,j);

            min_row = floor(min(min_row, result(1)));
            min_col = floor(min(min_col, result(2)));
            max_row = ceil(max(max_row, result(1)));
            max_col = ceil(max(max_col, result(2))); 
        end

    end

    % Calculate output image size
    panorama_height = max_row - min_row + 1;
    panorama_width = max_col - min_col + 1;

    % Calculate offset of the upper-left corner of the reference image relative
    % to the upper-left corner of the output image
    row_offset = 1 - min_row;
    col_offset = 1 - min_col;

    % Perform inverse mapping for each input image
    for i=1:length(H_map)

        % Create a list of all pixels' coordinates in output image
        [x,y] = meshgrid(1:panorama_width, 1:panorama_height);
        % Create list of all row coordinates and column coordinates in separate
        % vectors, x and y, including offset
        x = reshape(x,1,[]) - col_offset;
        y = reshape(y,1,[]) - row_offset;

        % Create homogeneous coordinates for each pixel in output image
        pan_pts(1,:) = y;
        pan_pts(2,:) = x;
        pan_pts(3,:) = ones(1,size(pan_pts,2));

        % Perform inverse warp to compute coordinates in current input image
        image_coords = H_map{i}\pan_pts;
        row_coords = reshape(image_coords(1,:),panorama_height, panorama_width);
        col_coords = reshape(image_coords(2,:),panorama_height, panorama_width);
        % Note:  Some values will return as NaN ("not a number") because they
        % map to points outside the domain of the input image

        cur_image = im2double(S{i});

        % Bilinear interpolate color values
        curr_warped_image = zeros(panorama_height, panorama_width, 3);
        for channel = 1 : 3
            curr_warped_image(:, :, channel) = ...
                interp2(cur_image(:,:,channel), ...
                col_coords, row_coords, 'linear', 0);
        end

        % Add to output image. No blending done in this version; the current
        % image simply overwrites previous images where there is overlap.
        warped_images{i} = curr_warped_image;

    end

    %%======================================================================
    %% 5. Blend images
    %
    % Now that we've warped each input image separately and assigned them to
    % warped_images (a cell array with as many elements as the number of input
    % images), blend the input images into a single panorama.

    % Initialize output image to black (0)
    panorama_image = zeros(panorama_height, panorama_width, 3);

    %------------- YOUR CODE STARTS HERE -----------------
    %
    % Modify the code below to blend warped images together via feathering. The
    % following code adds warped images directly to panorama image. This is a
    % very bad blending method - implement feathering instead.
    %
    % Save your final output image as a .jpg file and name it according to
    % the directions in the assignment.  

    panorama_image = warped_images{1};
    for i = 2 : length(warped_images)
        panorama_image = blend(panorama_image, warped_images{i});

        %panorama_image = panorama_image + warped_images{i};
        %panorama_image = panorama_image + blended_image;

    end
    extent = panorama_image;
end

