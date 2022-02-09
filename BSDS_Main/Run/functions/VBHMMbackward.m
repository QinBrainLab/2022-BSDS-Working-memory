function logbeta1 = VBHMMbackward(v,phghm,logOutput)
% logbeta=VBHMMbackward(v,phghm,a,sigma2,Tskip)
%
% Inputs:
% v : observations
% phghm : state (switch) transition matrix p(h(t)|h(t-1))
% Tskip : the number of timesteps to skip before a switch update is allowed
%
% Outputs:
% logbeta: log backward messages log p(v(t+1:T)|h(t),v(t-L+1:t))
T = size(v,2);  %length of time series
H = size(logOutput,1);  % # of states
% logbeta recursion
logbeta1 = zeros(H,T);
logbeta1(:,T) = zeros(H,1);
for t=T:-1:2
    phatvgh1 = zeros(H,1);
   for h = 1:H
        phatvgh1(h) = exp(logOutput(h,t))+1e-100; % eps
   end
    logbeta1(:,t-1)=logsumexp(repmat(logbeta1(:,t),1,H),repmat(phatvgh1,1,H).*phghm);
end
if any(isnan(logbeta1(:)))
        error('logbeta1= NaN');
end;

if any(isinf(logbeta1(:)))
        error('logbeta1= Inf');
end;
