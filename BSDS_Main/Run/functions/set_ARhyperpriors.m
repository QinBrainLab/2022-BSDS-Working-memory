function VB = set_ARhyperpriors(data)

M = size(data{1},1);
%Gamma
VB.ao = 10^-3; VB.bo = 10^-3;
VB.no = M + 2;
% VB.Wo = pinv((0.75*cov(cell2mat(data)')));
VB.Wo = 10^3*eye(M);
