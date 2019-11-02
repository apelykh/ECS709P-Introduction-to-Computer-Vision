function res_img = ICV_rotate_skew(img, rot_angle, skew_angle, order)
% Rotate the input image by the angle rot_angle and skew by skew_angle.
%
% :param img: original image;
% :param rot_angle: rotation angle in degrees; values limited between -180
%                   and 180;
% :pram skew_angle: (horizontal) skewing angle in degrees; values limited
%                   between -85 and 85 for appropriate computation time;
% :param order: if 1, the right order of operations is used,
%               if -1 - inverse;
    arguments
        img uint8
        rot_angle double {mustBeGreaterThan(rot_angle, -181), ...
                          mustBeLessThan(rot_angle, 181)}
        skew_angle double {mustBeGreaterThan(skew_angle, -86), ...
                           mustBeLessThan(skew_angle, 86)}
        order int8 {absMustBeOne(order)} = 1
    end

    dir = sign(rot_angle);
    rot_angle = abs(rot_angle);
    skew_angle = 90 - skew_angle;
    
    [res_h, res_w] = ICV_calculate_new_size(img, rot_angle, skew_angle, order);
    res_img = uint8(zeros(uint16(res_h), uint16(res_w), 3));
    
    img_cx = int16(size(img, 1) / 2);
    img_cy = int16(size(img, 2) / 2);
    res_cx = int16(res_h / 2);
    res_cy = int16(res_w / 2);

    t1 = ICV_get_translation_matrix(img_cx, img_cy);
    S = ICV_get_skew_matrix(skew_angle);
    R = ICV_get_rotation_matrix(rot_angle, dir);
    t2 = ICV_get_translation_matrix(-res_cx, -res_cy);

    % choose the order of the operations based on the input parameter
    if order == 1; t = R * S; elseif order == -1; t = S * R; end
    T = t1 * t * t2;

    for i = 1:size(res_img, 1)
        for j = 1:size(res_img, 2)
            trans_pxl = T * [i; j; 1];
            
            % implicitly doing NN interpolation by rounding the
            % coordinates to the closest integer value
            img_i = round(trans_pxl(1));
            img_j = round(trans_pxl(2));

            if img_i > 0 && img_j > 0 && img_i <= size(img, 1) && img_j <= size(img, 2)
                res_img(uint16(i), uint16(j), :) = img(img_i, img_j, :);
            else
                res_img(uint16(i), uint16(j), :) = [152, 251, 152];
            end
        end
    end
end


function [res_h, res_w] = ICV_calculate_new_size(img, rot_angle, ...
                                                 skew_angle, order)
% Calculate the transformed image size.
% Idea: by applying the transformation matrix to x,y coordinates of the
% original image, we get all the transformed coordinates. Finding the
% distance between min and max values of each axis gives us the image size.
%
% :param img: original image;
% :param rot_angle: rotation angle in degrees;
% :pram skew_angle: (horizontal) skweing angle in degrees;
% :param order: if 1, the right order of operations is used,
%               if -1 - inverse;

    orig_h = size(img, 1);
    orig_w = size(img, 2);
    
    [ii, jj] = ndgrid(1:orig_h, 1:orig_w);
    % contains x coordinates of the original image pixels in the first
    % "channel" and y coordinates in the second
    orig_coords_mat = cat(3, ii, jj);
    new_coords_mat = zeros(orig_h, orig_w);
    
    dir = sign(rot_angle);
    rot_angle = abs(rot_angle);

    R = ICV_get_rotation_matrix(rot_angle, dir);
    S = ICV_get_skew_matrix(skew_angle);

    % transformation matrix does not include translations as they do not
    % influence the coordinates range;
    % transformation matrices follow the forward mapping scheme to map the
    % pixels from input space to the output space
    if order == 1; T = S * R; elseif order == -1; T = R * S; end
    
    % (:, :, 1) stores x coordinates of the transformed image,
    % (:, :, 2) - y coordinates
    new_coords_mat(:, :, 1) = orig_coords_mat(:, :, 1) * T(1, 1) + ...
                              orig_coords_mat(:, :, 2) * T(1, 2) + ...
                              1 * T(1, 3);
    new_coords_mat(:, :, 2) = orig_coords_mat(:, :, 1) * T(2, 1) + ...
                              orig_coords_mat(:, :, 2) * T(2, 2) + ...
                              1 * T(2, 3);
    X = new_coords_mat(:, :, 1);
    Y = new_coords_mat(:, :, 2);
    % height and width of the transformed image is the distance between
    % min and max x and y coordinates correspondingly
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


function skew_mat = ICV_get_skew_matrix(angle)
    skew_mat = double([1, 0, 0;
                       1 / tand(angle), 1, 0;
                       0, 0, 1]);
end


% Custom validation function
function absMustBeOne(arg)
    if abs(arg) ~= 1
        error('Order should be either 1 or -1');
    end
end
