# Support Vector Machines

## Introduction

In this project, we will be using support vector machines (SVMs) to build
a spam classifier.

### Files included in this exercise
```
svm.m - MATLAB script for the first part
data1.mat - Example Dataset 1
data2.mat - Example Dataset 2
data3.mat - Example Dataset 3
svmTrain.m - SVM training function
svmPredict.m - SVM prediction function
plotData.m - Plot 2D data
visualizeBoundaryLinear.m - Plot linear boundary
visualizeBoundary.m - Plot non-linear boundary
linearKernel.m - Linear kernel for SVM
gaussianKernel.m - Gaussian kernel for SVM
dataset3Params.m - Parameters to use for Dataset 3
spam.m - MATLAB script for the second part
spamTrain.mat - Spam training set
spamTest.mat - Spam test set
emailSample1.txt - Sample email 1
emailSample2.txt - Sample email 2
spamSample1.txt - Sample spam 1
spamSample2.txt - Sample spam 2
vocab.txt - Vocabulary list
getVocabList.m - Load vocabulary list
porterStemmer.m - Stemming function
readFile.m - Reads a le into a character string
submit.m - Submission script that sends your solutions to our servers
processEmail.m - Email preprocessing
emailFeatures.m - Feature extraction from emails

```

## Support Vector Machines

In the first part, we will be using support vector machines
(SVMs) with various example 2D datasets. Experimenting with these datasets
will help us gain an intuition of how SVMs work and how to use a Gaussian
kernel with SVMs. In the next part, we will be using support
vector machines to build a spam classifier.

### 1.1 Example Dataset 1

We will begin by with a 2D example dataset which can be separated by a
linear boundary. The script svm.m will plot the training data. In
this dataset, the positions of the positive examples (indicated with +) and the
negative examples (indicated with o) suggest a natural separation indicated
by the gap. However, notice that there is an outlier positive example + on
the far left at about (0:1; 4:1). As part of this exercise, we will also see how
this outlier affects the SVM decision boundary.
We will try using different values of the C parameter with SVMs. Informally, the C parameter is a positive value that
controls the penalty for misclassiffied training examples. A large C parameter
tells the SVM to try to classify all the examples correctly. C plays a role
similar to 1/lambda, where lambda is the regularization parameter that we were using
previously for logistic regression.

### 1.2 SVM with Gaussian Kernels

In this part, we will be using SVMs to do non-linear classiffication. In particular, you will be using SVMs with Gaussian kernels on
datasets that are not linearly separable.

#### 1.2.1 Gaussian Kernel

To find non-linear decision boundaries with the SVM, we need to first implement a Gaussian kernel. We
can think of the Gaussian kernel as a similarity function that measures the "distance" between a pair of examples,
(x(i); x(j)). The Gaussian kernel is also parameterized by a bandwidth pa-
rameter, sigma, which determines how fast the similarity metric decreases (to 0)
as the examples are further apart.

#### 1.2.2 Example Data Set 2

The next part in svm.m will load and plot dataset 2. From
the figure, you can obserse that there is no linear decision boundary that
separates the positive and negative examples for this dataset. However, by
using the Gaussian kernel with the SVM, we will be able to learn a non-linear
decision boundary that can perform reasonably well for the dataset.
The decision boundary is able to separate most of the positive and
negative examples correctly and follows the contours of the dataset well.

#### 1.2.3 Example Data Set 3

In this part of the exercise, we will gain more practical skills on how to use
a SVM with a Gaussian kernel. 
In the provided dataset, data3.mat, we are given the variables X,
y, Xval, yval. The provided code in svm.m trains the SVM classiffier using
the training set (X, y) using parameters loaded from dataset3Params.m.
We should use the cross validation set Xval, yval to determine the
best C and sigma parameter to use. 


## Spam Classification

Many email services today provide spam filters that are able to classify emails
into spam and non-spam email with high accuracy. We will use SVMs to build your own spam filter.
We will be training a classiffier to classify whether a given email, x, is
spam (y = 1) or non-spam (y = 0). In particular, we need to convert each
email into a feature vector x 2 Rn. The dataset included for this project is based on a a subset of
the SpamAssassin Public Corpus.3 We will
only be using the body of the email (excluding the email headers). 

