%% Zoltan Gercsak - Binary ANN

close all;
clear all;
clc;


% read data file
filename = 'spambase.data';
data = csvread(filename);

% randomize the data
rng(0);
data = data(randperm(size(data,1)),:);

% create training and testing set
training = data(1:ceil(size(data,1)*2/3), :);
trainFeatures = training(:, 1:end-1);
trainLabel = training(:, end);

testing = data(ceil(size(data,1)*2/3)+1:end, :);
testFeatures = testing(:, 1:end-1);
testLabel = testing(:, end);

% normalize data
numData = size(testFeatures,1);

trainMean = mean(trainFeatures);
trainSTD = std(trainFeatures);
trainFnorm = (trainFeatures - repmat(trainMean, size(trainFeatures,1), 1)) ./ repmat(trainSTD, size(trainFeatures,1), 1);
testFnorm = (testFeatures - repmat(trainMean, numData, 1)) ./ repmat(trainSTD, numData, 1);

%% Train program on training data, setting treshold/iteration/learning rate
hiddenLayers = 20;
learningRate = 0.5;
iteration = 1000;
tresh = 0.5;

numInput = size(trainFnorm, 2);

model = createBinaryClass(numInput, hiddenLayers);
setOfErrors = zeros(1, iteration);

for i=1:iteration
    
    [trainPrediction, hiddenOut] = forwardProp(trainFnorm, model);  
    classified = trainPrediction;
    classified(classified<=tresh) = 0;
    classified(classified>tresh) = 1;

    setOfErrors(i) = 1-sum(trainLabel == classified)/length(trainLabel);
    model = backwardProp(model, learningRate, trainFnorm, hiddenOut, trainPrediction, trainLabel);
    
end

% test error

[prediction, hidden] = forwardProp(testFnorm, model);
classified = prediction;
classified(classified>tresh) = 1;
classified(classified<=tresh) = 0;

testError = 1-sum(testLabel == classified)/length(testLabel);

% precision & recall
precision = [];
recall = [];
for tresh=0:0.1:1
    classified = prediction;
    classified(classified>tresh) = 1;
    classified(classified<=tresh) = 0;

    % precision, recall, f-measure, accuracy
    tp = sum((testLabel==1)&(classified==1)); % true positive
    fp = sum((testLabel==0)&(classified==1)); % false positive
    fn = sum((testLabel==1)&(classified==0)); % false negative
    tn = sum((testLabel==0)&(classified==0)); % true negative

    if(tp==0 & fp==0)
        precision = [precision 1];
    else
        precision = [precision tp/(tp+fp)];
    end
    recall = [recall tp/(tp+fn)];
end

% print result

fprintf('Testing error = %f\n', testError);
f = figure;
plot(setOfErrors);
title('Training error for ANN');
xlabel('Iteration');
ylabel('Training Error');

f2 = figure;
plot(precision, recall, '-o');
title('Detect spam');
xlabel('Precision');
ylabel('Recall');


%% Helper functions
function [ model ] = createBinaryClass( numInput, numHidden )
    [model.in_bias, model.in_weight ] = makeLayer(numInput, numHidden);
    [model.out_bias, model.out_weight] = makeLayer(numHidden, 1);
end

function [ weight, bias ] = makeLayer( numInput, numOutput )
    biasWeight = 2 * (rand(numInput+1, numOutput) - 0.5);
    weight = biasWeight(1:end-1, :);
    bias = biasWeight(end, :);
end




