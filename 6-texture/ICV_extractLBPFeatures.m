function global_LBP_hist = ICV_extractLBPFeatures(image, window_size)
    arguments
        image (:, :, 1) uint8
        window_size uint16 {mustEvenlyDivideSize(window_size, image)}
    end
    
    num_windows = (size(image, 1) / window_size) ^ 2;
    % pre-allocate the global image descriptor array, that will contain
    % concatenated histograms of all the windows
    global_LBP_hist = zeros(1, num_windows * 256);
    
    win_i = 0;
    for i = 1:window_size:size(image, 1) - window_size + 1
        for j = 1:window_size:size(image, 2) - window_size + 1
            window = image(i:i + window_size - 1, j:j + window_size - 1);
            window_padded = ICV_padarray(window, 1, 0);
            window_LBP_hist = ICV_extractLBPFeaturesWindow(window_padded, window_size);
            global_LBP_hist(win_i * 256 + 1:(win_i + 1) * 256) = window_LBP_hist;
            win_i = win_i + 1;
        end
    end
%     bar(global_LBP_hist);
end


function LBP_hist = ICV_extractLBPFeaturesWindow(window, window_size)
    LBP_hist = zeros(256, 1);
    LBP_matr = uint8(zeros(size(window)));
%     imshow(window);

    for i = 2:size(window, 1) - 1
        for j = 2:size(window, 2) - 1
            LBP_string = '';
            % computing LBP values for 8 pixel neighbours
            val = uint8(window(i - 1, j - 1) > window(i, j));
            LBP_string = strcat(string(val), LBP_string);
            val = uint8(window(i, j - 1) > window(i, j));
            LBP_string = strcat(string(val), LBP_string);
            val = uint8(window(i + 1, j - 1) > window(i, j));
            LBP_string = strcat(string(val), LBP_string);
            val = uint8(window(i + 1, j) > window(i, j));
            LBP_string = strcat(string(val), LBP_string);
            val = uint8(window(i + 1, j + 1) > window(i, j));
            LBP_string = strcat(string(val), LBP_string);
            val = uint8(window(i, j + 1) > window(i, j));
            LBP_string = strcat(string(val), LBP_string);
            val = uint8(window(i - 1, j + 1) > window(i, j));
            LBP_string = strcat(string(val), LBP_string);
            val = uint8(window(i - 1, j) > window(i, j));
            LBP_string = strcat(string(val), LBP_string);
            
            % min LBP value = 0, max = 255. Adding 1 to ensure proper
            % array indexing
            LBP_val = uint16(ICV_bin2dec(LBP_string) + 1);
            LBP_matr(i, j) = LBP_val;
            LBP_hist(LBP_val) = LBP_hist(LBP_val) + 1;
        end
    end
%     imshow(LBP_matr);
    
    % normalize the histogram
    LBP_hist = LBP_hist ./ double(window_size * window_size);
%     bar(LBP_hist);
end


% Custom validation function that requires size(b) to be evenly
% divided by a
function mustEvenlyDivideSize(a, b)
    if mod(size(b, 1), a) ~= 0 || mod(size(b, 2), a) ~= 0
        error('Frame size should be divisible by the block size')
    end
end