### 2.1 Preprocessing Emails

```
> Anyone knows how much it costs to host a web portal ?
>
Well, it depends on how many visitors youre expecting. This can be
anywhere from less than 10 bucks a month to a couple of $100. You
should checkout http://www.rackspace.com/ or perhaps Amazon EC2 if
youre running something big..
To unsubscribe yourself from this mailing list, send an email to:
groupname-unsubscribe@egroups.com
```
Before starting on a machine learning task, it is usually insightful to
take a look at examples from the dataset. Above shows a sample email
that contains a URL, an email address (at the end), numbers, and dollar
amounts. While many emails would contain similar types of entities (e.g.,
numbers, other URLs, or other email addresses), the specific entities (e.g.,
the specific URL or specific dollar amount) will be different in almost every
email. Therefore, one method often employed in processing emails is to
"normalize" these values, so that all URLs are treated the same, all numbers
are treated the same, etc. For example, we could replace each URL in the
email with the unique string "httpaddr" to indicate that a URL was present.

This has the effect of letting the spam classifier make a classification decision
based on whether any URL was present, rather than whether a specific URL
was present. This typically improves the performance of a spam classifier,
since spammers often randomize the URLs, and thus the odds of seeing any
particular URL again in a new piece of spam is very small.
In processEmail.m, following email preprocessing and normalization steps implemented:  
• Lower-casing: The entire email is converted into lower case, so
that captialization is ignored (e.g., IndIcaTE is treated the same as
Indicate).  
• Stripping HTML: All HTML tags are removed from the emails.
Many emails often come with HTML formatting; we remove all the
HTML tags, so that only the content remains.  
• Normalizing URLs: All URLs are replaced with the text "httpaddr".  
• Normalizing Email Addresses: All email addresses are replaced
with the text "emailaddr".  
• Normalizing Numbers: All numbers are replaced with the text
"number".  
• Normalizing Dollars: All dollar signs ($) are replaced with the text
"dollar".  
• Word Stemming: Words are reduced to their stemmed form. For ex-
ample, "discount", "discounts", "discounted" and "discounting" are all
replaced with "discount". Sometimes, the Stemmer actually strips of
additional characters from the end, so "include", "includes", "included",
and "including" are all replaced with "includ".  
• Removal of non-words: Non-words and punctuation have been removed. All white spaces (tabs, newlines, spaces) have all been trimmed
to a single space character.  

While preprocessing has left word fragments and non-words, this form turns out to be
much easier to work with for performing feature extraction.

#### 2.1.1 Vocabulary List

After preprocessing the emails, we have a list of words for
each email. The next step is to choose which words we would like to use in
our classifier and which we would want to leave out.
We have chosen only the most frequently occuring words as our set of words considered (the vocabulary list). Since words that occur
rarely in the training set are only in a few emails, they might cause the
model to overfit our training set. The complete vocabulary list is in the file
vocab.txt. Our vocabulary list was selected by choosing all words which occur at least a 100 times in the spam corpus,
resulting in a list of 1899 words. In practice, a vocabulary list with about
10,000 to 50,000 words is often used.
Given the vocabulary list, we can now map each word in the preprocessed
emails into a list of word indices that contains the index
of the word in the vocabulary list.

### 2.2 Extracting Features From Emails

We will now implement the feature extraction that converts each email into
a vector.

### 2.3 Training SVM for Spam Classification

After we have completed the feature extraction functions, the next step of
spam.m will load a preprocessed training dataset that will be used to train
a SVM classifier. spamTrain.mat contains 4000 training examples of spam
and non-spam email, while spamTest.mat contains 1000 test examples. Each
original email was processed using the processEmail and emailFeatures
functions and converted into a vector.
After loading the dataset, spam.m will proceed to train a SVM to
classify between spam (y = 1) and non-spam (y = 0) emails. 

### 2.4 Top Predictors for Spam

To better understand how the spam classifier works, we can inspect the
parameters to see which words the classifier thinks are the most predictive
of spam. The next step of spam.m finds the parameters with the largest
positive values in the classifier and displays the corresponding words. 
Thus, if an email contains words such as "guarantee", "remove", "dollar", and "price" , it is likely to be
classified as spam.




