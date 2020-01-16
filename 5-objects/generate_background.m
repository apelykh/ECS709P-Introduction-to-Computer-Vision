% Generate a reference frame (background) for image sequence using frame
% differencing and a weighted temporal averaging algorithm.

video_file = '../data/DatasetC.avi';
diff_threshold = 30;
% -------------------------------------------------------------------------
frames = read(VideoReader(video_file));
ref_frame = ICV_generateReferenceFrame(frames, diff_threshold);
imshow(ref_frame);