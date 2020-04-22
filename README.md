# handwritten-digit-recognition
implementation of handwritten digit recognition of MNIST database

## Introduction
1 word_recognition: the main function includes preparation stage, train stage and test stage
    
    1.1 preparation stage: loading train and test stages, processing datas
    1.2 train stage: calculating transform matrix using PCA based on training images, calculating every category's mean and covariance
    1.3 test stage: reducing the dimension of test images based on transform matrix, 
    calculating the posterior probability of every image is belonged to every category and finding the right category based on MAP

2 curve.bmp show the relationship between accuracy and dimensionality reduction of PCA

3 changing the value of "dimension" in word_recognition can get different accuracy rate


