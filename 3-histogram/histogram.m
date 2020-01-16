% For a given video sequence, construct and visualise colour histogram of
% each frame.

video_file = '../data/DatasetB.avi';
save_figures = 0;
% folder to save computed histograms
hist_folder = './histograms';
% folder to save video frames
frame_foler = './frames';
n_bins = 256;
% -------------------------------------------------------------------------
ICV_createFolder(hist_folder);
ICV_createFolder(frame_foler);

i = 1;
v = VideoReader(video_file);
frame_hists = zeros(v.NumFrames, n_bins, 3);

while(hasFrame(v))
    frame = readFrame(v);
    [hist, bins] = ICV_imhist(frame, n_bins);
    
    if save_figures == 1
        filename = fullfile(frame_foler, sprintf('frame%d.png', i));
        imwrite(frame, filename);
        
        f = figure('visible', 'off');
        plot(bins, hist(:, 1), 'Red', bins, ...
                   hist(:, 2), 'Green', bins, ...
                   hist(:, 3), 'Blue');
        title(sprintf('Histogram for frame %d', i));
        filename = fullfile(hist_folder, ...
                            sprintf('hist%d_frame%d.png', n_bins, i));
        saveas(f, filename);
    end

    frame_hists(i, :, :) = hist;
    i = i + 1;
end

f = figure('visible', 'on');
% visualize a surface figure that contains RED channel histograms for all
% video frames
surf(frame_hists(:, :, 1));