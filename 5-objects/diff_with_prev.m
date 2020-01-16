% Perform pixel-by-pixel frame differencing using the previous frame of an
% image sequence as reference frame. Apply a classification threshold and
% save the results to disk.

video_file = '../data/DatasetC.avi';
save_figures = 0;
frame_folder = './frames';
diff_folder = './diffs';
diff_threshold = 30;
% -------------------------------------------------------------------------
ICV_createFolder(frame_folder);
ICV_createFolder(diff_folder);
v = VideoReader(video_file);
prev_frame = NaN;
i = 1;

while(hasFrame(v))
    frame = ICV_rgb2gray(readFrame(v), false);
    if ~isnan(prev_frame)
        diff = ICV_frameDifference(prev_frame, frame, diff_threshold);
        imshow(diff);
    
        if save_figures == 1
            filename = fullfile(frame_folder, sprintf('frame%d.png', i));
            imwrite(frame, filename);
            filename = fullfile(diff_folder, sprintf('diff%d-%d.png', i, i-1));
            imwrite(diff, filename);
        end
    end
    prev_frame = frame;
    i = i + 1;
end