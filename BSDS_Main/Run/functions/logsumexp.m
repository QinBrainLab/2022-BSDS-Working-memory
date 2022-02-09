function anew=logsumexp(a,b)
%LOGSUMEXP Compute log(sum(exp(a).*b)) valid for large a
% example: logsumexp([-1000 -1001 -998],[1 2 0.5])
amax=max(a); 
A =size(a,1);
anew = amax + log(sum(exp(a-repmat(amax,A,1)).*b)+1e-310);