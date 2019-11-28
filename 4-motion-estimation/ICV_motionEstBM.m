function [motion_field, predicted_frame] = ICV_motionEstBM(prev_frame, ...
                                        cur_frame, block_size, window_size)
    arguments
        prev_frame (:, :) uint8
        cur_frame (:, :) uint8 {mustBeEqualSize(prev_frame, cur_frame)}
        block_size uint16 {mustBeGreaterThan(block_size, 0), ...
                           mustBeEven(block_size), ...
                           mustEvenlyDivideSize(block_size, cur_frame)}
        window_size uint16 {mustBeGreaterThanOrEqual(window_size, block_size)}
    end
    
    % store the value in a separate variable for convenience
    bh = block_size / 2;
    
    % populte arrays with x and y coordinates of block centers
    [xc_coords, yc_coords] = meshgrid(bh:block_size:size(cur_frame, 2) - bh, ...
                                      bh:block_size:size(cur_frame, 1) - bh);
    x_len = double(zeros(size(xc_coords)));
    y_len = double(zeros(size(yc_coords)));

    % iterate through all the block centers
    for ci = bh:block_size:size(prev_frame, 1) - bh
        for cj = bh:block_size:size(prev_frame, 2) - bh
            block = prev_frame((ci - bh + 1):ci + bh, ...
                               (cj - bh + 1):cj + bh);
            [match_ci, match_cj] = ICV_matchBlock(block, [ci, cj], ...
                                                  cur_frame, window_size);
            
            % indices of the curret block
            block_i = ceil(ci / block_size);
            block_j = ceil(cj / block_size);
            % x and y vector length components are corresponding
            % displacements between current and matched blocks
            y_len(block_i, block_j) = double(match_ci) - double(ci);
            x_len(block_i, block_j) = double(match_cj) - double(cj);
        end
    end
    
    motion_field = [xc_coords, yc_coords, x_len, y_len];
    predicted_frame = cur_frame;

%     imshow(cur_frame);
%     hold on
%     quiver(xc_coords, yc_coords, x_len, y_len, 1);
%     hold off
end


function [match_i, match_j] = ICV_matchBlock(ref_block, block_center, frame, window_size)
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
                % translate the coordinates of the matched block from window coordinate
                % system to the absolute (frame) one
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