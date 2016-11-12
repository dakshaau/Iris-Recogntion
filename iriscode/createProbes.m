%
% This file creates the pr1 and pr2 data from probe1 and probe2
% The data is the templates and mask for each processed iris
%
addpath('Segmentation');
addpath('Normal_encoding');
scal = 2;
z = 240*2*scal;
mats = ['probe1';'probe2'];
names = ['pr1';'pr2'];
for i=1:2
    load(mats(i,:));
    pimages = zeros(size(unique(labels),1)*2,20,z,'double');
    pmasks = zeros(size(unique(labels),1)*2,20,z,'double');
    plabels = zeros(size(unique(labels),1)*2,1,'double');
    count = 0;
    k = 1;
    for j=1:size(images,1)
        if j~=1 && labels(j) ~= labels(j-1)
            count = 0;
        end
        if (processed(1,j)==true)
            if count<2
                [template, mask] = createiristemplate(char(images(j))); 
                pimages(k,:,:) = template(:,:);
                pmasks(k,:,:) = mask(:,:);
                plabels(k) = labels(j);
                k=k+1;
            end
            count=count+1;
        end
    end
    save(names(i,:),'pimages','pmasks','plabels');
end