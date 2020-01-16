function dec = ICV_bin2dec(str)
% Convert text representation of binary number to decimal integer

    dec = 0;
    len = strlength(str);

    for i = 1:len
        ch = str{1}(len - i + 1);
        dec = dec + str2double(ch) * 2 ^ (i - 1);
    end
end