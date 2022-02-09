function [cov_group, mean_group, cov_subj, mean_subj] = computeDataCovarianceFromDataUsingOnlyStates(data,est_stateCell, nStates)

nSubj = length(data);
est_states = cell2mat(est_stateCell);
states_id = unique(est_states);
data_group = cell2mat(data);
for i=1:nStates
      if sum(states_id==i)~=0
            cov_group{i} = cov(data_group(:, est_states==i)');
            mean_group{i} = mean(data_group(:, est_states==i)');
      else
            cov_group{i} = zeros(size(data_group, 1), size(data_group, 1));
            mean_group{i} = zeros(1, size(data_group, 1));
      end
end

for subj=1:nSubj
      states_id = unique(est_stateCell{subj});
      for i=1:nStates
            if sum(states_id==i)~=0
                  cov_subj{subj}{i} = cov(data{subj}(:, est_stateCell{subj}==i)');
                  mean_subj{subj}{i} = mean(data{subj}(:, est_stateCell{subj}==i)');
            else
                  cov_subj{subj}{i} =zeros(size(data_group, 1), size(data_group, 1));
                  mean_subj{subj}{i} =zeros(1, size(data_group, 1));
            end
      end
end