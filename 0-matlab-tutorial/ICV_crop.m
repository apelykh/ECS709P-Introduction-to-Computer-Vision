function cropped_img = ICV_crop(img, crop_size)
    validateattributes(crop_size, {'numeric'}, {'positive'});

    [h, w, d] = size(img);
    
    pad_h = floor((h - crop_size) / 2 + 1);
    pad_w = floor((w - crop_size) / 2 + 1);
    
    cropped_img = img(pad_h:pad_h + crop_size -1, ...
                      pad_w:pad_w + crop_size -1, ...
                      :);

    ICV_count_minmax(cropped_img);
end

function ICV_count_minmax(img)
    [h, w, d] = size(img);
    min_v = 255;
    max_v = -1;

    for ch = 1:d
        crop_ch = img(:, :, d);
        crop_ch_vect = crop_ch(:);

        for i = 1:length(crop_ch_vect)
            if crop_ch_vect(i) < min_v
                min_v = crop_ch_vect(i);
            elseif crop_ch_vect(i) > max_v
                max_v = crop_ch_vect(i);
            end    
        end
        
        fprintf('Channel %d: min: %d (built-in min: %d), max: %d (built-in max: %d)\n', ...
            ch, min_v, min(crop_ch_vect), max_v, max(crop_ch_vect));
    end
end