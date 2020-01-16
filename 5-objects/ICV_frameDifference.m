function diff = ICV_frameDifference(base_frame, frame, thresh)
    diff = abs(frame - base_frame);
    if thresh > 0
        mask = diff > thresh;
        diff = uint8(255 .* mask);
    end
end