function [C, sigma] = dataset3Params(X, y, Xval, yval)
%DATASET3PARAMS returns your choice of C and sigma for Part 3 
%where you select the optimal (C, sigma) learning parameters to use for SVM
%with RBF kernel
%   [C, sigma] = DATASET3PARAMS(X, y, Xval, yval) returns your choice of C and 
%   sigma. 
%

% return the following variables correctly.
C = 1;
sigma = 0.3;


test = [0.01, 0.03, 0.1, 0.3, 1, 3, 10, 30];
error_values = zeros(length(test),length(test));
i = 1;
for iC = test
    j = 1;
    for iSigma = test
        iModel = svmTrain(X, y, iC, @(x1, x2) gaussianKernel(x1, x2, iSigma)); 
        predictions = svmPredict(iModel, Xval);
        error_values(i,j) = mean(double(predictions ~= yval));
        j = j + 1;
    end
    i = i + 1;
end
[~, ind] = min(error_values(:));
[row, col] = ind2sub(size(error_values),ind);
C = test(row);
sigma = test(col);


end
