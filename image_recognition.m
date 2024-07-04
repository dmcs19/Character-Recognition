close all
clear all
clc
%% Read the image with hand-written characters
image_file_name = 'train.png';
features_for_network_training = character_features_recognition(image_file_name, 5);
%% Development of character recognizer
% Take the features from cell-type variable and save into a matrix-type variable
P = cell2mat(features_for_network_training);
% Create the matrices of correct answers for each line (number of matrices = number of symbol lines)
T = [eye(5), eye(5), eye(5), eye(5), eye(5)];
% Create an RBF network for classification with 13 neurons, and sigma = 1
network = newrb(P, T, 0, 1, 13);

%% Test of the network (recognizer)
% Estimate output of the network for unknown symbols (rows that were not used during training)
P2 = P(:, 12:22);
Y2 = sim(network, P2);
% Find which neural network output gives the maximum value
[a2, b2] = max(Y2);
%% Visualize result
% Calculate the total number of symbols in the row
num_of_symbols = size(P2, 2);
% Save the result in variable 'atsakymas'
result = [];
for k = 1:num_of_symbols
    switch b2(k)
        case 1
            % The symbol here should be the same as written first symbol in your image
            result = [result, 'S'];
        case 2
            result = [result, 'A'];
        case 3
            result = [result, 'R'];
        case 4
            result = [result, 'I'];
        case 5
            result = [result, 'V'];
    end
end
% Show the result in command window
disp(result)
figure(7), text(0.1, 0.5, result, 'FontSize', 38)
%% Extract features of the test image
image_file_name = 'test.png';
features_for_test = character_features_recognition(image_file_name, 1);

%% Perform letter/symbol recognition
% Features from cell-variable are stored to matrix-variable
P2 = cell2mat(features_for_test);
% Estimate neural network output for newly estimated features
Y2 = sim(network, P2);
% Find which output gives maximum value
[a2, b2] = max(Y2);
%% Visualization of result
% Calculate the total number of symbols
num_of_symbols = size(P2, 2);
% Save the result in variable 'result'
result = [];
for k = 1:num_of_symbols
    switch b2(k)
        case 1
            result = [result, 'S'];
        case 2
            result = [result, 'A'];
        case 3
            result = [result, 'R'];
        case 4
            result = [result, 'I'];
        case 5
            result = [result, 'V'];
    end
end
% Show the result in command window
% disp(result)
figure(8), text(0.1, 0.5, result, 'FontSize', 38), axis off

%{
%% Extract features for next/another test image
image_file_name = 'test_fikcija.png';
features_for_test = character_features_recognition(image_file_name, 1);

%% Perform letter/symbol recognition
% Features from cell-variable are stored to matrix-variable
P2 = cell2mat(features_for_test);
% Estimate neural network output for newly estimated features
Y2 = sim(network, P2);
% Find which output gives maximum value
[a2, b2] = max(Y2);
%% Visualization of result
% Calculate the total number of symbols
num_of_symbols = size(P2, 2);
% Save the result in variable 'result'
result = [];
for k = 1:num_of_symbols
    switch b2(k)
        case 1
            result = [result, 'S'];
        case 2
            result = [result, 'A'];
        case 3
            result = [result, 'R'];
        case 4
            result = [result, 'I'];
        case 5
            result = [result, 'V'];
    end
end
% Show the result in command window
% disp(result)
figure(9), text(0.1, 0.5, result, 'FontSize', 38), axis off
%}
