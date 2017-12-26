%% CS 383 Zoltan Gercsak Multi-class SVM Assignment 7

clc;
close all;
clear all;

% read data file
filename = 'CTG.csv';
data = csvread(filename, 2);

% randomize the data
rng(0);
data = data(randperm(size(data,1)),:);

%% Create training and testing set
testSet = ceil(size(data,1)*2/3)+1;
testing = data(testSet:end, :);
testFeatures = testing(:, 1:end-1);
testLabel = testing(:, end);

trainSet = ceil(size(data,1)*2/3);
training = data(1:trainSet, :);
trainFeatures = training(:, 1:end-1);
trainLabel = training(:, end);

%% Normalizing data

numData = size(testFeatures,1);
numTrainData = size(trainFeatures,1);

trainFmean = mean(trainFeatures);
trainFstd = std(trainFeatures);
trainFnorm = (trainFeatures - repmat(trainFmean, numTrainData, 1))  ./ repmat(trainFstd, numTrainData, 1);
testFnorm = (testFeatures - repmat(trainFmean, numData, 1)) ./ repmat(trainFstd, numData, 1);

%% Support Vector Machine

dataClass = {};
categories = unique(trainLabel);

for i = 1:length(categories)
    dataClass{i} = trainFeatures(trainLabel == categories(i), :);
end

listPrediction = [];
for i = 1:length(categories)
    for k = i+1:length(categories)
        label0 = repmat(categories(i), size(dataClass{i},1),1);
        label1 = repmat(categories(k), size(dataClass{k},1),1);
        data = [dataClass{i}; dataClass{k}];
        label = [label0; label1];
        SVMModel = fitcsvm(data, label);
        listPrediction = [listPrediction predict(SVMModel, testFnorm)];
    end
end

%% Find prediction
prediction = [];

categories2 = unique(listPrediction);
weight = [];
for i = 1:length(categories2)
    weight = [weight sum(listPrediction == categories2(i))];
end

index = find(weight == max(weight));
category = categories2(index(randi([1 length(index)])));

for i = 1:size(listPrediction,1)
        prediction = [prediction; category];
end

accuracy = sum(prediction == testLabel) / length(testLabel);

% print result
fprintf('Accuracy of 1 vs 1 = %f%\n',  accuracy);


