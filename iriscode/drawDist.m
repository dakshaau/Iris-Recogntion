%
% drawDist plots the genuine and imposter distribution using the data matrix
% and match matrix
%
% NOTE: This function can sometimes make MATLAB run out of memory
%
function [rng, genuine, imposter, count_g, count_i] = drawDist(data,match)
   [r,c] = find(match == true);
   C = numel(unique(c));
   val = unique(c);
   genuine = zeros(1,C,'double');
   for i=1:C
       ind = find(c == val(i));
       genuine(1,i) = nanmin(data(r(ind),val(i)));
   end
   [r,c] = find(match == false);
   
   imposter = zeros(1,size(r,1),'double');
   for i=1:size(r,1)
       imposter(1,i) = data(r(i),c(i));
   end
   rng = 0:0.01:1;
   sz_rng = size(rng,2);
   count_g = zeros(size(rng),'double');
   count_i = zeros(size(rng),'double');
   for i=1:sz_rng
       ind = find(genuine<=rng(1,i));
       count_g(1,i) = numel(ind)-sum(count_g);
       ind = find(imposter<=rng(1,i));
       count_i(1,i) = numel(ind)-sum(count_i);
   end
   count_g = count_g./sum(count_g);
   count_i = count_i./sum(count_i);
   plot(rng,count_g,'color','green');
   hold on;
   plot(rng,count_i,'color','red');
   hold off;
   xlabel('Fractional Hamming Distance');
   ylabel('Relative Frequency');
   title('Genuine and Imposter Distributions');
   legend('Genuine','Imposter');
end