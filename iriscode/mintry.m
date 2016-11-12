load('pr2');
%temp = transpose(hdmat);
%match = transpose(match);
right_data = hdmat(1:2:end,1:2:end);
right_match = match(1:2:end,1:2:end);
left_data = hdmat(2:2:end,2:2:end);
left_match = match(1:2:end,1:2:end);
[Cr, Ir] = min(right_data,[],1);
[Cl, Il] = min(left_data,[],1);
%drawDist(left_data,left_match);
data = left_data;
match = left_match;
[r,c] = find(match == true);
   %r
   %c
   %fprintf('Number of matches: %d\n',size(r,2));
   genuine = zeros(size(r),'double');
   for i=1:size(r,1)
        genuine(1,i) = data(r(i),c(i));
   end
   [r,c] = find(match == false);
   
   imposter = zeros(size(r),'double');
   for i=1:size(r,1)
       imposter(1,i) = data(r(i),c(i));
   end
   %genuine
   %imposter
   rng = 0:0.01:1;
   sz_rng = size(rng,2);
   count_g = zeros(size(rng),'double');
   count_i = zeros(size(rng),'double');
   for i=1:sz_rng
       ind = find(genuine<=rng(1,i));
       count_g(1,i) = size(ind,1)-sum(count_g);
       ind = find(imposter<=rng(1,i));
       count_i(1,i) = size(ind,1)-sum(count_i);
   end
   count_g = count_g./sum(count_g);
   count_i = count_i./sum(count_i);
   plt = plot(rng,count_g,'color','green');
   hold on;
   plot(rng,count_i,'color','red');
   hold off;
   xlabel('Fractional Hamming Distance');
   ylabel('Relative Frequency');
   title('Genuine and Imposter Distributions');
   legend('Genuine','Imposter');