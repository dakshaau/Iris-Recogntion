%
% This file separates the genuine and imposter data and plots the
% distributions.
%
clear;
load('pr1');
right_data = hdmat(1:2:end,1:2:end);
right_match = match(1:2:end,1:2:end);
left_data = hdmat(2:2:end,2:2:end);
left_match = match(2:2:end,2:2:end);
combination = (right_data+left_data)./2;
hdmat = combination;
match = right_match;
[r,c] = find(match == true);

C = numel(unique(c));
val = unique(c);
genuine = zeros(1,C,'double');

for i=1:C
    ind = find(c == val(i));
    genuine(1,i) = nanmin(hdmat(r(ind),val(i)));
end
[r,c] = find(match == false);
x = size(r,1);
imposter = ones(size(r),'double');
for i=1:x
    imposter(i) = hdmat(r(i),c(i));
end

rng = 0:0.01:1;
count_g = zeros(size(rng),'int32');
count_i = zeros(size(rng),'int32');
for i = 1:size(rng,2)
   ind = find(genuine<=rng(1,i));
   count_g(1,i) = numel(ind)-sum(count_g);
   ind = find(imposter<=rng(1,i));
   count_i(1,i) = size(ind,1)-sum(count_i);
end

count_g = double(count_g)./sum(count_g);
count_i = double(count_i)./sum(count_i);

Mean = nanmean(genuine)
Var = nanvar(genuine);
N = int32(0.25/Var);
%rng = 0:N;                      %
%count_g = binopdf(rng,N,Mean);  % These 3 lines enable the usage of binomial distribution
%rng = linspace(0,1,N+1);        %
x = plot(rng,count_g,'color','green');
hold on;

Mean = nanmean(imposter)
Var = nanvar(imposter);
N = int32(0.25/Var);
%rng = 0:N;                      %
%count_i = binopdf(rng,N,Mean);  % These lines enable the usage of binomial distribution
%rng = linspace(0,1,N+1);        %
plot(rng,count_i,'color','red');
hold off;
title('Genuine and Imposter Distributions');
xlabel('Fractional Hamming Distance');
ylabel('Relative Frequency');
legend('Genuine','Imposter');
plotROC(genuine, imposter)
%saveas(x,'GI.png');
