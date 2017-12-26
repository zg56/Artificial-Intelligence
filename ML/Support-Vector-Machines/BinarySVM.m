%% CS 383 Zoltan Gercsak Binary SVM Assignment 7

clc;
close all;
clear all;

% read data file
filename = 'spambase.data';
data = csvread(filename);

% randomize the data
rng(0);
data = data(randperm(size(data,1)),:);

%% create training and testing set
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

trainFmean = mean(trainFeatures);
trainFstd = std(trainFeatures);
trainFnorm = (trainFeatures - repmat(trainFmean, size(trainFeatures,1), 1)) ./ repmat(trainFstd, size(trainFeatures,1), 1);
testFnorm = (testFeatures - repmat(trainFmean, numData, 1)) ./ repmat(trainFstd, numData, 1);


%% Train/test SVM

categories = unique(trainLabel);
dataClass = {};
for i = 1:size(categories,1)
dataClass{i} = trainFnorm(trainLabel==categories(i), :);
end

for i = 1:length(categories)
    for k = i+1:length(categories)
        label0 = repmat(categories(i), size(dataClass{i},1),1);
        label1 = repmat(categories(k), size(dataClass{k},1),1);
        data = [dataClass{i}; dataClass{k}];
        label = [label0; label1];     
    end
end

SVMModel = fitcsvm(data, label);
prediction = predict(SVMModel, testFnorm);


%% Compute Statistics

tp = sum((testLabel==1)&(prediction==1)); % true positive
tn = sum((testLabel==1)&(prediction==0)); % true negative
fp = sum((testLabel==0)&(prediction==1)); % false positive
fn = sum((testLabel==0)&(prediction==0)); % false negative

precision = tp/(tp+fp);
recall = tp/(tp+fn);
fmeasure = 2*precision*recall/(precision+recall);
accuracy = (tp+tn)/(tp+tn+fp+fn);

% print result
fprintf('Precision = %f\nRecall = %f\nFmeasure = %f\nAccuracy = %f\n', precision, recall, fmeasure, accuracy);

