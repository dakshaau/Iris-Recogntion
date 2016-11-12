%
% This script creates the Watchlist or Gallery for the recognition system.
%
addpath('Segmentation');
addpath('Normal_encoding');
load('Watchlist');
ind = find(processed == true);
watchimg = images(ind);
watchlbl = labels(ind);
scal = 2;
z = 240*2*scal;
watchimages = ones(size(watchimg,1),20,z,'double');
watchmasks = ones(size(watchimg,1),20,z,'double');
%indexes = find(watchpro==true);
for i=1:size(watchimg,1)
    [i1,m1]=createiristemplate(char(watchimg(i)));
    watchimages(i,:,:) = i1(:,:);
    watchmasks(i,:,:) = m1(:,:);
        %[i2,m2]=createiristemplate(char(watchimg(i+1)));
        %h1 = gethammingdistance(pt1,pm1,i1,m1,1);
        %h2 = gethammingdistance(pt2,pm2,i2,m2,1);
        %h = mean([h1 h2]);
        %hd(i:i+1) = h;
end
save('Watch','watchimages','watchmasks','watchlbl')