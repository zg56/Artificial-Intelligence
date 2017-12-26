%% Zoltan Gercsak - S-Folds Cross Validation

clc;
close all;
clear all;

% read data file
filename = 'x06Simple.csv';
data = csvread(filename, 1);
data = data(:, 2:end);

% randomization of the data
rng(0);
data = data(randperm(size(data,1)),:);

% create features and label
features = data(:, 1:end-1);
label = data(:, end);


%% Calculate rmse with s-fold cross validation

foldNum = 5;
lengthData = size(features,1);

order = 1:lengthData;
foldIndex = cell(foldNum);
for i = 1:foldNum
    foldIndex{i} = order(i:foldNum:lengthData);
end

labelSet = [];
predictionSet = [];
i = 1;
while i <= foldNum
    
    testIndex = foldIndex{i};
    trainIndex = [];
    for j = 1:size(foldIndex, 1)
        if j ~= i
            trainIndex = [trainIndex, foldIndex{j}];
        end
    end
   
    % create training data
    foldFeature = features(trainIndex,:);
    foldLabel = label(trainIndex,:);

    % create testing data
    testFeature = features(testIndex,:);
    testLabel = label(testIndex,:);
    
        % compute rmse
    [weight, meanValue, stdValue] = CFLR(foldFeature, foldLabel);

    normTestData = (testFeature - repmat(meanValue, size(testFeature,1), 1)) ./ repmat(stdValue, size(testFeature,1), 1);
    normTestData = [ones(size(normTestData,1),1), normTestData];
    prediction = normTestData * weight;

    labelSet = [labelSet; testLabel];
    predictionSet = [predictionSet; prediction];
    i = i + 1;
end
mse = mean((labelSet - predictionSet).^2);
rmse = sqrt(mse);

% print out result
fprintf('RMSE = %f\n', rmse);

