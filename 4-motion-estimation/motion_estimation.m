video_file = './DatasetC.mpg';
% -------------------------------------------------------------------------

v = VideoReader(video_file);
prev_frame = NaN;

% -------------------
img1 = rgb2gray(imread('face-1.jpg'));
img2 = rgb2gray(imread('face-1-shifted.jpg'));

block_size = 9;
hbm = vision.BlockMatcher('ReferenceFrameSource', 'Input port','BlockSize',[block_size block_size]);
hbm.OutputValue = 'Horizontal and vertical components in complex form';
halphablend = vision.AlphaBlender;
% -------------------

% ICV_motionEstBM(img1, img2, 16, 20);

i = 1;
while(hasFrame(v))
    cur_frame = readFrame(v);
    cur_frame = rgb2gray(cur_frame);
    if ~isnan(prev_frame)
        [motion_field, predicted_frame] = ICV_motionEstBM(prev_frame, cur_frame, 8, 16);
        
        imshow(cur_frame);
        hold on
%         quiver(xc_coords, yc_coords, x_len, y_len, 1);
        quiver(motion_field(1), motion_field(2), motion_field(3), motion_field(4), 1);
        hold off
        
%         [motionVect, EScomputations] = motionEstES(prev_frame, cur_frame, 16, 20);

%         motion = hbm(prev_frame, cur_frame);
%         img12 = halphablend(prev_frame, cur_frame);
% 
%         [X,Y] = meshgrid(1:block_size:size(prev_frame, 2), 1:block_size:size(cur_frame, 1));    
% 
%         imshow(img12)
%         hold on
%         quiver(X(:), Y(:),real(motion(:)), imag(motion(:)), 0)
%         hold off
        break
    end

    prev_frame = cur_frame;
    i = i + 1;
end
