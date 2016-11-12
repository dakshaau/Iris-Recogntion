%
% This script processes all the images in all the 3 datasets and stores
% which images have been processed.
%
paths = ['../LG2200_2008/images.txt';'../LG4000_2010/images.txt';'../LG2200_2010/images.txt'];
addpath('Matching');
addpath('Normal_encoding');
addpath('Segmentation');
created = cell(3);
for j=1:3
    disp(['path: ' paths(j,:)])
    images = importdata(paths(j,:));
    clear y;
    y(1) = 0;
    i = 1;
    max_imgs = size(images,1);
    prev = 0;
    fprintf('%% Completed: %d',prev);
    while i <= size(images,1)
        try
            [template,mask] = createiristemplate(char(images(i)));
            prec = int32((i/max_imgs)*100);
            if prec ~= prev
                x = size(int2str(prev));
                fprintf(repmat('\b',1,x));
                fprintf('%d',prec);
                prev = prec;
            end
            y(i) = true;
            i = i+1;
        catch
            if mod(i,2) == 0
                y(i-1:i) = false;
                i = i+1;
            else
                y(i:i+1) = false;
                i = i+2;
            end
            
        end
    end
    fprintf('\n');
    if j == 1
        created = {y};
    else
        created{j} = y;
    end
end
save('Created','created');
%imshow(img)