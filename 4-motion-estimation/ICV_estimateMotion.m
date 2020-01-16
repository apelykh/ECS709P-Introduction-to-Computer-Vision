function [motion_field, predicted_frame] = ICV_estimateMotion(prev_frame, ...
                                        cur_frame, block_size, window_size)
% Full-search block matching algorithm for mostion estimation.
%
% :param prev_frame: previous frame of the sequence (grayscale or rgb);
% :param cur_frame: current frame of the sequence (grayscale or rgb);
% :param block_size: size of the block for which we extimate motion vector;
% :param window_size: size of the window on a pervious frame to look for
%                     matching blocks;
% :return: 1) motion field of shape (4, frame_heigh / block_size, ...
%          frame_width / block_size), where (1, :, :), (2, :, :) - x and y
%          coordinates of motion vector centers,
%          (3, :, :), (4, :, :) - x and y length components of motion
%          vectors correspondingly;
%          2) predicted frame with displaced blocks;

    arguments
        prev_frame (:, :, :) uint8
        cur_frame (:, :, :) uint8 {mustBeEqualSize(prev_frame, cur_frame)}
        block_size uint16 {mustBeGreaterThan(block_size, 0), ...
                           mustBeEven(block_size), ...
                           mustEvenlyDivideSize(block_size, cur_frame)}
        window_size uint16 {mustBeGreaterThanOrEqual(window_size, block_size)}
    end
    
    if size(prev_frame, 3) == 3
        prev_frame_gray = ICV_rgb2gray(prev_frame, false);
        cur_frame_gray = ICV_rgb2gray(cur_frame, false);
    elseif size(prev_frame, 3) == 1
        prev_frame_gray = prev_frame;
        cur_frame_gray = cur_frame;
    end
    
    % store the value in a separate variable for convenience
    bh = block_size / 2;

    mf_height = size(prev_frame_gray, 1) / block_size;
    mf_width = size(prev_frame_gray, 2) / block_size;
    motion_field = zeros(4, mf_height, mf_width);
    
    % x and y coordinates of motion vector centers
    [motion_field(1, :, :), motion_field(2, :, :)] = ...
        meshgrid(bh:block_size:size(cur_frame_gray, 2) - bh, ...
                 bh:block_size:size(cur_frame_gray, 1) - bh);
    % x length components of motion vectors
    motion_field(3, :, :) = double(zeros(mf_height, mf_width));
    % y length components of motion vectors
    motion_field(4, :, :) = double(zeros(mf_height, mf_width));
    
    % iterate through all the block centers
    for ci = bh:block_size:size(prev_frame_gray, 1) - bh
        for cj = bh:block_size:size(prev_frame_gray, 2) - bh
            block = prev_frame_gray((ci - bh + 1):ci + bh, ...
                                    (cj - bh + 1):cj + bh);
            [match_ci, match_cj] = ICV_matchBlock(block, [ci, cj], ...
                                                  cur_frame_gray, window_size);
            % indices of the curret block
            block_i = ceil(ci / block_size);
            block_j = ceil(cj / block_size);
            % x and y vector length components are corresponding
            % displacements between current and matched blocks
            motion_field(3, block_i, block_j) = double(match_cj) - double(cj);
            motion_field(4, block_i, block_j) = double(match_ci) - double(ci);
        end
    end
    predicted_frame = ICV_predictFrame(prev_frame, motion_field, block_size);
end


function predicted_frame = ICV_predictFrame(prev_frame, motion_field, ...
                                            block_size)
    bh = block_size / 2;
    predicted_frame = prev_frame;
    
    % iterate through all the motion vectors
    for block_i = 1:size(motion_field, 2)
        for block_j = 1:size(motion_field, 3)
            x_len = motion_field(3, block_i, block_j);
            y_len = motion_field(4, block_i, block_j);
            
            if x_len == 0 || y_len == 0
                continue
            end
            
            cx = motion_field(1, block_i, block_j);
            cy = motion_field(2, block_i, block_j);
            % take the corresponding block from the previous frame
            block = prev_frame((cy - bh + 1):cy + bh, ...
                               (cx - bh + 1):cx + bh, :);
            
            t_cx = cx + x_len;
            t_cy = cy + y_len;
            % displace the block by the lenghts of each component of the
            % corresponding motion vector
            predicted_frame((t_cy - bh + 1):t_cy + bh, ...
                            (t_cx - bh + 1):t_cx + bh, :) = block;
        end
    end
end


function [match_i, match_j] = ICV_matchBlock(ref_block, block_center, ...
                                             frame, window_size)
    arguments
        ref_block (:, :) uint8
        block_center (1, 2) uint16
        frame (:, :) uint8
        window_size uint16 {mustBeGreaterThan(window_size, 0)}
    end

    block_size = size(ref_block, 1);
    
    % calculate the coordinates of the search window in the absolute (frame)
    % coordinate system
    wh = window_size / 2;
    window_from_h = max(block_center(1) - wh + 1, 1);
    window_to_h = min(block_center(1) + wh, size(frame, 1));
    window_from_w = max(block_center(2) - wh + 1, 1);
    window_to_w = min(block_center(2) + wh, size(frame, 2));

    search_window = frame(window_from_h:window_to_h, ...
                          window_from_w:window_to_w);

    min_error = 10 ^ 5;
    match_i = -1;
    match_j = -1;

    for i = 1:size(search_window, 1) - block_size + 1
        for j = 1:size(search_window, 2) - block_size + 1
            block = search_window(i:i + block_size - 1, ...
                                  j:j + block_size - 1);
            error = ICV_computeError(ref_block, block);
            
            if error < min_error
                min_error = error;
                % translate the coordinates of the matched block from
                % window coordinate system to the absolute (frame) one
                match_i = i + window_from_h - 2 + (block_size / 2);
                match_j = j + window_from_w - 2 + (block_size / 2);
            end
        end
    end
end


function error = ICV_computeError(ref_block, block)
    arguments
        ref_block (:, :) uint8
        block (:, :) uint8 {mustBeEqualSize(ref_block, block)}
    end
    
    % calcultaing MSE
    diff = (double(ref_block) - double(block)) .^ 2;
    num_elem = size(ref_block, 1) * size(ref_block, 2);
    error = sum(diff, 'all') / num_elem;
end


% -------------------------------------------------------------------------
% Custom validation functions
% -------------------------------------------------------------------------
function mustBeEqualSize(a, b)
    if ~isequal(size(a), size(b))
        error('Sizes of both frames should be equal')
    end
end


function mustBeEven(arg)
    if mod(arg, 2) ~= 0
       error('Block size must be even'); 
    end
end


% size(b) should be evenly divided by a
function mustEvenlyDivideSize(a, b)
    if mod(size(b, 1), a) ~= 0 || mod(size(b, 2), a) ~= 0
        error('Frame size should be divisible by the block size')
    end
end