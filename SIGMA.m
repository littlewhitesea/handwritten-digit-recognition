function Covariance = SIGMA(origin_matrix)
mean_matrix =  MEAN(origin_matrix);
decenter = origin_matrix - ones(size(origin_matrix)).*mean_matrix;
% Covariance = decenter'*decenter/size(origin_matrix,1);
%%adjustment%%
Covariance = decenter'*decenter/(size(origin_matrix,1)-1);