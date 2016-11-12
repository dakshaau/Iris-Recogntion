%
% This script can be used to test the system on a smaller dataset by using
% small number of images from the Gallery and small number of images from
% the probes.
%
% Currently uses 120 images from the Gallery and 12 images from the probe.
%

addpath('Segmentation');
addpath('Normal_encoding');
addpath('Matching');
paths = ['../LG2200_2008/images.txt';'../LG4000_2010/images.txt'];
lblpaths = ['../LG2200_2008/labels.txt';'../LG4000_2010/labels.txt'];
scal = 2;
num = 240*2*scal;
created = cell(3);
for i=1:2
    x = 0;
    if i==1
        x = 120;
        watchimgs = zeros([18,20,num],'double');
        watchmsks = zeros([18,20,num],'double');
        watchlbls = zeros([18,1],'int32');
    else
        x = 12;
        primgs = zeros([8,20,num],'double');
        prmsks = zeros([8,20,num],'double');
        prlbls = zeros([8,1],'int32');
    end
    disp(['path: ' paths(i,:)])
    images = importdata(paths(i,:));
    labels = importdata(lblpaths(i,:));
    clear y;
    y(1) = false;
    j = 1;
    max_imgs = x;
    prev = 0;
    fprintf('%% Completed: %d',prev);
    
    while j <= x
        try
            [template,mask] = createiristemplate(char(images(j)));
            if i == 1
                watchimgs(j,:,:) = template(:,:);
                watchmsks(j,:,:) = mask(:,:);
                watchlbls(j) = labels(j);
            else
                primgs(j,:,:) = template(:,:);
                prmsks(j,:,:) = mask(:,:);
                prlbls(j) = labels(j);
            end
            prec = int32((j/max_imgs)*100);
            if prec ~= prev
                z = size(int2str(prev));
                fprintf(repmat('\b',1,z));
                fprintf('%d',prec);
                prev = prec;
            end
            y(j) = true;
            j = j+1;
        catch ME
            disp(ME);
            if mod(j,2) == 0
                y(j-1:j) = false;
                j = j+1;
                
            else
                y(j:j+1) = false;
                j = j+2;
            end
            
        end
    end
    fprintf('\n');
    y;
    if i == 1
        created = {y};
    else
        created{i} = y;
    end
end

px = logical(created{1,1});
ind = find(px == true);
watchimgs = watchimgs(ind,:,:);
watchmsks = watchmsks(ind,:,:);
watchlbls = watchlbls(ind);
px = logical(created{1,2});
ind = find(px==true);
primgs = primgs(ind,:,:);
prmsks = prmsks(ind,:,:);
prlbls = prlbls(ind);
hdmat = ones(size(watchimgs,1),size(primgs,1),'double');
match = boolean(zeros(size(watchimgs,1),size(primgs,1),'int32'));
for i = 1:size(watchimgs,1)
    for j = 1:size(primgs,1)
        hdmat(i,j) = gethammingdistance(reshape(watchimgs(i,:,:),[20,num]),reshape(watchmsks(i,:,:),[20,num]),reshape(primgs(j,:,:),[20,num]),reshape(prmsks(j,:,:),[20,num]),scal);
        if watchlbls(i) == prlbls(j)
            match(i,j) = true;
        end
    end
end

right_data = hdmat(1:2:end,1:2:end);
right_match = match(1:2:end,1:2:end);
left_data = hdmat(2:2:end,2:2:end);
left_match = match(2:2:end,2:2:end);
combination = (right_data+left_data)./2;
[rng, genuine, imposter, count_g, count_i] = drawDist(combination,right_match);

Mean = nanmean(genuine)
Var = nanvar(genuine);
N = int32(0.25/Var);
r = 0:N;
Pdf = binopdf(r,N,Mean);
rng = linspace(0,1,N+1);
%rng = 0:0.01:1;
plot(rng,Pdf,'color','green');
hold on;
Mean = nanmean(imposter)
Var = nanvar(imposter);
N = int32(0.25/Var);
r = 0:N;
Pdf = binopdf(r,N,Mean);
rng = linspace(0,1,N+1);

plot(rng,Pdf,'color','red');
hold off;
xlabel('FHD');
ylabel('Relative Frequency');
title('G/I Distributions Binomial');
legend('Genuine','Imposter');
plotROC(genuine, imposter);