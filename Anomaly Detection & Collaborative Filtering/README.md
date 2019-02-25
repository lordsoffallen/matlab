
# Anomaly Detection and Recommender  Systems

## Introduction

In this project, we will implement the anomaly detection algorithm and
apply it to detect failing servers on a network. In the second part, we will
use collaborative filtering to build a recommender system for movies. 

### Files included in this exercise

```
FindOutliers.m-  MATLAB script for first part
collaborativeFilter.m- MATLAB script for second part
data1.mat- First example Dataset for anomaly detection
data2.mat- Second example Dataset for anomaly detection
movies.mat- Movie Review Dataset
movieParams.mat- Parameters provided for debugging
multivariateGaussian.m- Computes the probability density function
for a Gaussian distribution
visualizeFit.m- 2D plot of a Gaussian distribution and a dataset
checkCostFunction.m- Gradient checking for collaborative filtering
computeNumericalGradient.m- Numerically compute gradients
```

```
fmincg.m- Function minimization routine (similar to fminunc)
loadMovieList.m- Loads the list of movies into a cell-array
movieids.txt- List of movies
normalizeRatings.m- Mean normalization for collaborative filtering
estimateGaussian.m- Estimate the parameters of a Gaussian dis-
tribution with a diagonal covariance matrix
selectThreshold.m- Find a threshold for anomaly detection
cofiCostFunc.m- Implement the cost function for collaborative fil-
tering
```

## 1 Anomaly detection

In this part, we will implement an anomaly detection algorithm to detect
anomalous behavior in server computers. The features measure the through-
put (mb/s) and latency (ms) of response of each server. While our servers
were operating, we collected m= 307 examples of how they were behaving,
and thus have an unlabeled dataset{x(1),...,x(m)}. You suspect that the
vast majority of these examples are “normal” (non-anomalous) examples of
the servers operating normally, but there might also be some examples of
servers acting anomalously within this dataset.
We will use a Gaussian model to detect anomalous examples in your
dataset. We will first start on a 2D dataset that will allow you to visualize
what the algorithm is doing. On that dataset we will fit a Gaussian dis-
tribution and then find values that have very low probability and hence can
be considered anomalies. After that, we will apply the anomaly detection
algorithm to a larger dataset with many dimensions.

### 1.1 Gaussian distribution

To perform anomaly detection, we will first need to fit a model to the data’s
distribution.

Given a training set {x(1),...,x(m)}(wherex(i)∈Rn), we want to estimate the Gaussian distribution for each of the features xi. For each feature
i= 1...n, you need to find parameters μi and σ^2 i that fit the data in the i-th dimension{x(1)i ,...,x(im)}(the i-th dimension of each example).


### 1.2 Estimating parameters for a Gaussian

estimateGaussian function takes as input the data matrix X and should output an n-dimension vector
mu that holds the mean of all the n features and another n-dimension vector
sigma2 that holds the variances of all the features. We can implement this
using a for-loop over every feature and every training example (though a
vectorized implementation would be more efficient).


### 1.3 Selecting the threshold,ε

Now that we have estimated the Gaussian parameters, we can investigate
which examples have a very high probability given this distribution and which
examples have a very low probability. The low probability examples are
more likely to be the anomalies in our dataset. One way to determine which
examples are anomalies is to select a threshold based on a cross validation
set. In this part, we will implement an algorithm to select
the threshold ε using the F1 score on a cross validation set.


### 1.4 High dimensional dataset

The last part of the script FindOutliers.m will run the anomaly detection algorithm
we implemented on a more realistic and much harder dataset. In this
dataset, each example is described by 11 features, capturing many more
properties of your compute servers.
The script will use our code to estimate the Gaussian parameters (μi and
σ^2 i), evaluate the probabilities for both the training data X from which you
estimated the Gaussian parameters, and do so for the the cross-validation
set X val. Finally, it will use selectThreshold to find the best thresholdε.


## 2 Recommender Systems

In this part, we will implement the collaborative filtering
learning algorithm and apply it to a dataset of movie ratings.^2 This dataset
consists of ratings on a scale of 1 to 5. The dataset has nu= 943 users, and
nm= 1682 movies.

In the next parts, we will implement the function cofiCostFunc.m
that computes the collaborative filtering objective function and gradient. Af-
ter implementing the cost function and gradient, we will use fmincg.m to
learn the parameters for collaborative filtering.

### 2.1 Movie ratings dataset

The first part of the script collaborativeFilter.m will load the dataset movies.mat,
providing the variables Y and R in our MATLAB environment.
The matrix Y(a num movies×num users matrix) stores the ratingsy(i,j)
(from 1 to 5). The matrix R is an binary-valued indicator matrix, where
R(i,j) = 1 if user j gave a rating to movie i, and R(i,j) = 0 otherwise. The
objective of collaborative filtering is to predict movie ratings for the movies
that users have not yet rated, that is, the entries with R(i,j) = 0. This will
allow us to recommend the movies with the highest predicted ratings to the
user.


### 2.2 Collaborative filtering learning algorithm

We will start by implementing the cost function (without regularization).
The collaborative filtering algorithm in the setting of movie recommendations 
considers a set of n-dimensional parameter vectors x(1),...,x(nm) and
θ(1),...,θ(nu), where the model predicts the rating for movie i by user j as
y(i,j)= (θ(j)) Tx(i).

2.2.1 Collaborative filtering gradient

Now, we should implement the gradient (without regularization). Note that X grad should be a matrix of the
same size as X and similarly, Thetagrad is a matrix of the same size as
Theta. The gradients of the cost function is given by:
 
Note that the function returns the gradient for both sets of variables
by unrolling them into a single vector. 

 
2.2.2 Regularized cost function

Now it is time to add to regularization to our cost function.

2.2.3 Regularized gradient

Now that we have implemented the regularized cost function, we should
proceed to implement regularization for the gradient. 
 
This means that we just need to add λx(i) to the X grad(i,:) variable
described earlier, and add λθ(j)to the Thetagrad(j,:) variable described
earlier.
 
### 2.3 Learning movie recommendations

After we have finished implementing the collaborative filtering cost function
and gradient, we can now start training your algorithm to make movie
recommendations. In the next part,we can enter our own movie preferences, so that later when the algorithm
runs, we can get our own movie recommendations! The list of all movies and their number in the
dataset can be found listed in the file movieidx.txt.

2.3.1 Recommendations

```
Top recommendations for you:
Predicting rating 9.0 for movie Titanic (1997)
Predicting rating 8.9 for movie Star Wars (1977)
Predicting rating 8.8 for movie Shawshank Redemption, The (1994)
Predicting rating 8.5 for movie As Good As It Gets (1997)
Predicting rating 8.5 for movie Good Will Hunting (1997)
Predicting rating 8.5 for movie Usual Suspects, The (1995)
Predicting rating 8.5 for movie Schindler’s List (1993)
Predicting rating 8.4 for movie Raiders of the Lost Ark (1981)
Predicting rating 8.4 for movie Empire Strikes Back, The (1980)
Predicting rating 8.4 for movie Braveheart (1995)
```
```
Original ratings provided:
Rated 4 for Toy Story (1995)
Rated 3 for Twelve Monkeys (1995)
Rated 5 for Usual Suspects, The (1995)
Rated 4 for Outbreak (1995)
Rated 5 for Shawshank Redemption, The (1994)
Rated 3 for While You Were Sleeping (1995)
Rated 5 for Forrest Gump (1994)
Rated 2 for Silence of the Lambs, The (1991)
Rated 4 for Alien (1979)
Rated 5 for Die Hard 2 (1990)
Rated 5 for Sphere (1998)
```
.


