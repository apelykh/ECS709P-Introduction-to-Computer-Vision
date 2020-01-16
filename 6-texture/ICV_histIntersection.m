function intersection = ICV_histIntersection(hist1, hist2)
% Compute an intersection of a pair of LBP histograms.
%
% :param hist1: first LBP histogram, a vector [n_features x 1] where
%               n_bins is a number of discrete colour bins;
% :param hist2: second LBP histogram, a vector [n_features x 1] where
%               n_bins is a number of discrete colour bins;
% :return: a scalar, intersection value;

    arguments
        hist1 (1, :) double
        hist2 (1, :) double {mustBeEqualSize(hist1, hist2)}
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