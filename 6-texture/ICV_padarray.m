function padded_arr = ICV_padarray(arr, amount, value)
    [arr_h, arr_w] = size(arr);
    padded_arr = uint8(ones(arr_h + 2 * amount, arr_w + 2 * amount));
    padded_arr = padded_arr * value;
    padded_arr(amount + 1:arr_h + amount, amount + 1:arr_w + amount) = arr;
end