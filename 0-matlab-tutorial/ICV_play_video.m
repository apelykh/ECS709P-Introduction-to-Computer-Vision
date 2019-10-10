function ICV_play_video(video_file)
    v = VideoReader(video_file);

    while(hasFrame(v))
        frame = readFrame(v);
        imshow(frame);
        title(sprintf('Current Time: %.3f sec', v.CurrentTime));
        pause(2 / v.FrameRate);
    end
end