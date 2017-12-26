%% Zoltan Gercsak - Multiclassification Artificial Neural Network

close all;
clear all;
clc;

% read data file
filename = 'CTG.csv';
data = csvread(filename, 2);

% randomize the data
rng(0);
data = data(randperm(size(data,1)),:);

% create training and testing set
training = data(1:ceil(size(data,1)*2/3), :);
trainFeatures = training(:, 1:end-2);
trainLabel = training(:, end);

testing = data(ceil(size(data,1)*2/3)+1:end, :);
testFeatures = testing(:, 1:end-2);
testLabel = testing(:, end);

% normalize data
numData = size(testFeatures,1);

trainMean = mean(trainFeatures);
trainSTD = std(trainFeatures);
trainFnorm = (trainFeatures - repmat(trainMean, size(trainFeatures,1), 1)) ./ repmat(trainSTD, size(trainFeatures,1), 1);
testFnorm = (testFeatures - repmat(trainMean, numData, 1)) ./ repmat(trainSTD, numData, 1);

%% Train program on training set

hiddenLayers = 20;
numOfClass = 3;
learningRate = 0.5;
iteration = 1000;

classes = unique(trainLabel);
labels = zeros(length(trainLabel), length(classes));
for i=1:length(trainLabel)
    labels(i,trainLabel(i)) = 1;
end


num_input = size(trainFnorm, 2);
model = multiClassification(num_input, hiddenLayers, numOfClass);
setOfErrors = zeros(1, iteration);

for i=1:iteration
    
    [prediction, hiddenOut] = forwardProp(trainFnorm, model);
    setOfErrors(i) = 1-sum(trainLabel == encodeClass(prediction))/length(trainLabel);
    model = backwardProp(model, learningRate, trainFnorm, hiddenOut, prediction, labels);
    
end

% test error
[prediction] = forwardProp(testFnorm, model);
testError = 1-sum(testLabel == encodeClass(prediction))/length(testLabel);

% print result
fprintf('Testing error = %f\n', testError);
f1 = figure;
plot(setOfErrors);
title('Training Error (Multiclass ANN)');
xlabel('Iteration');
ylabel('Training error');


%% Helper functions
function [ model ] = multiClassification( numInput, numHidden, numOfClass )
    [model.in_weight, model.in_bias] = makeLayer(numInput, numHidden);
    [model.out_weight, model.out_bias] = makeLayer(numHidden, numOfClass);
end

function [ weight, bias ] = makeLayer( numInput, numOutput )
    biasWeight = 2 * (rand(numInput+1, numOutput) - 0.5);
    weight = biasWeight(1:end-1, :);
    bias = biasWeight(end, :);
end

function [encode] = encodeClass(decode)
    [~, encode] = max(decode, [], 2);
end
