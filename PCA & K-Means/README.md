# PCA and K-Mean Clustering

## Introduction

Purpose is to implement the K-means clustering algorithm and
apply it to compress an image. In the second part, using principal
component analysis to find a low-dimensional representation of face images.


### Files included in this project

```
kmeans.m- Octave/MATLAB script for the first part on K-means
main-pca.m- Octave/MATLAB script for the second part on PCA
data1.mat- Example Dataset for PCA
data2.mat- Example Dataset forK-means
faces.mat- Faces Dataset
birdsmall.png- Example Image
displayData.m- Displays 2D data stored in a matrix
drawLine.m- Draws a line over an exsiting figure
plotDataPoints.m- Initialization forK-means centroids
plotProgresskMeans.m- Plots each step ofK-means as it proceeds
```

```
runkMeans.m- Runs theK-means algorithm
pca.m- Perform principal component analysis
projectData.m- Projects a data set into a lower dimensional space
recoverData.m- Recovers the original data from the projection
findClosestCentroids.m- Find closest centroids (used inK-means)
computeCentroids.m- Compute centroid means (used inK-means)
kMeansInitCentroids.m- Initialization forK-means centroids

```

## 1 K-means Clustering

This part is to implement theK-means algorithm and use it
for image compression. First starting on an example 2D dataset that
will help us gain an intuition of how theK-means algorithm works. After
that, we will use theK-means algorithm for image compression by reducing
the number of colors that occur in an image to only those that are most
common in that image. We will be using kmeans.m for this part.

### 1.1 ImplementingK-means

TheK-means algorithm is a method to automatically cluster similar data
examples together. Concretely, we are given a training set{x(1),...,x(m)}
(wherex(i)∈Rn), and want to group the data into a few cohesive “clusters”.
The intuition behindK-means is an iterative procedure that starts by guess-
ing the initial centroids, and then refines this guess by repeatedly assigning
examples to their closest centroids and then recomputing the centroids based
on the assignments.
TheK-means algorithm is as follows:

```
% Initialize centroids
centroids = kMeansInitCentroids(X, K);
for iter = 1:iterations
% Cluster assignment step: Assign each data point to the
% closest centroid. idx(i) corresponds to cˆ(i), the index
% of the centroid assigned to example i
idx = findClosestCentroids(X, centroids);

% Move centroid step: Compute means based on centroid
% assignments
centroids = computeMeans(X, idx, K);
end
```
The inner-loop of the algorithm repeatedly carries out two steps: (i) As-
signing each training example x(i) to its closest centroid, and (ii) Recomput-
ing the mean of each centroid using the points assigned to it. The K-means
algorithm will always converge to some final set of means for the centroids.
Note that the converged solution may not always be ideal and depends on the
initial setting of the centroids. Therefore, in practice the K-means algorithm
is usually run a few times with different random initializations. One way to
choose between these different solutions from different random initializations
is to choose the one with the lowest cost function value (distortion).

1.1.1 Finding closest centroids

In the “cluster assignment” phase of the K-means algorithm, the algorithm
assigns every training examplex(i)to its closest centroid, given the current
positions of centroids. Specifically, for every example i we set

```
c(i):=j that minimizes ||x(i)−μj||^2 ,
```
where c(i) is the index of the centroid that is closest to x(i), and μj is the
position (value) of the j’th centroid. Note that c(i) corresponds to idx(i) in
the code.
findClosestCentroids function takes the data matrix X and the locations of all centroids inside
centroidsand should output a one-dimensional array idx that holds the
index (a value in{ 1 ,...,K}, where K is total number of centroids) of the
closest centroid to every training example.
We can implement this using a loop over every training example and
every centroid.

1.1.2 Computing centroid means

Given assignments of every point to a centroid, the second phase of the
algorithm recomputes, for each centroid, the mean of the points that were
assigned to it.
We can implement incomputeCentroids function using a loop over the centroids. We can also use a
loop over the examples; but if we can use a vectorized implementation that
does not use such a loop, our code may run faster.


### 1.2 K-means on example dataset


After two functions (findClosestCentroidsand
computeCentroids), the next step in kmeans.m will run the K-means algorithm
on a toy 2D dataset to help us understand how K-means works. Our
functions are called from inside the runKmeans.m script. Notice that the
code calls the two functions we implemented in a loop.
When we run the next step, the K-means code will produce a visualiza-
tion that steps you through the progress of the algorithm at each iteration.
Pressenter multiple times to see how each step of the K-means algorithm
changes the centroids and cluster assignments. 


