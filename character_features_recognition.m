function features = character_features_recognition(image_file_name, num_of_symbol_lines)
%%  features = character_features_recognition(image_file_name, num_of_symbol_lines)
% Features = character_features_recognition(image_file_name, Number_of_symbols_lines)
% Example of function use:
% features = character_features_recognition('test_data.png', 8);
%%
% Read image with written symbols
V = imread(image_file_name);
figure(12), imshow(V)
%% Perform segmentation of the symbols and write into cell variable
% RGB image is converted to grayscale
V_grayscale = rgb2gray(V);
% Calculate a threshold value for binary image conversion
threshold = graythresh(V_grayscale);
% Convert grayscale image to binary image
V_binary = im2bw(V_grayscale, threshold);
% Show the resulting image
figure(1), imshow(V_binary)
% Search for the contour of each object
V_contours = edge(uint8(V_binary));
% Show the resulting image
figure(2), imshow(V_contours)
% Fill the contours
se = strel('square', 7); % structural element for filling
V_filled = imdilate(V_contours, se);
% Show the result
figure(3), imshow(V_filled)
% Fill the holes
V_whole = imfill(V_filled, 'holes');
% Show the result
figure(4), imshow(V_whole)
% Set labels to binary image objects
[labeled_objects, num] = bwlabel(V_whole);
% Calculate features for each symbol
object_features = regionprops(labeled_objects);
% Find/read the bounding box of the symbol
object_bounding_box = [object_features.BoundingBox];
% Change the sequence of values, describing the bounding box
object_bounding_box = reshape(object_bounding_box, [4 num]); % num - number of objects
% Read the mass center coordinate
object_centroid = [object_features.Centroid];
% Group center coordinate values
object_centroid = reshape(object_centroid, [2 num]);
object_centroid = object_centroid';
% Set the label/number for each object in the image
object_centroid(:, 3) = 1:num;
% Arrange objects according to the column number
object_centroid = sortrows(object_centroid, 2);
% Sort according to the number of rows and number of symbols in the row
num_of_symbols = num / num_of_symbol_lines;
for k = 1:num_of_symbol_lines
    object_centroid((k-1)*num_of_symbols+1:k*num_of_symbols, :) = ...
        sortrows(object_centroid((k-1)*num_of_symbols+1:k*num_of_symbols, :), 3);
end
% Cut the symbol from initial image according to the bounding box estimated in binary image
for k = 1:num
    objects{k} = imcrop(V_binary, object_bounding_box(:, object_centroid(k, 3)));
end
% Show one of the symbol's images
figure(5),
for k = 1:num
    subplot(num_of_symbol_lines, num_of_symbols, k), imshow(objects{k})
end
% Image segments are cut off
for k = 1:num % num = 88, if there are 88 symbols
    V_segment = objects{k};
    % Estimate the size of each segment
    [height, width] = size(V_segment);
    
    % 1. Eliminate white spaces
    % Calculate the sum of each column
    column_sums = sum(V_segment, 1);
    % Eliminate columns where the sum equals the height
    V_segment(:, column_sums == height) = [];
    % Recalculate the size of the object
    [height, width] = size(V_segment);
    % 2. Eliminate white rows
    % Calculate the sum of each row
    row_sums = sum(V_segment, 2);
    % Eliminate rows where the sum equals the width
    V_segment(row_sums == width, :) = [];
    objects{k} = V_segment; % Save the result
end
% Show the segment
figure(6),
for k = 1:num
    subplot(num_of_symbol_lines, num_of_symbols, k), imshow(objects{k})
end
%%
%% Make all segments of the same size 70x50
for k = 1:num
    V_segment = objects{k};
    V_segment_7050 = imresize(V_segment, [70, 50]);
    % Divide each image into 10x10 size segments
    for m = 1:7
        for n = 1:5
            % Calculate an average intensity for each 10x10 segment
            avg_brightness_row = sum(V_segment_7050((m*10-9:m*10), (n*10-9:n*10)));
            avg_brightness((m-1)*5+n) = sum(avg_brightness_row);
        end
    end
    % The maximum possible brightness value in a 10x10 segment is 100
    % Normalize brightness values in the range [0, 1]
    avg_brightness = ((100 - avg_brightness) / 100);
    % Transform features into column-vector
    avg_brightness = avg_brightness(:);
    % Save all features into a single variable
    features{k} = avg_brightness;
end
