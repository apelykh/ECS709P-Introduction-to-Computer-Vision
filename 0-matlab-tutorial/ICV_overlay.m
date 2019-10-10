function res_img = ICV_overlay(background_img, foreground_img)
    [b_h, b_w, b_d] = size(background_img);
    [f_h, f_w, f_d] = size(foreground_img);
    
    if f_h > b_h || f_w > b_w
       error('Foreground image must be smaller than background one'); 
    end
    
    res_img = background_img;

    pad_h = floor((b_h - f_h) / 2 + 1);
    pad_w = floor((b_w - f_w) / 2 + 1);
    % Boolean mask of the background image size
    fullsize_mask = uint8(zeros(b_h, b_w));

    for ch = 1:b_d
        % Boolean mask of the foreground image size. Dark pixels will be 1
        mask = foreground_img(:, :, ch) < 50;
        % Replace values of the big mask with ones from the small mask
        fullsize_mask(pad_h:pad_h + f_h - 1, ...
                      pad_w:pad_w + f_w - 1) = mask;

        res_img(:, :, ch) = uint8(background_img(:, :, ch) .* uint8(~fullsize_mask));
    end
end