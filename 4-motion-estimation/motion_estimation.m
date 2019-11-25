video_file = './DatasetC.mpg';
% -------------------------------------------------------------------------

v = VideoReader(video_file);

prev_frame = NaN;

i = 1;
while(hasFrame(v))
    cur_frame = readFrame(v);
    cur_frame = rgb2gray(cur_frame);
    if ~isnan(prev_frame)
        ICV_motionEstBM(prev_frame, cur_frame, 8, 32, i);
%         [motionVect, EScomputations] = motionEstES(prev_frame, cur_frame, 16, 20);
    end

    prev_frame = cur_frame;
    i = i + 1;
end
