% -------------- Please specify the individualstats server: resting data, adults and kids, 5 HTT ----------------
%paralist.stats_path     = '/fs/musk2';
paralist.raw_server     = '/brain/iCAN_admin/home/ChenMenglu/CBD/CBD_data/prepro';
paralist.data_type      = 'nii';

paralist.imagefilter    = 'swcar'; 
paralist.NFRAMES = 228;
paralist.NUMTRUNC = [0,0];%%si [8,85] sr [93,0]

paralist.TR_val = 2;
paralist.bandpass_on = 0;     
paralist.fl = 0.06
% Upper frequency bound for filtering (in Hz)
paralist.fh = 0.12;

%-white matter and CSF roi files
paralist.wm_csf_roi_file = cell(2,1);
%-white matter and csf rois
paralist.wm_csf_roi_file{1} = '/brain/iCAN/SPM/spm8_scripts/rsFC_network/white_mask_p08_d1_e1_roi.mat';
paralist.wm_csf_roi_file{2} = '/brain/iCAN/SPM/spm8_scripts/rsFC_network/csf_mask_p08_d1_e1_roi.mat'; 

% Please specify file name holding subjects to be analyzed
% For one subject list files. For eg.,
paralist.subjlist_file  = {'69Children_51Adults.txt'}; 
 
paralist.ROI_dir        = '/brain/iCAN_admin/home/Heying/GitHub-BSDS project/ExtractTimeseries/ROI';%roi
paralist.output_folder  = '/brain/iCAN_admin/home/Heying/CBD/WM/Data/120Subjects_mean_new/';%results
% get roiname:
niidir = dir(paralist.ROI_dir);
niidir = niidir(3:end);
niidir = struct2cell(niidir);
niidir = niidir(1,:);
niidir = niidir';
paralist.roi_list  = niidir;
%fullfile(paralist.roi_nii_folder,'.',niidir);
% ----- Please specify the session name: adults, kids, 5 HTT ----------------
paralist.non_year_dir = [''];
paralist.sess_folder  = 'WM';
paralist.preprocessed_folder = 'smoothed_spm12';