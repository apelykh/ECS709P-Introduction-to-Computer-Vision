function rot_img = ICV_rotate(img, angle)
    % calculate the size of the rotated image
    if angle < 90
        rot_h = size(img, 2) * sind(angle) + size(img, 1) * cosd(angle);
        rot_w = size(img, 2) * cosd(angle) + size(img, 1) * sind(angle);
    else
        % TODO: fix incorrect size calculation for >90 angles
        angle_ = 90 - angle;
        rot_h = size(img, 1) * sind(angle_) + size(img, 2) * cosd(angle_);
        rot_w = size(img, 1) * cosd(angle_) + size(img, 2) * sind(angle_);
    end

    rot_img = uint8(zeros(uint16(rot_h), uint16(rot_w), 3));

    inv_rot_mat = [cosd(angle),  sind(angle),    0;
                   -sind(angle), cosd(angle),    0;
                   0,            0,              1];
    
    img_cx = int16(size(img, 1) / 2);
    img_cy = int16(size(img, 2) / 2);
    rot_cx = int16(size(rot_img, 1) / 2);
    rot_cy = int16(size(rot_img, 2) / 2);

    for i = 1:size(rot_img, 1)
        for j = 1:size(rot_img, 2)
%             trans_pxl = ICV_translate_pixel(i, j, -rot_cx, -rot_cy);
%             rot_pxl = inv_rot_mat * trans_pxl;
%             trans_pxl = ICV_translate_pixel(rot_pxl(1), rot_pxl(2), img_cx, img_cy);

            t1 = ICV_get_translation_matrix(img_cx, img_cy);
            t2 = ICV_get_translation_matrix(-rot_cx, -rot_cy);
            T = t1 * inv_rot_mat * t2;
            
            trans_pxl = T * [i; j; 1];

            img_i = uint16(trans_pxl(1));
            img_j = uint16(trans_pxl(2));
            
            if img_i > 0 && img_j > 0 && img_i <= size(img, 1) && img_j <= size(img, 2)
                rot_img(uint16(i), uint16(j), :) = img(img_i, img_j, :);
            else
                rot_img(uint16(i), uint16(j), :) = [0, 0, 0];
            end
        end
    end
end


function trans_mat = ICV_get_translation_matrix(tx, ty)
    trans_mat = double([1, 0, tx;
                        0, 1, ty;
                        0, 0, 1]);
end