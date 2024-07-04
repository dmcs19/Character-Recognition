# Character Recognition Using MATLAB

## Description

This project demonstrates a character recognition system using MATLAB. It includes feature extraction and image recognition scripts that process binary images of characters and extract relevant features for recognition. The project provides a simple and effective approach to recognizing handwritten characters.

## Files

- **character_features_recognition.m**: Defines the features for character recognition.
- **image_recognition.m**: Script for image recognition.
- **test.png**: Test image for character recognition.
- **train.png**: Training image for character recognition.

## Usage

1. **Feature Extraction**:
   - The `character_features_recognition.m` script resizes the input character image, calculates various features such as the proportion of black pixels, aspect ratio, center of mass, and symmetry.

2. **Image Recognition**:
   - The `image_recognition.m` script reads an image (`test.png`), converts it to grayscale and binary, labels connected components, and extracts features for each labeled region.

## Example

To extract features from an image, run the following command in MATLAB:
```matlab
img = imread('test.png');
imshow(img);
gray_img = rgb2gray(img);
bw_img = imbinarize(gray_img);
labeled_img = bwlabel(bw_img);
features = [];
stats = regionprops(labeled_img, 'BoundingBox');
for i = 1:length(stats)
    bbox = stats(i).BoundingBox;
    sub_img = imcrop(bw_img, bbox);
    feature_vector = recognize_character_features(sub_img);
    features = [features; feature_vector];
end
disp('Extracted Features:');
disp(features);
```

## Requirements

- Matlab
