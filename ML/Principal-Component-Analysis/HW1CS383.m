%% Zoltan Gercsak CS 383 Assignment 1 Winter 2017
% PCA Projection

clear all;
close all;

%% read data file

filename = 'diabetes.csv';
data = csvread(filename);
class_label = data(:,1);
sample_data = data(:,2:9);

%% normalize data
mean_data = mean(sample_data);
std_data = std(sample_data);
X = (sample_data - mean_data(ones(size(sample_data,1),1),:)) ./ std_data(ones(size(sample_data,1),1),:);

%% compute eigenvalues and eigenvectors
cov_matrix = cov(X);
[eigenvactors, similar] = eig(cov_matrix);
eigenvalues = diag(similar);

[sorted_eigenvalues, order_index] = sort(eigenvalues, 'descend');
W = eigenvactors(:,order_index(1:2));

projected_data = X * W;

%% plot data 

f = figure;
plot(projected_data(class_label==-1,1), projected_data(class_label==-1,2), 'bx');
hold on
plot(projected_data(class_label==1,1), projected_data(class_label==1,2), 'ro');
legend('-1 data', '+1 data');
hold off
title('2D PCA Projection of diabetes data');
saveas(f, 'PCAprojection.png');
