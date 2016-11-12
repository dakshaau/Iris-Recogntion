%
% This script generates data for genuine and imposter distributions
%
addpath('Matching');
datas = ['pr1';'pr2'];
load('Watch');
scal = 2;
z = 240*(2*scal);
for k=1:2
disp(datas(k,:));
load(datas(k,:));
hdmat = ones(size(watchimages,1),size(pimages,1),'double');
match = boolean(zeros(size(watchimages,1),size(pimages,1),'double'));
maxelems = size(watchimages,1)*size(pimages,1);
prev = 0;
count = 0;
fprintf('%% Completed: %d',prev);
for i=1:size(watchimages,1)
    for j=1:size(pimages,1)
        if mod(i,2) == 0 && mod(j,2) == 0
            hdmat(i,j) = gethammingdistance(reshape(watchimages(i,:,:),[20,z]),reshape(watchmasks(i,:,:),[20,z]),reshape(pimages(j,:,:),[20,z]),reshape(pmasks(j,:,:),[20,z]),scal);
        elseif mod(i,2) ~= 0 && mod(j,2) ~= 0
            hdmat(i,j) = gethammingdistance(reshape(watchimages(i,:,:),[20,z]),reshape(watchmasks(i,:,:),[20,z]),reshape(pimages(j,:,:),[20,z]),reshape(pmasks(j,:,:),[20,z]),scal);
        end
        if watchlbl(i) == plabels(j)
            match(i,j) = true;
        end
        count = count + 1;
        prec = int32(((count)/maxelems)*100);
        if prec ~= prev
            x = size(int2str(prev));
            fprintf(repmat('\b',1,x));
            fprintf('%d',prec);
            prev = prec;
        end
    end
end
fprintf('\n');
save(datas(k,:),'hdmat','match','-append');
end