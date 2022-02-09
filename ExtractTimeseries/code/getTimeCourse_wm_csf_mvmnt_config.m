% -------------- Please specify the individualstats server: resting data, adults and kids, 5 HTT ----------------
%paralist.stats_path     = '/fs/musk2';
paralist.raw_server     = '/lustre/iCAN/data';
paralist.data_type      = 'nii';

paralist.imagefilter    = 'swcar'; 
paralist.NFRAMES = 232;
paralist.NUMTRUNC = [0,0]; % this parameter is dropped number of volume at beginning and in the end, for task, 4 volume should be dropped refered to liangxiao cc and pnas paper
%NUMTRUNC                = [8,40];%for subject 14-02-17.1_3T2 only

paralist.TR_val = 2;
paralist.bandpass_on = 1;     
paralist.fl = 0.01;%0.008;
% Upper frequency bound for filtering (in Hz)
paralist.fh = 0.2;

%-white matter and CSF roi files
paralist.wm_csf_roi_file = cell(2,1);
%-white matter and csf rois
paralist.wm_csf_roi_file{1} = '/Users/genghaiyang/ghy_works/workspaces/matlab/imaging/spm8_scripts/correlation4task/white_mask_p08_d1_e1_roi.mat';
paralist.wm_csf_roi_file{2} = '/Users/genghaiyang/ghy_works/workspaces/matlab/imaging/spm8_scripts/correlation4task/csf_mask_p08_d1_e1_roi.mat'; 

% Please specify file name holding subjects to be analyzed
% For one subject list files. For eg.,
paralist.subjlist_file  = {'sublist_TA_36.txt'}; 
 
paralist.ROI_dir        = '/Users/genghaiyang/ghy_works/projects/stress_wm_networkanalysis/ROIs_mat';
paralist.output_folder  = '/lustre/iCAN/data/genghaiyang/nback/h18_l18/conn_FC/wm_csf_mvmnt_ts4conn';
% get roiname:
matdir = dir(paralist.ROI_dir);
matdir = matdir(3:end);
matdir = struct2cell(matdir);
matdir = matdir(1,:);
matdir = matdir';
paralist.roi_list  = matdir;
%fullfile(paralist.roi_nii_folder,'.',matdir);
% ----- Please specify the session name: adults, kids, 5 HTT ----------------
paralist.non_year_dir = [''];
paralist.sess_folder  = 'nback';
paralist.preprocessed_folder = 'smoothed_spm8';