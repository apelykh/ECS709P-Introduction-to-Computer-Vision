% Change value to use different image
target_image = './face-1.jpg';
% -------------------------------------------------------------------------
img = imread(target_image);
img = ICV_rgb2gray(img);
imwrite(img, './face1-gray.png');


% a) Design a convolution kernel that enables the computation of average
% intensity value in a 3x3 region for each pixel. Use this kernel and the
% filtering function above, save the resulting image.

avg_kernel = 1/9 * [1, 1, 1;
                    1, 1, 1;
                    1, 1, 1];
res_img = ICV_conv2(img, avg_kernel);
imwrite(res_img, './2a-average.png');


% b) Use the kernels provided below, apply the filtering function and save
% the resulting images. Comment on the effect each kernel has on the
% input image.

kernel_A = [1, 2, 1;
            2, 4, 2;
            1, 2, 1];
res_img = ICV_conv2(img, kernel_A);
imwrite(res_img, './2b-kernelA.png');
        
kernel_A_norm = 1/16 * [1, 2, 1;
                        2, 4, 2;
                        1, 2, 1];
res_img = ICV_conv2(img, kernel_A_norm);
imwrite(res_img, './2b-kernelA-norm.png');

kernel_B = [0, 1, 0
            1, -4, 1;
            0, 1, 0];
res_img = ICV_conv2(img, kernel_B);
imwrite(res_img, './2b-kernelB.png');


% c) Use the filtering function for the following filtering operations:
% (I) A followed b by A;
% (II) A followed by B;
% (III) B followed by y A.

res_img = ICV_conv2(img, kernel_A);
res_img = ICV_conv2(res_img, kernel_A);
imwrite(res_img, './2c-A-A.png');

res_img = ICV_conv2(img, kernel_A_norm);
res_img = ICV_conv2(res_img, kernel_A_norm);
imwrite(res_img, './2c-A-norm-A-norm.png');

res_img = ICV_conv2(img, kernel_A);
res_img = ICV_conv2(res_img, kernel_B);
imwrite(res_img, './2c-A-B.png');

res_img = ICV_conv2(img, kernel_A_norm);
res_img = ICV_conv2(res_img, kernel_B);
imwrite(res_img, './2c-A-norm-B.png');

res_img = ICV_conv2(img, kernel_B);
res_img = ICV_conv2(res_img, kernel_A_norm);
imwrite(res_img, './2c-B-A-norm.png');

res_img = ICV_conv2(img, kernel_B);
res_img = ICV_conv2(res_img, kernel_A);
imwrite(res_img, './2c-B-A.png');

% d) Keeping the effect of the kernels in b) the same, discuss how to extend
% them to larger filter kernels 5x5 and 7x7. Using the extended Kernels and
% repeat the operations in c).

gaussian_5x5 = 1/52 * [1, 1, 2, 1, 1;
                       1, 2, 4, 2, 1;
                       2, 4, 8, 4, 2;
                       1, 2, 4, 2, 1;
                       1, 1, 2, 1, 1];

laplacian_5x5 = [0, 0, 1, 0, 0;
                 0, 0, 1, 0, 0;
                 1, 1, -8, 1, 1;
                 0, 0, 1, 0, 0;
                 0, 0, 1, 0, 0];

res_img = ICV_conv2(img, gaussian_5x5);
res_img = ICV_conv2(res_img, gaussian_5x5);
imwrite(res_img, './2d-g5-g5.png');

res_img = ICV_conv2(img, gaussian_5x5);
res_img = ICV_conv2(res_img, laplacian_5x5);
imwrite(res_img, './2d-g5-l5.png');

res_img = ICV_conv2(img, laplacian_5x5);
res_img = ICV_conv2(res_img, gaussian_5x5);
imwrite(res_img, './2d-l5-g5.png');


gaussian_7x7 = 1/128 * [1, 1, 1, 2, 1, 1, 1;
                        1, 1, 2, 4, 2, 1, 1;
                        1, 2, 4, 8, 4, 2, 1;
                        2, 4, 8, 16, 8, 4, 2;
                        1, 2, 4, 8, 4, 2, 1;
                        1, 1, 2, 4, 2, 1, 1;
                        1, 1, 1, 2, 1, 1, 1];

laplacian_7x7 = [0, 0, 0,  1,  0, 0, 0;
                 0, 0, 0,  1,  0, 0, 0;
                 0, 0, 0,  1,  0, 0, 0;
                 1, 1, 1, -12, 1, 1, 1;
                 0, 0, 0,  1,  0, 0, 0;
                 0, 0, 0,  1,  0, 0, 0;
                 0, 0, 0,  1,  0, 0, 0];
             
res_img = ICV_conv2(img, gaussian_7x7);
res_img = ICV_conv2(res_img, gaussian_7x7);
imwrite(res_img, './2d-g7-g7.png');

res_img = ICV_conv2(img, gaussian_7x7);
res_img = ICV_conv2(res_img, laplacian_7x7);
imwrite(res_img, './2d-g7-l7.png');

res_img = ICV_conv2(img, laplacian_7x7);
res_img = ICV_conv2(res_img, gaussian_7x7);
imwrite(res_img, './2d-l7-g7.png');
