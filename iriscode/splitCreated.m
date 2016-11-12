%
% This script splits 'created' cell matrix the templates into Watchlist,
% probe1 and probe2
%
load('Created','created');
imgpaths = ['../LG2200_2008/images.txt';'../LG4000_2010/images.txt';'../LG2200_2010/images.txt'];
lblpaths = ['../LG2200_2008/labels.txt';'../LG4000_2010/labels.txt';'../LG2200_2010/labels.txt'];
for i=1:3
    images = importdata(imgpaths(i,:));
    labels = importdata(lblpaths(i,:));
    processed = logical(created{1,i});
    if i == 1
        save('Watchlist','images','labels','processed');
    elseif i == 2
        save('probe1','images','labels','processed');
    else
        save('probe2','images','labels','processed');
    end
end

