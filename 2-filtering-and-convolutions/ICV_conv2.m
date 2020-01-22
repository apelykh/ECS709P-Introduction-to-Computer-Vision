function res = ICV_conv2(image, kernel)
    arguments
        image (:, :, 1) uint8
        kernel {mustBeNumeric, mustBeSquare, sizeMustBeOdd, ...
                sizeMustBeLessThanSize(kernel, image)}
    end

    k_size = size(kernel, 1);
    
    % assume that stride is always 1
    pad_amount = (k_size - 1) / 2;
    
    padded_img = ICV_padarray(image, pad_amount, 124);
    imshow(padded_img);
    res = uint8(zeros(size(image)));
    
    for i = 1:size(padded_img, 1) - k_size + 1
        for j = 1:size(padded_img, 2) - k_size + 1
            patch = padded_img(i:i + k_size - 1, j:j + k_size - 1);
            conv_point = uint8(sum(double(patch(:)) .* kernel(:)));
            res(i, j) = conv_point;
        end
    end
end


function padded_arr = ICV_padarray(arr, amount, value)
    [arr_h, arr_w] = size(arr);
    padded_arr = uint8(ones(arr_h + 2 * amount, arr_w + 2 * amount));
    padded_arr = padded_arr * value;
    padded_arr(amount + 1:arr_h + amount, amount + 1:arr_w + amount) = arr;
end


% -------------------------------------------------------------------------
% Custom validation functions
% -------------------------------------------------------------------------
function mustBeSquare(arg)
    % assume that the kernel is always square
    if size(arg, 1) ~= size(arg, 2)
       error('Kernel should be a square matrix.'); 
    end
end


function sizeMustBeOdd(arg)
    if mod(size(arg, 1), 2) == 0
       error('Kernel should have an odd size.'); 
    end
end


function sizeMustBeLessThanSize(arg1, arg2)
    if max(size(arg1)) > min(size(arg2))
        error('Kernel should be smaller than the image.');
    end
end