img = imread('~/Projects/ECS709P-Intro-to-CV/Coursework/images/anton.png');
% img = imread('~/Projects/ECS709P-Intro-to-CV/Dataset/DatasetA/face-1.jpg');

tic;
res_img = ICV_rotate_shear(img, 19, 80);
toc;
imshow(res_img);
