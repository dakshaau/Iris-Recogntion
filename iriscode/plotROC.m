%
% plotROC plot the ROC curve using the genuine and imposter distribution
% data as an array. The input arguments have to be row vectors.
%
% The return value is the corresponding approximate TPR where FPR is 0.1
%
function thres = plotROC(genuine, imposter)
	rng = 0:0.01:1;
	TPR = zeros(size(rng),'double');
	FPR = zeros(size(rng),'double');
	T_num = numel(genuine);
	F_num = numel(imposter);
    thres = 0;
	for i=1:size(rng,2)
		ind = find(genuine < rng(1,i));
		TPR(1,i) = double(numel(ind))/T_num;
		ind = find(imposter < rng(1,i));
		FPR(1,i) = double(numel(ind))/F_num;
    end
    %ind = find(abs(TPR-FPR) == 0.1, 1,'first');
    %thres = rng(1,ind);
    p = polyfit(FPR,TPR, 4);
    thres = polyval(p,0.1);
    figure;
	plot(FPR,TPR);
	xlabel('False Positive Rate');
	ylabel('True Positive Rate');
	title('ROC Curve');
	axis([0.0 1.0 0.0 1.0]);
end