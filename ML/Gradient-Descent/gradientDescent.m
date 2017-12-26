%% Zoltan Gercsak - Gradient Descent

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
testSet = ceil(size(data,1)*2/3)+1;
testing = data(testSet:end, :);
testFeatures = testing(:, 1:end-1);
testLabel = testing(:, end);

trainSet = ceil(size(data,1)*2/3);
training = data(1:trainSet, :);
trainFeatures = training(:, 1:end-1);
trainLabel = training(:, end);

%% Gradient Descent
numIteration = 1000;
learningRate = 0.01;

numData = size(testFeatures,1);

trainFmean = mean(trainFeatures);
trainFstd = std(trainFeatures);
trainFnorm = (trainFeatures - repmat(trainFmean, size(trainFeatures,1), 1)) ./ repmat(trainFstd, size(trainFeatures,1), 1);
testFnorm = (testFeatures - repmat(trainFmean, numData, 1)) ./ repmat(trainFstd, numData, 1);

trainFnorm = [ones(size(trainFnorm,1),1), trainFnorm];
testFnorm = [ones(size(testFnorm,1),1), testFnorm];

% initialize weight matrix
weight = (1 + 1) * rand((size(trainFnorm,2)), 1) + -1;

% compute error    
prediction = trainFnorm * weight;
mse = mean((trainLabel - prediction).^2);
trainError = sqrt(mse);

prediction2 = testFnorm * weight;
mse2 = mean((testLabel - prediction2).^2);
testError = sqrt(mse2);

oldRmse = trainError;

i = 1;
while i <= numIteration
    
    weightUpdate = zeros(size(weight));
    for i=1:size(weightUpdate,1)
        gradient = 0;
        for j=1:size(trainFnorm,1)
            gradient = gradient - trainFnorm(j,i)*(trainLabel(j) - trainFnorm(j,:)*weight);
        end
        weightUpdate(i) = weight(i) - learningRate * gradient;
    end
    weight = weightUpdate;
    
    % compute error    
    prediction = trainFnorm * weight;
    mse = mean((trainLabel - prediction).^2);
    trainRmse2 = sqrt(mse);
    
    prediction2 = testFnorm * weight;
    mse2 = mean((testLabel - prediction2).^2);
    testRmse2 = sqrt(mse2);
    
    trainError = [trainError, trainRmse2];
    testError = [testError, testRmse2];
    
    if( abs(100*(trainRmse2-oldRmse)/oldRmse) < eps)
            break;
    end
    oldRmse = trainRmse2;
    i = i + 1; 
    
end


%% Apply weight/compute error

normTestFeatures = (testFeatures - repmat(trainFmean, size(testFeatures,1), 1)) ./ repmat(trainFstd, size(testFeatures,1), 1);
normTestFeatures = [ones(size(normTestFeatures,1),1), normTestFeatures];
prediction = normTestFeatures * weight;
MSE = mean((testLabel - prediction).^2);
RMSE = sqrt(MSE);

%% plot/display results

fprintf('The final model y = %f + %fx1 + %fx2, RMSE = %f\n', weight(1), weight(2), weight(3), testError(end));


f1 = figure;
plot(trainError, 'r');
xmin = 0;
xmax = 60;
ymin = 500;
ymax = 4000;
axis([xmin,xmax,ymin,ymax]);
hold on;
plot(testError, 'b');
title('RMSE in each interation');
xlabel('Iteration');
ylabel('Root Mean Square Error');
legend('Training Error', 'Testing Error');
saveas(f1, 'RMSE.png');
hold off;




