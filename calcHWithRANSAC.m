function H = calcHWithRANSAC(p1, p2)
% Returns the homography that maps p2 to p1 under RANSAC.
% Pre-conditions:
%     Both p1 and p2 are nx2 matrices where each row is a feature point.
%     p1(i, :) corresponds to p2(i, :) for i = 1, 2, ..., n
%     n >= 4
% Post-conditions:
%     Returns H, a 3 x 3 homography matrix

    assert(all(size(p1) == size(p2)));  % input matrices are of equal size
    assert(size(p1, 2) == 2);  % input matrices each have two columns
    assert(size(p1, 1) >= 4);  % input matrices each have at least 4 rows

    %------------- YOUR CODE STARTS HERE -----------------
    % 
    % The following code computes a homography matrix using all feature points
    % of p1 and p2. Modify it to compute a homography matrix using the inliers
    % of p1 and p2 as determined by RANSAC.
    %
    % Your implementation should use the helper function calcH in two
    % places - 1) finding the homography between four point-pairs within
    % the RANSAC loop, and 2) finding the homography between the inliers
    % after the RANSAC loop.

   % H = calcH(p1, p2);
    
    maxDist = 3;
    inliersCount = 0;
    for i = 1 : 100
        % First randomly select 4 pairs points from SIFT
        randIndex = randperm(size(p1, 1), 4);
        tempH = calcH(p1(randIndex, :), p2(randIndex, :));
        % First convert Pi into homogeneous coordinates
        dest = tempH * ([p2.'; ones(1, size(p2, 1))]);
        %j = bsxfun(@rdivide, dest(1: 2, :), dest(3, :));   
        dist = sqrt(sum((dest - [p1.'; ones(1, size(p1, 1))]).^2));
        tempCount = sum(dist(:) < maxDist);   
        if tempCount > inliersCount
            inliersCount = tempCount;
            inliersP1 = p1(dist(:) < maxDist, :);
            inliersP2 = p2(dist(:) < maxDist, :);    
        end
    end
    
    % Recalculate H using all the inliers
    H = calcH(inliersP1, inliersP2);
    
    %------------- YOUR CODE ENDS HERE -----------------
end

% The following function has been implemented for you.
% DO NOT MODIFY THE FOLLOWING FUNCTION
function H = calcH(p1, p2)
% Returns the homography that maps p2 to p1 in the least squares sense
% Pre-conditions:
%     Both p1 and p2 are nx2 matrices where each row is a feature point.
%     p1(i, :) corresponds to p2(i, :) for i = 1, 2, ..., n
%     n >= 4
% Post-conditions:
%     Returns H, a 3 x 3 homography matrix
    
    assert(all(size(p1) == size(p2)));
    assert(size(p1, 2) == 2);
    
    n = size(p1, 1);
    if n < 4
        error('Not enough points');
    end
    H = zeros(3, 3);  % Homography matrix to be returned

    A = zeros(n*3,9);
    b = zeros(n*3,1);
    for i=1:n
        A(3*(i-1)+1,1:3) = [p2(i,:),1];
        A(3*(i-1)+2,4:6) = [p2(i,:),1];
        A(3*(i-1)+3,7:9) = [p2(i,:),1];
        b(3*(i-1)+1:3*(i-1)+3) = [p1(i,:),1];
    end
    x = (A\b)';
    H = [x(1:3); x(4:6); x(7:9)];

end
