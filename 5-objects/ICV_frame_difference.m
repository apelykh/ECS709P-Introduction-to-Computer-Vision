function diff = ICV_frame_difference(base_frame, frame, thresh)
    diff = abs(frame - base_frame);
    if thresh > 0
        mask = diff > thresh;
        diff = uint8(255 .* mask);
    end
end