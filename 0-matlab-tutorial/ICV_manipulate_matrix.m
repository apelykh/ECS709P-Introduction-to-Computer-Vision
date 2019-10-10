function ICV_manipulate_matrix()
    A = 75 * rand(100, 100) - 20 * eye(100, 100);
    block_max_vals = zeros(10, 10);
    
    for i = 1:10:91
        for j = 1:10:91
            block = A(i:i+9, j:j+9);
            block_vect = block(:);
            block_max = ICV_vect_max(block_vect);
            if i == 1; block_i = i; else; block_i = ceil(i / 10); end
            if j == 1; block_j = j; else; block_j = ceil(j / 10); end
            block_max_vals(block_i, block_j) = block_max;
        end
    end
    
    disp(block_max_vals);
end

function max_v = ICV_vect_max(vect)
    max_v = -1;
    
    for i = 1:length(vect)
        if vect(i) > max_v
            max_v = vect(i);
        end
    end
end