function blockness = blocknessEstmtn(I)
% This function returns the blockness measure of the given image.
% The implementation of this is based on Wang et al.(2002)
    % A set of preknown variables obtained from the paper
    alpha = -245.9;
    beta = 261.9;
    gamma1 = -0.0240;
    gamma2 = 0.0160;
    gamma3 = 0.0064;

    image = double(I);
    [m, n] = size(image);
    % First Calculate the difference in horizontal line
    d_h = image(:, 2 : n) - image(:, 1 : (n - 1));
    tempTotal = abs(d_h(:, 8 : 8 : 8 * (floor(n / 8) - 1)));
    B_h = sum(tempTotal(:)) / (m * (floor(n / 8) - 1));
    A_h = (8 * mean2(abs(d_h)) - B_h) / 7;
    sig_h = sign(d_h);
    left_sig = sig_h(:, 1:(n-2));
    right_sig = sig_h(:, 2:(n-1));
    Z_h = mean2((left_sig.*right_sig)<0);
    % Next calculate the difference in vertical
    d_v = image(2 : m, :) - image(1 : (m - 1), :);
    total_dv = abs(d_v(8 : 8 : 8 * (floor(m / 8)- 1), :));
    B_v = sum(total_dv(:)) / (n * (floor(m / 8) - 1));
    A_v = (8 * (mean2(abs(d_v))) - B_v) / 7;
    sig_v = sign(d_v);
    up_sig = sig_v(1:(m-2), :);
    down_sig = sig_v(2:(m-1), :);
    Z_v = mean2((up_sig.*down_sig)<0);
    % Calculate overrall feature
    B = (B_h + B_v) / 2;
    A = (A_h + A_v) / 2;
    Z = (Z_h + Z_v) / 2;
    blockness = alpha + beta * B.^gamma1 * A.^gamma2 * Z.^gamma3;
end


