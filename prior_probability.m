function PH = prior_probability(labels)
PH = zeros(10,1);
for i = 1:1:10
    num = find(labels == i-1);
    PH(i) = length(num)/length(labels);
end