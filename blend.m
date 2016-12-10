function [ im_blended ] = blend( im_input1, im_input2 )
%BLEND Blends two images together via feathering
% Pre-conditions:
%     `im_input1` and `im_input2` are both RGB images of the same size
%     and data type
% Post-conditions:
%     `im_blended` has the same size and data type as the input images
    
    assert(all(size(im_input1) == size(im_input2)));
    assert(size(im_input1, 3) == 3);

    im_blended = zeros(size(im_input1), 'like', im_input1);

    %------------- YOUR CODE STARTS HERE -----------------
    
    %calculate alpha first
    a1 = rgb2alpha(im_input1, 0.001);
    a2 = rgb2alpha(im_input2, 0.001);
    
    % do the same to R,G,B channels, (a1I1+a2I2)/(a1+a2)
    R1 = im_input1(:,:,1);
    R2 = im_input2(:,:,1);
    G1 = im_input1(:,:,2);
    G2 = im_input2(:,:,2);
    B1 = im_input1(:,:,3);
    B2 = im_input2(:,:,3);
    
    Rout = ((a1 .* R1 ) + (a2 .* R2))./(a1+a2);
    
    Gout = ((a1 .* G1 ) + (a2 .* G2))./(a1+a2);
    
    Bout = ((a1 .* B1 ) + (a2 .* B2))./(a1+a2);
    
    %merge to final rgb
    im_blended = cat(3,Rout,Gout,Bout);
    %------------- YOUR CODE ENDS HERE -----------------

end

function im_alpha = rgb2alpha(im_input, epsilon)
% Returns the alpha channel of an RGB image.
% Pre-conditions:
%     im_input is an RGB image.
% Post-conditions:
%     im_alpha has the same size as im_input. Its intensity is between
%     epsilon and 1, inclusive.

    if nargin < 2
        epsilon = 0.001;
    end
    
    %------------- YOUR CODE STARTS HERE -----------------
    
    [row, col,~] = size(im_input);
    im_binary = ones(row, col);
    for r = 1: row
        for c = 1: col
            if im_input(r,c,1) ~= 0 || im_input(r,c,2) ~= 0 || im_input(r,c,2) ~= 0
                im_binary(r,c) = 0;
            end
        end
    end
    
    
    [distance, ~] = bwdist(im_binary, 'euclidean');
    min1 = min(distance(:));
    max1 = max(distance(:));
    min2 = epsilon;
    max2 = 1;
    % x in range(min1,max1),y in range(min2,max2), 
    % y = (x-min1)*(max2-min2)/(max1-min1)+min2, here y is alpha, x is
    % distance
    im_alpha = (distance - min1) .* (max2 - min2) ./ (max1-min2) + min2;
    
    %------------- YOUR CODE ENDS HERE -----------------

end
