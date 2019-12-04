video_file = './DatasetC.avi';
frame_folder = './frames';
diff_folder = './diffs';
save_figures = 1;
diff_threshold = 40;
% -------------------------------------------------------------------------
ICV_create_folder(frame_folder);
ICV_create_folder(diff_folder);
v = VideoReader(video_file);
first_frame = NaN;
i = 1;

while(hasFrame(v))
    frame = ICV_rgb2gray(readFrame(v), false);
    if isnan(first_frame)
       first_frame = frame; 
    end
    
    diff = ICV_frame_difference(first_frame, frame, diff_threshold);
    imshow(diff);
    
    if save_figures == 1
        filename = fullfile(frame_folder, sprintf('frame%d.png', i));
        imwrite(frame, filename);
        filename = fullfile(diff_folder, sprintf('diff%d-%d.png', i, i-1));
        imwrite(diff, filename);
    end
    i = i + 1;
end
