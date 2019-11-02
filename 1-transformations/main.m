img = imread('./anton.png');

% a) Rotating the image by 30, 60, 120 and -50 degres clockwise
res_img = ICV_rotate_skew(img, 30, 0);
imwrite(res_img, 'rotated30.png')

res_img = ICV_rotate_skew(img, 60, 0);
imwrite(res_img, 'rotated60.png')

res_img = ICV_rotate_skew(img, 120, 0);
imwrite(res_img, 'rotated120.png')

res_img = ICV_rotate_skew(img, -50, 0);
imwrite(res_img, 'rotated-50.png')

% Horizontally skewing the image by 10, 40, 60 degres
res_img = ICV_rotate_skew(img, 0, 10);
imwrite(res_img, 'skewed10.png')

res_img = ICV_rotate_skew(img, 0, 40);
imwrite(res_img, 'skewed40.png')

res_img = ICV_rotate_skew(img, 0, 60);
imwrite(res_img, 'skewed60.png')


img = imread('./face-1.jpg');

% b) Rotating the image by 20 degrees clockwise and then horizontally
% skewing the result by 50 degrees
% rotation -> skew
res_img = ICV_rotate_skew(img, 20, 50);
imwrite(res_img, 'rotated20-skewed50.png')

% inverse order of the operations: skew -> rotation
res_img = ICV_rotate_skew(img, 20, 50, -1);
imwrite(res_img, 'skewed50-rotated20.png')