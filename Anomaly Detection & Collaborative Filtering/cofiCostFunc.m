function [J, grad] = cofiCostFunc(params, Y, R, num_users, num_movies, ...
                                  num_features, lambda)
%COFICOSTFUNC Collaborative filtering cost function
%   [J, grad] = COFICOSTFUNC(params, Y, R, num_users, num_movies, ...
%   num_features, lambda) returns the cost and gradient for the
%   collaborative filtering problem.
%

% Unfold the U and W matrices from params
X = reshape(params(1:num_movies*num_features), num_movies, num_features);
Theta = reshape(params(num_movies*num_features+1:end), ...
                num_users, num_features);

            
% return the following values correctly
J = 0;
X_grad = zeros(size(X));
Theta_grad = zeros(size(Theta));

h = ((X * Theta').*R) - (Y.*R);       % num_movies x num_users 
J = (1/2)*sum(sum(h.^2));

X_grad = h*Theta;             % num_movies x num_users  X  num_users  x num_features
Theta_grad = h'*X;            % num_users  x num_movies X  num_movies  x num_features

regularization = (lambda/2)*(sum(sum(Theta.^2)) + sum(sum(X.^2)));
J = J + regularization;

X_reg = lambda.*X; 
Theta_reg = lambda.*Theta;
X_grad = X_grad + X_reg;
Theta_grad = Theta_grad + Theta_reg;

% =============================================================

grad = [X_grad(:); Theta_grad(:)];

end
