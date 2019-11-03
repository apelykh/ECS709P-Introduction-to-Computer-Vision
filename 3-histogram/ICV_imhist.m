function [hist, bins] = ICV_imhist(img, n_bins)
% Compute the colour histogram of an input image.
%
% :param img: input image;
% :param n_bins: number of discrete color bins (dimension of the x axis);
%                Value between 2 and 256;
% :return: [n_bins x 3] dimensional matrix that stores bin counts for each
%          image channel;

    arguments
        img (:, :, 3) uint8
        n_bins uint16 {mustBeGreaterThan(n_bins, 1), ...
                       mustBeLessThan(n_bins, 257)} = 256
    end
    
    r = reshape(img(:, :, 1), 1,[]);
    g = reshape(img(:, :, 2), 1,[]);
    b = reshape(img(:, :, 3), 1,[]);
    
    bins = linspace(0, 255, n_bins);
    bin_step = bins(2) - bins(1);
    hist = zeros(length(bins), 3);
    
    for i = 1:length(r)
        bin_i = ceil(r(i) / bin_step) + 1;
        hist(bin_i, 1) = hist(bin_i, 1) + 1;

        bin_i = ceil(g(i) / bin_step) + 1;
        hist(bin_i, 2) = hist(bin_i, 2) + 1;

        bin_i = ceil(b(i) / bin_step) + 1;
        hist(bin_i, 3) = hist(bin_i, 3) + 1;
    end
end