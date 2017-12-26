%% Zoltan Gercsak - Closed Form Linear Regression

clc;
close all;
clear all;

% read data file
filename = 'x06Simple.csv';
data = csvread(filename, 1);
data = data(:, 2:end);

% randomize the data
rng(0);
data = data(randperm(size(data,1)),:);

% create training and testing set
trainSet = ceil(size(data,1)*2/3);
training = data(1:trainSet, :);
trainFeatures = training(:, 1:end-1);
trainLabel = training(:, end);

testSet = ceil(size(data,1)*2/3)+1;
testing = data(testSet:end, :);
testFeatures = testing(:, 1:end-1);
testLabel = testing(:, end);

%% Closed form linear regression
[weight, meanValue, stdValue] = CFLR(trainFeatures, trainLabel);

%% Calculate error

normTestData = (testFeatures - repmat(meanValue, size(testFeatures,1), 1)) ./ repmat(stdValue, size(testFeatures,1), 1);
normTestData = [ones(size(normTestData,1),1), normTestData];
prediction = normTestData * weight;
mse = mean((testLabel - prediction).^2);
rmse = sqrt(mse);

%% Print out result
fprintf('Model y = %f + %fx1 + %fx2, RMSE = %f\n', weight(1), weight(2), weight(3), rmse);
