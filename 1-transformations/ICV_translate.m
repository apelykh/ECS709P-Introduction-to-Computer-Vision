function trans_img = ICV_translate(img, tx, ty)
    trans_img = uint8(zeros(size(img)));

    trans_mat = [1, 0, tx;
                 0, 1, ty;
                 0, 0, 1];
                 
    for i = 1:size(trans_img, 1)
        for j = 1:size(trans_img, 2)
            img_coords = trans_mat * [i; j; 1];
            
            img_i = uint16(img_coords(1));
            img_j = uint16(img_coords(2));
            
            if img_i > 0 && img_j > 0 && img_i <= size(img, 1) && img_j <= size(img, 2)
                trans_img(uint16(i), uint16(j), :) = img(img_i, img_j, :);
            else
                trans_img(uint16(i), uint16(j), :) = [0, 0, 0];
            end
        end
    end
end