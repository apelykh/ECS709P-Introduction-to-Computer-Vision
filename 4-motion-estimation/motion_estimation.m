video_file = './DatasetC.mpg';
save_folder = './frames';
save_figures = 0;
block_size = 8;
search_window = 16;
% -------------------------------------------------------------------------
ICV_create_folder(save_folder);
v = VideoReader(video_file);
prev_frame = NaN;

i = 1;
while(hasFrame(v))
    cur_frame = readFrame(v);
%     cur_frame = ICV_rgb2gray(cur_frame, false);
    
    filename = fullfile(save_folder, sprintf('frame%d.png', i));
    if save_figures == 1
        imwrite(cur_frame, filename);
    end

    if ~isnan(prev_frame)
        tic;
        [motion_field, predicted_frame] = ICV_motionEstBM(prev_frame, ...
            cur_frame, block_size, search_window);
        toc;
        
%         filename = fullfile(save_folder, sprintf('frame%d-predicted.png', i));
%         imwrite(predicted_frame, filename);

        imshow(cur_frame);
        hold on
        quiver(motion_field(1, :, :), motion_field(2, :, :), ...
               motion_field(3, :, :), motion_field(4, :, :), ...
               0.5, 'color', [1 0 0]);
        hold off
        
        frame = getframe(gcf, [92, 63, 352, 288]);
        [frame_with_mf, ~] = frame2im(frame);
        if save_figures == 1
            filename = fullfile(save_folder, sprintf('frame%d-motion-field.png', i));
            imwrite(frame_with_mf, filename);
            filename = fullfile(save_folder, sprintf('frame%d-predicted.png', i));
            imwrite(predicted_frame, filename);
        end
    end
    prev_frame = cur_frame;
    i = i + 1;
end
