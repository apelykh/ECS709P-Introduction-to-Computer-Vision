test_image = '/home/apelykh/Projects/ECS709P-Intro-to-CV/Dataset/DatasetA/car-1.jpg';
window_size = 32;
% -------------------------------------------------------------------------

key_set = {'car', 'face'};
train_set = containers.Map(key_set, ...
    {{'/home/apelykh/Projects/ECS709P-Intro-to-CV/Dataset/DatasetA/car-2.jpg', ...
      '/home/apelykh/Projects/ECS709P-Intro-to-CV/Dataset/DatasetA/car-3.jpg'}, ...
     {'/home/apelykh/Projects/ECS709P-Intro-to-CV/Dataset/DatasetA/face-2.jpg', ...
      '/home/apelykh/Projects/ECS709P-Intro-to-CV/Dataset/DatasetA/face-3.jpg'}} ...
);

test_image = ICV_rgb2gray(imread(test_image), false);
num_windows = (size(test_image, 1) / window_size) ^ 2;

avg_histograms = containers.Map(key_set, ...
    {zeros(1, num_windows * 256), ...
     zeros(1, num_windows * 256)} ...
);

% Training the classifier: computing an average LBP histogram for each
% class
for label = train_set.keys
    for filename = train_set(label{1})
        disp(fprintf('[.] Computing features for %s', filename{1}));
        image = ICV_rgb2gray(imread(filename{1}), false);
        LBP_hist = ICV_extractLBPFeatures(image, window_size);
        avg_histograms(label{1}) = avg_histograms(label{1}) + LBP_hist;
    end
    avg_histograms(label{1}) = avg_histograms(label{1}) / length(train_set(label{1}));
end

% Testing
test_LBP_hist = ICV_extractLBPFeatures(test_image, window_size);

max_intersection = 0;
pred_class = '';
for label = avg_histograms.keys
    intersection = ICV_hist_intersection(test_LBP_hist, avg_histograms(label{1}));
    disp(fprintf("%s intersection: %f", label{1}, intersection));

    if intersection > max_intersection
        max_intersection = intersection;
        pred_class = label{1};
    end
end

disp(fprintf('Predicted class: %s (intersection: %f)', pred_class, max_intersection));