### 1.3 Random initialization

In this part, we should complete the functionkMeansInitCentroids.m
with the following code:

```
% Initialize the centroids to be random examples
% Randomly reorder the indices of examples
randidx = randperm(size(X, 1));
% Take the first K examples as centroids
centroids = X(randidx(1:K), :);
```

The code above first randomly permutes the indices of the examples (us-
ingrandperm). Then, it selects the first K examples based on the random
permutation of the indices. This allows the examples to be selected at ran-
dom without the risk of selecting the same example twice.


### 1.4 Image compression withK-means


In this part, we will apply K-means to image compression. In a
straightforward 24-bit color representation of an image,^2 each pixel is repre-
sented as three 8-bit unsigned integers (ranging from 0 to 255) that specify
the red, green and blue intensity values. This encoding is often refered to as
the RGB encoding. Our image contains thousands of colors, and in this part,
we will reduce the number of colors to 16 colors.
By making this reduction, it is possible to represent (compress) the photo
in an efficient way. Specifically, you only need to store the RGB values of
the 16 selected colors, and for each pixel in the image you now need to only
store the index of the color at that location (where only 4 bits are necessary
to represent 16 possibilities).We will use the K-means algorithm to select the 16 colors
that will be used to represent the compressed image. Concretely, we will
treat every pixel in the original image as a data example and use the K-means
algorithm to find the 16 colors that best group (cluster) the pixels in the 3-
dimensional RGB space. Once we have computed the cluster centroids on
the image, we will then use the 16 colors to replace the pixels in the original
image.

1.4.1 K-means on pixels

In MATLAB, images can be read in as follows:

```
% Load 128x128 color image (birdsmall.png)
A = imread('birdsmall.png');

% We will need to have installed the image package to used
% imread. If you do not have the image package installed, you
% should instead change the following line to
%
% load('birdsmall.mat'); % Loads the image into the variable A
```

This creates a three-dimensional matrix A whose first two indices identify
a pixel position and whose last index represents red, green, or blue. For
example, A(50, 33, 3) gives the blue intensity of the pixel at row 50 and
column 33.
The code inside kmeans.m first loads the image, and then reshapes it to create
anm×3 matrix of pixel colors (wherem= 16384 = 128×128), and calls K-means function on it.
After finding the top K= 16 colors to represent the image, we can now 
assign each pixel position to its closest centroid using thefindClosestCentroids
function. This allows you to represent the original image using the centroid
assignments of each pixel. Notice that we have significantly reduced the
number of bits that are required to describe the image. The original image
required 24 bits for each one of the 128×128 pixel locations, resulting in total
size of 128× 128 ×24 = 393,216 bits. The new representation requires some
overhead storage in form of a dictionary of 16 colors, each of which require
24 bits, but the image itself then only requires 4 bits per pixel location. The
final number of bits used is therefore 16×24 + 128× 128 ×4 = 65,920 bits,
which corresponds to compressing the original image by about a factor of 6.


Finally, we can view the effects of the compression by reconstructing the
image based only on the centroid assignments. Specifically, we can replace
each pixel location with the mean of the centroid assigned to it.  Even though the resulting image re-
tains most of the characteristics of the original, we also see some compression
artifacts.


## 2 Principal Component Analysis

We will use principal component analysis (PCA) to perform
dimensionality reduction. We will first experiment with an example 2D
dataset to get intuition on how PCA works, and then use it on a bigger
dataset of 5000 face image dataset.


### 2.1 Dataset

We will first start with a 2D dataset which has one direction of large variation and one of smaller variation. The
script main-pca.m will plot the training data. In this part, we will visualize what happens when we use PCA to reduce the
data from 2D to 1D. In practice, we might want to reduce data from 256 to
50 dimensions, say; but using lower dimensional data in this example allows
us to visualize the algorithms better.


### 2.2 Implementing PCA

PCA consists of two computational steps: First, we compute the covariance matrix of the data.

