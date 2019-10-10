function rot_img = ICV_rotate(img, angle)
    dir = sign(angle);
    angle = abs(angle);

    % calculate the size of the rotated image
    if angle < 90
        rot_w = size(img, 2) * cosd(angle) + size(img, 1) * sind(angle);
        rot_h = size(img, 2) * sind(angle) + size(img, 1) * cosd(angle);
    else
        angle_ = angle - 90;
        rot_w = size(img, 1) * cosd(angle_) + size(img, 2) * sind(angle_);
        rot_h = size(img, 1) * sind(angle_) + size(img, 2) * cosd(angle_);
    end

    rot_img = uint8(zeros(uint16(rot_h), uint16(rot_w), 3));
    
    img_cx = int16(size(img, 1) / 2);
    img_cy = int16(size(img, 2) / 2);
    rot_cx = int16(size(rot_img, 1) / 2);
    rot_cy = int16(size(rot_img, 2) / 2);
    
    T1 = ICV_get_translation_matrix(img_cx, img_cy);
    IR = ICV_get_rotation_matrix(angle, dir);
    T2 = ICV_get_translation_matrix(-rot_cx, -rot_cy);
    T = T1 * IR * T2;

    for i = 1:size(rot_img, 1)
        for j = 1:size(rot_img, 2)            
            trans_pxl = T * [i; j; 1];
            
            % implicitly doing NN interpolation by rounding the
            % coordinates to the closest int value
            img_i = uint16(trans_pxl(1));
            img_j = uint16(trans_pxl(2));

            if img_i > 0 && img_j > 0 && img_i <= size(img, 1) && img_j <= size(img, 2)
                rot_img(uint16(i), uint16(j), :) = img(img_i, img_j, :);
            else
                rot_img(uint16(i), uint16(j), :) = [152, 251, 152];
            end
        end
    end
end


function inv_rot_mat = ICV_get_rotation_matrix(angle, dir)
    inv_rot_mat = double([cosd(angle),  dir * -sind(angle),    0;
                          dir * sind(angle), cosd(angle),    0;
                          0,            0,              1]);
end


function trans_mat = ICV_get_translation_matrix(tx, ty)
    trans_mat = double([1, 0, tx;
                        0, 1, ty;
                        0, 0, 1]);
end
