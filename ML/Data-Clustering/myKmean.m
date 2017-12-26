%% Kmean function & Clustering

function [dataOut, dataSeed, initialMean, finalMean, numOfExecution] = myKmean(data, numOfIteration)

rng(0);

% normalize data
stdData = std(data);
meanData = mean(data);

normalizeData = (data - meanData(ones(size(data,1),1),:)) ./ stdData(ones(size(data,1),1),:);

permutation = randperm(size(normalizeData,1));

% seed the data
dataSeed = normalizeData(permutation(1:2), :);

% begin clustering

dataNum = size(normalizeData, 1);
resCluster = zeros(dataNum, 1);
numCluster = size(dataSeed, 1);


for i=1:dataNum
    element = normalizeData(i, :);
%   V = (dataSeed - element(ones(numCluster,1),:));
%   setDistance = sqrt(V * V');
%   setDistance = norm((dataSeed - element(ones(numCluster,1),:)));
    setDistance = sqrt(sum((dataSeed - element(ones(numCluster,1),:)).^2,2));
    [sorted_distance, order_index] = sort(setDistance);
    resCluster(i) = order_index(1);
end

% update mean
initialMean = dataSeed;
for i=1:numCluster
    initialMean(i, :) = mean(normalizeData(resCluster==i, :));
end

% iteration

finalMean = initialMean;
endCluster = resCluster;
numOfExecution = 1;

dataNum2 = size(normalizeData, 1);
numCluster2 = size(finalMean, 1);

for i=2:numOfIteration
    numOfExecution = i;
    tempMean = finalMean;
    for i=1:dataNum2
        element = normalizeData(i, :);
%       V2 = (finalMean - element(ones(2,1),:));
%       setDistance = sqrt((V2 * V2'),2);
%       setDistance = norm((finalMean - element(ones(2,1),:)));
        setDistance = sqrt(sum((finalMean - element(ones(2,1),:)).^2,2));
        [sorted_distance, order_index] = sort(setDistance);
        endCluster(i) = order_index(1);
    end
    
    % update mean
    finalMean = initialMean;
    for i=1:numCluster
        finalMean(i, :) = mean(normalizeData(endCluster==i, :));
    end
    if(norm(tempMean(1,:)-finalMean(1,:)) + norm(tempMean(2,:)-finalMean(2,:)) < eps)
        break;
    end
end
dataOut = [normalizeData, resCluster, endCluster];
end


