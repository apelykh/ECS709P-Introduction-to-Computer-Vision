function ICV_plot_pixel_intensity(video_file, pixel_coords, to_save)
    pix_x = uint16(pixel_coords(1));
    pix_y = uint16(pixel_coords(2));
    v = VideoReader(video_file);
    map = containers.Map({'r', 'g', 'b'}, {[], [], []});

    while(hasFrame(v))
        frame = readFrame(v);
        map('r') = [map('r'), frame(pix_x, pix_y, 1)];
        map('g') = [map('g'), frame(pix_x, pix_y, 2)];
        map('b') = [map('b'), frame(pix_x, pix_y, 3)];
    end

    x = 1:floor(v.FrameRate * v.Duration);
    hold on;
    plot(x, map('r'), 'r');
    plot(x, map('g'), 'g');
    plot(x, map('b'), 'b');
    hold off;
    title(sprintf('(%d, %d) Pixel intensity values', pix_x, pix_y));
    
    if to_save
       saveas(gcf, fullfile('images', 'plot.png'));
    end
end