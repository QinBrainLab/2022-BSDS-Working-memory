function [states, stateCell] =  estimateStatesByVitterbi(data,model,logOutProbs)

% Vitterbi Algo


%%     transition distribution p(h(t)|h(t-1)
Wa = model.Wa;
Wa = Wa';
K = size(Wa,1);
Aest = Wa./repmat(sum(Wa,2),1,K); %transition distribution p(h(t)|h(t-1))
Aest = Aest';
%%%%    estimeted pi
Wpi = model.Wpi;
piest = Wpi./sum(Wpi);
%% Most likely state by Vitterbi Algo
%%%%       emission distribution p(v(t)|h(t)) - Multivariate distribution
nSubjs = length(data);
states = [];
for ns = 1:nSubjs
    [M,T] = size(data{ns});
    pvgh = zeros(K,T);
    for h = 1:K
        for t = 1:1
            pvgh(h,t) =  exp(logOutProbs{ns}(h,t));
        end
        for t = 2:T
            pvgh(h,t) =  exp(logOutProbs{ns}(h,t));
        end
    end
    states = [states viterbi_path(piest, Aest',pvgh)];
    stateCell{ns} = viterbi_path(piest, Aest',pvgh);
end
    %size(states)

