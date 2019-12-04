video_file = './DatasetC.avi';
diff_threshold = 20;
% -------------------------------------------------------------------------
frames = read(VideoReader(video_file));
ref_frame = ICV_generate_reference_frame(frames, diff_threshold);
imshow(ref_frame);

ICV_count_moving_objects(frames, ref_frame, diff_threshold);

