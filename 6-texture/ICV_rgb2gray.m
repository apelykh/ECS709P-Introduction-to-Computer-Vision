function gray_img = ICV_rgb2gray(img, to_save)
    gray_img = 0.3 * img(:, :, 1) + ...
               0.59 * img(:, :, 2) + ...
               0.11 * img(:, :, 3);
    
    if to_save
       imwrite(gray_img, fullfile('images', 'grayscale.png')) 
    end
end