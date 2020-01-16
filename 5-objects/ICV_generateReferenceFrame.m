function ref_frame = ICV_generateReferenceFrame(frames, thresh)
    ref_frame = zeros(size(frames(:, :, 1, 1)));    
    num_frames = size(frames, 4);
    prev_frame = NaN;
    
    for i = 1:num_frames
        frame = ICV_rgb2gray(frames(:, :, :, i), false);
        if ~isnan(prev_frame)
            diff = ICV_frameDifference(prev_frame, frame, thresh);
            % add only stationary pixels from current frame
            ref_frame = ref_frame + double(frame .* uint8(~diff));    
        end
        prev_frame = frame;
    end
    % average the values
    ref_frame = uint8(ref_frame ./ (num_frames - 1));
end