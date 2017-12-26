function [ weight, meanValue, stdValue ] = CFLR( features, label )
    meanValue = mean(features);
    stdValue = std(features);
    X = (features - repmat(meanValue, size(features,1), 1)) ./ repmat(stdValue, size(features,1), 1);
    X = [ones(size(X,1),1), X];
    weight = (X'*X)\(X'*label);
end
