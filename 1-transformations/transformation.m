img = imread('~/Projects/ECS709P-Intro-to-CV/Coursework/images/anton.png');
% img = imread('/homes/ap328/Datasets/sculptures6k/test/Rodin_Stanford_0250.jpg');

tic;
rot_img = ICV_rotate(img, 210);
toc;
imshow(rot_img);