Then, we use MATLAB’s SVD function to compute the eigenvectors U1 ,U2 ,...,Un. 
These will correspond to the principal components of variation in the data.
Before using PCA, it is important to first normalize the data by subtract-
ing the mean value of each feature from the dataset, and scaling each dimen-
sion so that they are in the same range. In the script main-pca.m,
this normalization has been performed using thefeatureNormalize
function.
After normalizing the data, we can run PCA to compute the principal
components. First, we should compute the covariance
matrix of the data.
After computing the covariance matrix, we can run SVD on it to compute
the principal components. In MATLAB, we can run SVD with the
following command: [U, S, V] = svd(Sigma), where U will contain the
principal components and S will contain a diagonal matrix.

The script will also output the top principal component (eigen-
vector) found.


### 2.3 Dimensionality Reduction with PCA

After computing the principal components, we can use them to reduce the
feature dimension of your dataset by projecting each example onto a lower
dimensional space, x(i)→z(i) (e.g., projecting the data from 2D to 1D). In
this part, we will use the eigenvectors returned by PCA and
project the example dataset into a 1-dimensional space.
In practice, if we were using a learning algorithm such as linear regression
or perhaps neural networks, we could now use the projected data instead
of the original data. By using the projected data, we can train your model
faster as there are less dimensions in the input.

2.3.1 Projecting the data onto the principal components

We should now complete the funtion projectData.m. Specifically, we are
given a dataset X, the principal components U, and the desired number of
dimensions to reduce to K. We should project each example in X onto the
top K components in U. Note that the top K components in U are given by
the first K columns of U, that is U reduce = U(:, 1:K).

2.3.2 Reconstructing an approximation of the data

After projecting the data onto the lower dimensional space, we can 
approximately recover the data by projecting them back onto the original high
dimensional space. Our task is to complete recoverData.m to project each
example in Z back onto the original space and return the recovered approximation in X rec.


### 2.4 Face Image Dataset

In this part, we will run PCA on face images to see how it
can be used in practice for dimension reduction. The dataset faces.mat
contains a dataset^3 X of face images, each 32×32 in grayscale. Each row
of X corresponds to one face image (a row vector of length 1024). The next 
step in main-pca.m will load and visualize the first 100 of these face images


2.4.1 PCA on Faces

To run PCA on the face dataset, we first normalize the dataset by subtracting
the mean of each feature from the data matrix X. After running PCA, we will
obtain the principal components of the dataset. Notice that each principal
component in U(each row) is a vector of length n(where for the face dataset,
n= 1024). It turns out that we can visualize these principal components by
reshaping each of them into a 32×32 matrix that corresponds to the pixels
in the original dataset. The script main-pca.m displays the first 36 principal
components that describe the largest variations.

2.4.2 Dimensionality Reduction

Now that we have computed the principal components for the face dataset,
we can use it to reduce the dimension of the face dataset. This allows us to
use our learning algorithm with a smaller input size (e.g., 100 dimensions)
instead of the original 1024 dimensions. This can help speed up your learning
algorithm.


The next part in main-pca.m will project the face dataset onto only the
first 100 principal components. Concretely, each face image is now described
by a vectorz(i)∈R^100.
To understand what is lost in the dimension reduction, you can recover
the data using only the projected dataset. In main-pca.m, an approximate
recovery of the data is performed and the original and projected face images
are displayed side by side. From the reconstruction, we can observe 
that the general structure and appearance of the face are kept while
the fine details are lost. This is a remarkable reduction (more than 10×) in
the dataset size that can help speed up our learning algorithm significantly.
For example, if we were training a neural network to perform person recog-
nition (gven a face image, predict the identitfy of the person), you can use
the dimension reduced input of only a 100 dimensions instead of the original
pixels.

### 2.5 PCA for visualization


In the earlier K-means image compression part, we used the K-means
algorithm in the 3-dimensional RGB space. In the last part of the main-pca.m
script, we have provided code to visualize the final pixel assignments in this
3D space using the scatter3 function. Each data point is colored according
to the cluster it has been assigned to. We can drag your mouse on the figure
to rotate and inspect this data in 3 dimensions.
It turns out that visualizing datasets in 3 dimensions or greater can be
cumbersome. Therefore, it is often desirable to only display the data in 2D
even at the cost of losing some information. In practice, PCA is often used to
reduce the dimensionality of data for visualization purposes. In the next part, 
the script will apply our implementation of PCA to the 3- dimensional data to reduce it to 
2 dimensions and visualize the result in a 2D
scatter plot. The PCA projection can be thought of as a rotation that selects
the view that maximizes the spread of the data, which often corresponds to
the “best” view.
