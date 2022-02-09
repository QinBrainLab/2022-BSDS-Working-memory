function [phtgV1T,phthtpgV1T1]=VBHMMsmooth(logalpha,logbeta,logOutput,phghm,v)
%HMMSMOOTHVBVAR Switching Autoregressive HMM smoothing
% [phtgV1T,phthtpgV1T]=HMMsmoothVBVAR(logalpha,logbeta,a,sigma2,phghm,v,Tskip)
% return the smoothed pointwise posterior p(h(t)|v(1:T)) and pairwise smoothed posterior p(h(t),h(t+1)|v(1:T)).
%
% Inputs:
% logalpha : log alpha messages (see HMMforwardVBVAR.m)
% logbeta : log beta messages (see HMMbackwardVBVAR.m)
% % phghm : state (switch) transition matrix p(h(t)|h(t-1))
% v : observations
% Tskip : the number of timesteps to skip before a switch update is allowed
%
% Outputs:
% phtgV1T : smoothed posterior p(h(t)|v(1:T))
% phthtpgV1T  : smoothed posterior p(h(t),h(t+1)|v(1:T))
% See also HMMforwardVBVAR.m, HMMbackwardVBVAR.m, demoVBVARlearn.m
T = size(v,2);  %length of time series
H = size(logOutput,1);  % # of states
% smoothed posteriors: pointwise marginals:
for t=1:T
    logphtgV1T(:,t)=logalpha(:,t)+logbeta(:,t); % alpha-beta approach
    phtgV1T(:,t)=condexp(logphtgV1T(:,t));
end
% smoothed posteriors: pairwise marginals p(h(t),h(t+1)|v(1:T)):
for t=2:T
    atmp=condexp(logalpha(:,t-1));
    btmp=condexp(logbeta(:,t));
    phatvgh1 = zeros(H,1);
    for h = 1:H
        phatvgh1(h) = exp(logOutput(h,t))+1e-100; % eps
    end
    phatvgh1=condexp(phatvgh1);
    phghmt=phghm;
    ctmp1 = repmat(atmp,1,H).*phghmt'.*repmat(phatvgh1'.*btmp',H,1) + 1e-100; % two timestep potential
    phthtpgV1T1(:,:,t-1)=ctmp1./sum(sum(ctmp1));
end

if any(isnan(phthtpgV1T1(:)))
        error('phthtpgV1T1= NaN');
end;

if any(isinf(phthtpgV1T1(:)))
        error('phthtpgV1T1= Inf');
end;

if any(isnan(phtgV1T(:)))
        error('phtgV1T= NaN');
end;

if any(isinf(phtgV1T(:)))
        error('phtgV1T= Inf');
end;
