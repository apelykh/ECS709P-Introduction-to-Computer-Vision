function sk_img = ICV_shear(img, angle)
    orig_h = size(img, 1);
    orig_w = size(img, 2);
    sk_w = orig_w + orig_h * tand(angle);

    sk_img = uint8(zeros(uint16(orig_h), uint16(sk_w), 3));
    
    angle = 90 - angle;
    
    img_cx = int16(size(img, 1) / 2);
    img_cy = int16(size(img, 2) / 2);
    sk_cx = int16(size(sk_img, 1) / 2);
    sk_cy = int16(size(sk_img, 2) / 2);
    
    T1 = ICV_get_translation_matrix(img_cx, img_cy);
    SH = ICV_get_shear_matrix(angle);
    T2 = ICV_get_translation_matrix(-sk_cx, -sk_cy);
    T = T1 * SH * T2;
    
    for i = 1:size(sk_img, 1)
        for j = 1:size(sk_img, 2)            
            trans_pxl = T * [i; j; 1];

            img_i = uint16(trans_pxl(1));
            img_j = uint16(trans_pxl(2));

            if img_i > 0 && img_j > 0 && img_i <= size(img, 1) && img_j <= size(img, 2)
                sk_img(uint16(i), uint16(j), :) = img(img_i, img_j, :);
            else
                sk_img(uint16(i), uint16(j), :) = [152, 251, 152];
            end
        end
    end
end


function inv_sh_mat = ICV_get_shear_matrix(angle)
    inv_sh_mat = double([1, 0, 0;
                         1 / tand(angle), 1, 0;
                         0, 0, 1]);
end

function trans_mat = ICV_get_translation_matrix(tx, ty)
    trans_mat = double([1, 0, tx;
                        0, 1, ty;
                        0, 0, 1]);
end
