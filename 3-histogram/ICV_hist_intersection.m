function [i_r, i_g, i_b] = ICV_hist_intersection(hist1, hist2, normalize)
% Compute an intersection of a pair of RGB histograms.
%
% :param hist1: first RGB histogram, a matrix of a shape [n_bins x 3] where
%               n_bins is a number of discrete colour bins;
% :param hist2: second RGB histogram, a matrix of a shape [n_bins x 3]
%               where n_bins is a number of discrete colour bins;
% :param normalize: if 1, intersection is normalized by the total numer of
%                   pixels in the image. If 0 - absolute value is returned;
% :return: an array of per-channel intersections for R, G, B channels
%          respectively;

    arguments
        hist1 (:, 3) int32
        hist2 (:, 3) int32 {mustBeEqualSize(hist1, hist2)}
        normalize uint8 {mustBeZeroOrOne(normalize)} = 1
    end

    i_r = 0; i_g = 0; i_b = 0;
    total_num_pixels = sum(hist2);
    
    for i = 1:length(hist1)
        delta_i = min(hist1(i, :), hist2(i, :));
        i_r = i_r + delta_i(1);
        i_g = i_g + delta_i(2);
        i_b = i_b + delta_i(3);
    end
    
    if normalize == 1
        i_r = double(i_r) / total_num_pixels(1);
        i_g = double(i_g) / total_num_pixels(1);
        i_b = double(i_b) / total_num_pixels(1);
    end
end


% Custom validation function
function mustBeEqualSize(a, b)
    if ~isequal(size(a),size(b))
        error('Size of first input must equal size of second input')
    end
end


% Custom validation function
function mustBeZeroOrOne(arg)
    if arg ~= 1 && arg ~= 0
        error('Order should be either 0 or 1');
    end
end