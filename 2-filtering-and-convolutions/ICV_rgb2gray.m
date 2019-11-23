function gray_img = ICV_rgb2gray(img)
    arguments
        img (:, :, 3) uint8
    end

    gray_img = 0.3 * img(:, :, 1) + ...
               0.59 * img(:, :, 2) + ...
               0.11 * img(:, :, 3);
end