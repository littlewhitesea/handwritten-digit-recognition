function [dimension_reduce,PCA_percent,transform_matrix] = PCA_reduction(Inmatrix,dimension_number)

mean_Inmatrix =  MEAN(Inmatrix);

decenter = Inmatrix - ones(size(Inmatrix)).*mean_Inmatrix;
% sigma = decenter'*decenter/size(Inmatrix,1);
%%%%%%%%%%%adjustment%%%%%%%%%%%%
sigma = decenter'*decenter/(size(Inmatrix,1)-1);

e_val = eig(sigma);

[transform_matrix,e_val_pick] = eigs(sigma,dimension_number);

dimension_reduce = Inmatrix*transform_matrix;

PCA_percent = sum(diag(e_val_pick))/sum(e_val);