clc;
clear all;

%%
%%%%%%%preparation stage%%%%%%%%%
%import data
train_images = loadImages('train-images.idx3-ubyte');
train_labels = loadLabels('train-labels.idx1-ubyte');
test_images = loadImages('t10k-images.idx3-ubyte');
test_labels = loadLabels('t10k-labels.idx1-ubyte');

%image processing to prevent singular solutions in PCA stage
train_images = guiyihua(train_images);
test_images = guiyihua(test_images);

%reshape matrixs
train_images = reshape(train_images, size(train_images, 1)*size(train_images, 2) , size(train_images, 3));
test_images = reshape(test_images, size(test_images, 1)*size(test_images, 2) , size(test_images, 3));
train_images = train_images';
test_images = test_images';

%recording every category's prior probability
PH_every_category = prior_probability(train_labels);

%%
%%%%%%%%%train stage%%%%%%%%%%%%
%the parameter can be changed
dimension = 46;

[trainimg_reduce,infor_percent,transform_matrix] = PCA_reduction(train_images,dimension);
%trainimg_reduce:the result of multiply trainimages of transform_matrix
%infor_percent:proportion of sum of eigenvalues of principal components to sum of total eigenvalues
%transform_matrix:feature matrix of PCA

mu_all_category = zeros(10,dimension);
sigma_all_category = zeros(dimension,dimension,10);
sigma_inverse_all_category = zeros(dimension,dimension,10);

for i = 1:1:10
    location_num = find(train_labels ==  i-1);
    sample_one_kind = trainimg_reduce(location_num,:);
    mu_all_category(i,:) = MEAN(sample_one_kind);
    sigma_all_category(:,:,i) = SIGMA(sample_one_kind);
    sigma_inverse_all_category(:,:,i) = inv(sigma_all_category(:,:,i));  
end


%%
%%%%%%%%%test stage%%%%%%%%%%%%%
%the following method exploits parallel processing
test_dimension_reduce = test_images*transform_matrix;

[row_num,column_num] = size(test_dimension_reduce);

test_decenter_img = zeros(row_num,column_num,10);
test_SIGMA_inverse = zeros(column_num,row_num,10);
test_exponent = zeros(row_num,column_num,10);

for i = 1:1:10
    test_decenter_img(:,:,i) = test_dimension_reduce - ones(size(test_dimension_reduce)).*mu_all_category(i,:);
    test_SIGMA_inverse(:,:,i) = sigma_inverse_all_category(:,:,i)*test_decenter_img(:,:,i)';
    test_exponent(:,:,i) = test_decenter_img(:,:,i).*test_SIGMA_inverse(:,:,i)';
end
origin_result = sum(test_exponent,2);   
origin_result = reshape(origin_result, size(origin_result, 1)* size(origin_result, 2), size(origin_result, 3));

second_result = zeros(size(origin_result));
for i = 1:1:10
    second_result(:,i) = -0.5*origin_result(:,i) + (-0.5*log(det(sigma_all_category(:,:,i)))+log(PH_every_category(i)))*ones(size(origin_result(:,i)));
end

leibie = zeros(10,1);
leibiezhunque = zeros(10,1);

%"index" is used to record every test image is belonged to which category
[max_result,index] = max(second_result,[],2);
index = index -1;
final_result = length(find(index == test_labels));

%accuracy rate of every category
for i = 1:1:10
    flag = find(test_labels(:,1) == i-1);
    leibie(i) = length(flag);
    testflag = test_labels(flag,:);
    testflagyuce = index(flag,:);
    leibiezhunque(i) = length(find(testflagyuce == testflag));
end

%accuracy rate of all categories
accurity = final_result/length(test_labels);


