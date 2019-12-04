function ICV_count_moving_objects(frames, ref_frame, thresh)
    num_frames = size(frames, 4);
    for i = 1:num_frames
        frame = ICV_rgb2gray(frames(:, :, :, i), false);
        diff = ICV_frame_difference(ref_frame, frame, thresh);
        imshow(diff);
    end
end