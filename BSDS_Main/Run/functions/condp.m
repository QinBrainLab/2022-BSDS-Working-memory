function pnew=condp(pin)
%CONDP Make a conditional distribution from the matrix 
% pnew=condp(pin)
%
% Input : pin  -- a positive matrix pin
% Output:  matrix pnew such that sum(pnew,1)=ones(1,size(p,2))
p = pin./max(pin(:));
p = p+eps; % in case all unnormalised probabilities are zero
pnew=p./repmat(sum(p,1),size(p,1),1);