% Perform pixel-by-pixel frame differencing using the first frame of an
% image sequence as reference frame. Apply a classification threshold and
% save the results to disk.

video_file = '../data/DatasetC.avi';
save_figures = 0;
frame_folder = './frames';
diff_folder = './diffs';
diff_threshold = 40;
% -------------------------------------------------------------------------
ICV_createFolder(frame_folder);
ICV_createFolder(diff_folder);
v = VideoReader(video_file);
first_frame = NaN;
i = 1;

while(hasFrame(v))
    frame = ICV_rgb2gray(readFrame(v), false);
    if isnan(first_frame)
       first_frame = frame; 
    end
    
    diff = ICV_frameDifference(first_frame, frame, diff_threshold);
    imshow(diff);
    
    if save_figures == 1
        filename = fullfile(frame_folder, sprintf('frame%d.png', i));
        imwrite(frame, filename);
        filename = fullfile(diff_folder, sprintf('diff%d-%d.png', i, i-1));
        imwrite(diff, filename);
    end
    i = i + 1;
end