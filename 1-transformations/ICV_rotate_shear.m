function res_img = ICV_rotate_shear(img, rot_angle, sh_angle)
    dir = sign(rot_angle);
    rot_angle = abs(rot_angle);
    
    sh_angle = 90 - sh_angle;
    
    [res_h, res_w] = ICV_calculate_new_size(img, rot_angle, sh_angle);
    res_img = uint8(zeros(uint16(res_h), uint16(res_w), 3));
    
    img_cx = int16(size(img, 1) / 2);
    img_cy = int16(size(img, 2) / 2);
    res_cx = int16(res_h / 2);
    res_cy = int16(res_w / 2);

    t1 = ICV_get_translation_matrix(img_cx, img_cy);
    S = ICV_get_shear_matrix(sh_angle);
    R = ICV_get_rotation_matrix(rot_angle, dir);
    t2 = ICV_get_translation_matrix(-res_cx, -res_cy);
    T = t1 * S * R * t2;

    for i = 1:size(res_img, 1)
        for j = 1:size(res_img, 2)
            trans_pxl = T * [i; j; 1];
            
            % implicitly doing NN interpolation by rounding the
            % coordinates to the closest int value
            img_i = uint16(trans_pxl(1));
            img_j = uint16(trans_pxl(2));

            if img_i > 0 && img_j > 0 && img_i <= size(img, 1) && img_j <= size(img, 2)
                res_img(uint16(i), uint16(j), :) = img(img_i, img_j, :);
            else
                res_img(uint16(i), uint16(j), :) = [152, 251, 152];
            end
        end
    end
end


function [res_h, res_w] = ICV_calculate_new_size(img, rot_angle, sh_angle)
% Calculate the transformed image size.
% Idea: applying the transformation matrix to x,y coordinates of the
% original image we get all the transformed coordinates. Finding the
% distance between min and max values of each axis gives us the image size.
%
% :param img: original image
% :param rot_angle: rotation angle in degrees
% :pram sh_angle: (horizontal) shearing angle in degrees

    orig_h = size(img, 1);
    orig_w = size(img, 2);
    
    [ii,jj] = ndgrid(1:orig_h, 1:orig_w);
    orig_coords_mat = cat(3, ii, jj);
    new_coords_mat = zeros(orig_h, orig_w);
    
    dir = sign(rot_angle);
    rot_angle = abs(rot_angle);
   
    img_cx = int16(orig_h / 2);
    img_cy = int16(orig_w / 2);
    
    t1 = ICV_get_translation_matrix(img_cx, img_cy);
    R = ICV_get_rotation_matrix(rot_angle, dir);
    S = ICV_get_shear_matrix(sh_angle);
    t2 = ICV_get_translation_matrix(-img_cx, -img_cy);
    T = t1 * R * S * t2;
    
    % (:, :, 1) stores x coordinates
    new_coords_mat(:, :, 1) = orig_coords_mat(:, :, 1) * T(1, 1) + ...
                              orig_coords_mat(:, :, 2) * T(1, 2) + ...
                              1 * T(1, 3);
    % (:, :, 2) stores y coordinates
    new_coords_mat(:, :, 2) = orig_coords_mat(:, :, 1) * T(2, 1) + ...
                              orig_coords_mat(:, :, 2) * T(2, 2) + ...
                              1 * T(2, 3);
    X = new_coords_mat(:, :, 1);
    Y = new_coords_mat(:, :, 2);
    res_h = uint16(max(X(:)) - min(X(:)) + 1);
    res_w = uint16(max(Y(:)) - min(Y(:)) + 1);
end


function trans_mat = ICV_get_translation_matrix(tx, ty)
    trans_mat = double([1, 0, tx;
                        0, 1, ty;
                        0, 0, 1]);
end


function rot_mat = ICV_get_rotation_matrix(angle, dir)
    rot_mat = double([cosd(angle), dir * -sind(angle),   0;
                      dir * sind(angle), cosd(angle),    0;
                      0,                 0,              1]);
end


function sh_mat = ICV_get_shear_matrix(angle)
    sh_mat = double([1, 0, 0;
                     1 / tand(angle), 1, 0;
                     0, 0, 1]);
end
