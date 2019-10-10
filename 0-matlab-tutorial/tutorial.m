% -------------------------------------------------------------------------
% 1. Handling images:
% Load and display an image
% -------------------------------------------------------------------------
% img = imread('/homes/ap328/Datasets/sculptures6k/train/Henry_Moore_Arch_Leg_0000.jpg');
img = imread('~/Projects/ECS709P-Intro-to-CV/Coursework/0-matlab-tutorial/images/grayscale.png');

% -------------------------------------------------------------------------
% 2. Load, modify and save an image:
% Load the RGB image from Ex.1 and convert it to grayscale without using
% any built-in functions; then, save the image to the file in PNG format.
% Write RGB-to-grayscale as a MATLAB function;
% -------------------------------------------------------------------------
% ICV_gray_img = ICV_rgb2gray(img, true);
% gray_img = rgb2gray(img);
% figure, imshow(ICV_gray_img);
% figure, imshow(gray_img);

% -------------------------------------------------------------------------
% 3. Array indexing + conditional statements:
% Crop the RGB image from Ex.1 into a smaller 96x96 image in the centre.
% Then, compute the max and min values for each color channel in the crop.
% Print results to the command window.
% ! Built-in functions max and min are not allowed.
% -------------------------------------------------------------------------
% ICV_cropped_img = ICV_crop(img, 96);
% figure, imshow(img);
% figure, imshow(ICV_cropped_img);

% -------------------------------------------------------------------------
% 4. Image manipulation + array indexing:
% Overlay the image from Ex.1 with an image containing your name. Your
% name should appear on top of the RGB image in the centre.
% -------------------------------------------------------------------------
% fgr_img = imread('~/Projects/ECS709P-Intro-to-CV/Coursework/0-matlab-tutorial/images/anton-name-design.jpg');
fgr_img = imread('~/Projects/ECS709P-Intro-to-CV/Coursework/0-matlab-tutorial/images/anton-name-design-2.png');
res_img = ICV_overlay(img, fgr_img);
imshow(res_img);


% video_file = '~/Projects/ECS709P-Intro-to-CV/Coursework/0-matlab-tutorial/videos/blackpink';
% -------------------------------------------------------------------------
% 5. Handling videos + loop control:
% Load and visualise the video
% -------------------------------------------------------------------------
% ICV_play_video(video_file);

% -------------------------------------------------------------------------
% 6. Handling videos + array indexing + graphics:
% Load the previous video, extract the RGB values of pixel (47, 139),
% plot the intensity value of the pixel over time for each colour channel
% and save the plot.
% -------------------------------------------------------------------------
% ICV_plot_pixel_intensity(video_file, [47, 139], 1);


% -------------------------------------------------------------------------
% 7. Matrix manipulation
% Generate a 100x100 matrix of random numbers in the range [0, 75],
% substract a diagonal matrix whose values are 20 and compute the maximum
% value for each 10x10 sub-block, such that the sub-blocks do not overlap.
% Prompt the resulting max values as a 10x10 matrix to the command window.
% ! Built-in function max is not allowed.
% -------------------------------------------------------------------------
% ICV_manipulate_matrix();
