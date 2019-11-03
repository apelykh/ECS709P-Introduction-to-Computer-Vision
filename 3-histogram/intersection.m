video_file = './DatasetB.avi';
save_figures = 0;
% folder to save histogram intersections
save_folder = './intersections';
n_bins = 256;
% -------------------------------------------------------------------------
ICV_create_folder(save_folder);

i = 1;
v = VideoReader(video_file);
frame_hists = zeros(v.NumFrames, n_bins, 3);
hist_diffs = zeros(v.NumFrames, 3);

while(hasFrame(v))
    frame = readFrame(v);
    [hist, bins] = ICV_imhist(frame, n_bins);
    frame_hists(i, :, :) = hist;

    if i > 1
        [i_r, i_g, i_b] = ICV_hist_intersection(frame_hists(i, :, :), ...
                                          frame_hists(i - 1, :, :));
        hist_diffs(i, 1) = i_r;
        hist_diffs(i, 2) = i_g;
        hist_diffs(i, 3) = i_b;

        if save_figures == 1
            f = figure('visible', 'off');
            hold on
            color = ['r', 'g', 'b'];
            for k = 1:length(hist_diffs(i, :))  
                h = bar(k, hist_diffs(i, k));
                set(h, 'FaceColor', color(k));
            end
            title(sprintf('RGB histogram intersections for frames %d, %d', i-1, i));
            ylim([0, 1]);
            xticks([1, 2, 3]);
            xticklabels({'R', 'G', 'B'});
            filename = fullfile(save_folder, sprintf('int_frames%d-%d.png', i-1, i));
            saveas(f, filename);
        end
    end
    i = i + 1;
end

f = figure('visible', 'on');
surf(hist_diffs);
