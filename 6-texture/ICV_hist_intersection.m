function intersection = ICV_hist_intersection(hist1, hist2)
% Compute an intersection of a pair of LBP histograms.
%
% :param hist1: first LBP histogram, a vactor [n_features x 1] where
%               n_bins is a number of discrete colour bins;
% :param hist2: second RGB histogram, a matrix of a shape [n_bins x 3]
%               where n_bins is a number of discrete colour bins;
% :param normalize: if 1, intersection is normalized by the total numer of
%                   pixels in the image. If 0 - absolute value is returned;
% :return: an array of per-channel intersections for R, G, B channels
%          respectively;

    arguments
        hist1 (1, :) double
        hist2 (1, :) double {mustBeEqualSize(hist1, hist2)}
%         normalize uint8 {mustBeZeroOrOne(normalize)} = 1
    end
    
    intersection = 0;
    for i = 1:length(hist1)
        delta_i = min(hist1(i), hist2(i));
        intersection = intersection + delta_i(1);
    end
    intersection = intersection / sum(hist1);
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