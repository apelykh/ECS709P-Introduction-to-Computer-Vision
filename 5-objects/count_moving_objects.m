% Count the number of moving objects in each frame of a sequence. Generate
% a bar plot that visualizes the number of objects for each frame of the
% sequence.

video_file = '../data/DatasetC.avi';
ref_frame_thresh = 30;
obj_count_thresh = 60;
% -------------------------------------------------------------------------
frames = read(VideoReader(video_file));
% generate reference frame (background) based on frame differences
ref_frame = ICV_generateReferenceFrame(frames, ref_frame_thresh);
num_frames = size(frames, 4);
counts = size(num_frames);

for i = 1:num_frames
    frame = ICV_rgb2gray(frames(:, :, :, i), false);
    diff = ICV_frameDifference(ref_frame, frame, obj_count_thresh);
    counts(i) = ICV_countConnectedComponents(diff);
end
bar(counts);


function count = ICV_countConnectedComponents(image)
    visited = false(size(image));
    count = 0;

    for i = 1:size(image, 1)
        for j = 1 : size(image, 2)
            if image(i, j) == 0
                visited(i, j) = true;
            elseif visited(i, j)
                continue;
            else
                stack = [i, j];
                while ~isempty(stack)
                    loc = stack(1, :);
                    stack(1, :) = [];

                    if visited(loc(1), loc(2))
                        continue;
                    end
                    visited(loc(1), loc(2)) = true;

                    [locs_x, locs_y] = getValidNeighbors(loc, image, visited);
                    % Add to stack neighbouring pixels in a defined
                    % negihbourhood that are 1 (255)
                    stack = [stack; [locs_y, locs_x]];
                end
                count = count + 1;
            end
        end
    end   
end

function [locs_x, locs_y] = getValidNeighbors(loc, image, visited)
    [height, width] = size(image);
    % Look at 49 neighbouring locations
    [locs_x, locs_y] = meshgrid(loc(2) - 3:loc(2) + 3, ...
                                loc(1) - 3:loc(1) + 3);
    locs_x = locs_x(:);
    locs_y = locs_y(:);

    % Remove invalid locations (out of image bounds)
    inval_coords = locs_y < 1 | locs_y > height | locs_x < 1 | locs_x > width;
    locs_x(inval_coords) = [];
    locs_y(inval_coords) = [];

    % Remove already visited locations
    visited_los = visited(sub2ind([height, width], locs_y, locs_x));
    locs_x(visited_los) = [];
    locs_y(visited_los) = [];

    % Get rid of zero locations
    nonzero = image(sub2ind([height, width], locs_y, locs_x));
    locs_x(~nonzero) = [];
    locs_y(~nonzero) = [];
end