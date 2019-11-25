function ICV_motionEstBM(prev_frame, cur_frame, block_size, search_window, i)
    arguments
        prev_frame (:, :, 1) uint8
        cur_frame (:, :, 1) uint8 {mustBeEqualSize(prev_frame, cur_frame)}
        block_size uint16 {mustBeGreaterThan(block_size, 0), ...
                           mustBeEven(block_size), ...
                           mustEvenlyDivideSize(block_size, cur_frame)}
        search_window uint16 {mustBeGreaterThan(search_window, block_size)}
        i
    end
    
    x_coords = zeros(size(cur_frame, 1), size(cur_frame, 2));
    y_coords = zeros(size(cur_frame, 1), size(cur_frame, 2));
    x_len = zeros(size(cur_frame, 1), size(cur_frame, 2));
    y_len = zeros(size(cur_frame, 1), size(cur_frame, 2));
    
    for i = 1:block_size:size(prev_frame, 1) - block_size + 1
        for j = 1:block_size:size(prev_frame, 2) - block_size + 1
            block = prev_frame(i:i + block_size - 1, j:j + block_size - 1, :);
%             imshow(block);
            
            center_abs_h = i + (block_size / 2);
            center_abs_w = j + (block_size / 2);
            y_coords(center_abs_h, center_abs_w) = center_abs_h;
            x_coords(center_abs_h, center_abs_w) = center_abs_w;
            
            [match_i, match_j] = ICV_matchBlock(block, [center_abs_h, center_abs_w], cur_frame, search_window);
            
            match_center_abs_h = match_i + (block_size / 2);
            match_center_abs_w = match_j + (block_size / 2);
            y_len(center_abs_h, center_abs_w) = match_center_abs_h - center_abs_h;
            x_len(center_abs_h, center_abs_w) = match_center_abs_w - center_abs_w;
            
%             imshow(prev_frame(match_i:match_i + block_size - 1, match_j:match_j + block_size - 1, :));
        end
    end
    
    quiver(x_coords, y_coords, x_len, y_len, double(block_size));
    saveas(gcf, sprintf('motion_%d.png', i));
end


function [match_i, match_j] = ICV_matchBlock(ref_block, center_abs, frame, window_size)
    block_size = size(ref_block, 1);
    
    % calculate the coordinates of the search window in the absolute (frame)
    % coordinate system
    window_from_h = max(center_abs(1) - (window_size / 2), 1);
    window_to_h = min(center_abs(1) + (window_size / 2), size(frame, 1));
    window_from_w = max(center_abs(2) - (window_size / 2), 1);
    window_to_w = min(center_abs(2) + (window_size / 2), size(frame, 2));

    search_window = frame(window_from_h:window_to_h, window_from_w:window_to_w, :);

    min_error = 10 ^ 5;
    matched_block_i = -1;
    matched_block_j = -1;

    for i = 1:size(search_window, 1) - block_size + 1
        for j = 1:size(search_window, 2) - block_size + 1
            block = search_window(i:i + block_size - 1, j:j + block_size - 1, :);
            error = ICV_computeError(ref_block, block);
            
            if error < min_error
                min_error = error;
                matched_block_i = i;
                matched_block_j = j;
            end
        end
    end
    
    % translate the coordinates of the matched block from window coordinate
    % system to the absolute (frame) one
    match_i = matched_block_i + window_from_h;
    match_j = matched_block_j + window_from_w;
end


function error = ICV_computeError(ref_block, block)
    arguments
        ref_block (:, :) uint8
        block (:, :) uint8 {mustBeEqualSize(ref_block, block)}
    end
    
    % calcultaing MSE
    diff = (ref_block - block) .^ 2;
    num_elem = size(ref_block, 1) * size(ref_block, 2);
    error = sum(diff, 'all') / num_elem;
end

% Custom validation function
function mustBeEqualSize(a, b)
    if ~isequal(size(a), size(b))
        error('Sizes of both frames should be equal')
    end
end


% Custom validation function
function mustBeEven(arg)
    if mod(arg, 2) ~= 0
       error('Block size must be even'); 
    end
end


% Custom validation function that requires size(b) to be evenly
% divided by a
function mustEvenlyDivideSize(a, b)
    if mod(size(b, 1), a) ~= 0 || mod(size(b, 2), a) ~= 0
        error('Frame size should be divisible by the block size')
    end
end