%% Main driver Zoltan Gercsak CS 383 Homework 2 - Clustering

clc;
close all;
clear all;

numIterate = 10000;

% read data file
filename = 'diabetes.csv';
data = csvread(filename);
classLabel = data(:,1);
data = data(:,[7, 8]);


% calculate k-mean of data
[dataOut, dataSeed, initialMean, finalMean, numOfExecution] = myKmean(data, numIterate);

% plot initial seeds
f1 = figure;
plot(dataOut(:,2), dataOut(:,1), 'rx', dataSeed(:,2), dataSeed(:,1), 'bo');
title('Initial Seeds');
saveas(f1, 'initialSeeds.png');

% plot initial iteration of clustering
f2 = figure;
plot(dataOut((dataOut(:,3)==1),2), dataOut((dataOut(:,3)==1),1), 'rx');
hold on;
plot(initialMean(2,2), initialMean(2,1), 'bo');
plot(dataOut((dataOut(:,3)==2),2), dataOut((dataOut(:,3)==2),1), 'bx');
plot(initialMean(1,2), initialMean(1,1), 'ro');
title('Initial Clustering');
hold off;
saveas(f2, 'initialClustering.png');


% plot final clustering
f3 = figure;
plot(dataOut((dataOut(:,4)==1),2), dataOut((dataOut(:,4)==1),1), 'rx');
hold on;
plot(finalMean(2,2), finalMean(2,1), 'bo');
plot(dataOut((dataOut(:,4)==2),2), dataOut((dataOut(:,4)==2),1), 'bx');
plot(finalMean(1,2), finalMean(1,1), 'ro');
title(['After ' int2str(numOfExecution) ' iterations']);
hold off;
saveas(f3, 'finalClustering.png');