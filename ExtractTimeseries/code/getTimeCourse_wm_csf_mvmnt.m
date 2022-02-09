function getTimeCourse_wm_csf_mvmnt(Config_File)
% This is the configuration template file for copy data from a group of participants 
addpath(pwd);
% Show the system information and write log files
warning('off', 'MATLAB:FINITE:obsoleteFunction') 
c     = fix(clock);
disp('==================================================================');
fprintf('copy files start at %d/%02d/%02d %02d:%02d:%02d\n',c);
disp('==================================================================');
%fname = sprintf('copy and rename files -%d_%02d_%02d-%02d_%02d_%02.0f.log',c);
%diary(fname);
disp(['Current directory is: ',pwd]);
disp('------------------------------------------------------------------');
% -------------------------------------------------------------------------
% Check existence of the configuration file
% -------------------------------------------------------------------------

Config_File = strtrim(Config_File);

if ~exist(Config_File,'file')
  fprintf('Cannot find the configuration file ... \n');
  diary off; 
  return;
end

Config_File = Config_File(1:end-2);

% -------------------------------------------------------------------------
% Read individual stats parameters
% -------------------------------------------------------------------------
eval(Config_File);
clear Config_File;
%stats_path       = strtrim(paralist.stats_path);
raw_server       = strtrim(paralist.raw_server);
%parent_folder    = strtrim(paralist.parent_folder);
subjlist_file    = strtrim(paralist.subjlist_file);
output_folder    = strtrim(paralist.output_folder);
sess_folder      = strtrim(paralist.sess_folder);
data_type        = strtrim(paralist.data_type);
imagefilter      = strtrim(paralist.imagefilter);
non_year_dir     = strtrim(paralist.non_year_dir);
preprocessed_folder = strtrim(paralist.preprocessed_folder);
bandpass_on = paralist.bandpass_on;     
fl = paralist.fl;
fh = paralist.fh;
wm_csf_roi_file = paralist.wm_csf_roi_file;
%roi_list         = strcat(ROI_dir, '/', roi_list);
% -------------------------------------------------------------------------
% Load subject list, constrast file and batchfile
% -------------------------------------------------------------------------
subjects        = ReadList(subjlist_file);
%parent_folder   = ReadList(parent_folder);
numsubj         = length(subjects);
imagedir        = cell(numsubj,1);

%movement states
mvmntdir = cell(numsubj,2);

run_FC_dir = pwd;
% Create local folder holding temporary data
temp_dir = fullfile(run_FC_dir, 'temp1');
if exist(temp_dir,'dir')
  unix(sprintf('/bin/rm -rf %s', temp_dir));
end

%-Update path parameters
if isempty(non_year_dir)
  for i = 1:numsubj
    pfolder{i} = ['20', subjects{i}(1:2)];
  end
else
  for i = 1:sublength
    pfolder{i} = non_year_dir;
  end
end

for cnt = 1:numsubj
    %sessionlink_dir{cnt} = fullfile(raw_server, pfolder{cnt}, ....
    %                                subjects{cnt}, 'fmri', sess_folder);
    imagedir{cnt} = fullfile(raw_server, pfolder{cnt}, subjects{cnt}, ...
                              'fmri', sess_folder, preprocessed_folder);  
    mvmntdir{cnt,1} = fullfile(raw_server, pfolder{cnt}, subjects{cnt}, ...
                               'fmri', sess_folder, 'unnormalized');
    mvmntdir{cnt,2} = fullfile(raw_server, pfolder{cnt}, subjects{cnt}, ...
                               'fmri', sess_folder, preprocessed_folder); %                           
end

% load sublist and onset.
load('onset_sublist.mat')

for FCi = 1:numsubj
    secondpart = subjects{FCi}(1:2);
    if str2double(secondpart) > 96
        pfolder = ['19' secondpart];
    else
        pfolder = ['20' secondpart];
    end
    %fprintf('Subject %s:\n',subjects{subcnt});
    %outputfile = strcat(output_folder, '/ROI_ts_', subjects{FCi}, '_', sess_folder, '.mat');
	
    disp('----------------------------------------------------------------');
    fprintf('Processing subject: %s \n', subjects{FCi});
    if exist(temp_dir, 'dir')
        unix(sprintf('/bin/rm -rf %s', temp_dir));
    end
    mkdir(temp_dir);
    cd(imagedir{FCi});
    
    fprintf('Copy files from: %s \n', pwd);
    fprintf('to: %s \n', temp_dir);
    if strcmp(data_type, 'nii')
        unix(sprintf('/bin/cp -af %s %s', [imagefilter, '*.nii*'], temp_dir));
        if exist('unused', 'dir')
        unix(sprintf('/bin/cp -af %s %s', fullfile('unused', [imagefilter, '*.nii*']), temp_dir));
        end
    else
        unix(sprintf('/bin/cp -af %s %s', [imagefilter, '*.img*'], temp_dir));
        unix(sprintf('/bin/cp -af %s %s', [imagefilter, '*.hdr*'], temp_dir));
        if exist('unused', 'dir')
          unix(sprintf('/bin/cp -af %s %s', fullfile('unused', [imagefilter, '*.img*']), temp_dir));
          unix(sprintf('/bin/cp -af %s %s', fullfile('unused', [imagefilter, '*.hdr*']), temp_dir));
        end
    end
    cd(temp_dir);
    unix('gunzip -fq *');
    newimagefilter = imagefilter;
  
    %-Bandpass filter data if it is set to 'ON'
    if bandpass_on == 1
        disp('Bandpass filtering data ......................................');
        bandpass_final_SPM(2, fl, fh, temp_dir, imagefilter, data_type);
        disp('Done');
        %-Prefix update for filtered data
        newimagefilter = ['filtered', imagefilter];
    end
    %-Step 1 ----------------------------------------------------------------
    %-Extract white matter and CSF signals
    disp('Extract white matter and CSF signals ...........................');
    [wm_csf_ts, ~] = extract_ROI_timeseries_eigen1(wm_csf_roi_file, temp_dir, 1, ...
                                      0, newimagefilter, data_type); 
    wm_csf_ts = wm_csf_ts';    
    
    %-Step 2
    % Get mvmnt
    disp('Get head motion parameters ...........................');
    unix(sprintf('gunzip -fq %s', fullfile(mvmntdir{FCi,1}, 'rp_I*')));
    unix(sprintf('gunzip -fq %s', fullfile(mvmntdir{FCi,2}, 'rp_I*')));
    rp2 = dir(fullfile(mvmntdir{FCi,2}, 'rp_I*.txt'));
    rp1 = dir(fullfile(mvmntdir{FCi,1}, 'rp_I*.txt'));
    if ~isempty(rp2)
      mvmnt = load(fullfile(mvmntdir{FCi,2}, rp2(1).name));
    elseif ~isempty(rp1)
      mvmnt = load(fullfile(mvmntdir{FCi,1}, rp1(1).name));
    else
      fprintf('Cannot find the movement file: %s \n', subjects{FCi});
      cd(current_dir);
      diary off; return;
    end
    Group_ts_wm_csf_mvmnt = cat(2,wm_csf_ts,mvmnt);
    cd(output_folder)
    save all.mat
    filename = [int2str(FCi),'_',subjects{FCi},'_wm_csf_rp_l.txt'];
    eval(['save ' filename ' Group_ts_wm_csf_mvmnt -ascii'])
%     fp = fopen([int2str(FCi),'_',subjects{FCi},'_wm_csf_rp_l.txt'],'wt');
%     fprintf(fp,'%d',Group_ts_wm_csf_mvmnt);
%     fclose(fp);
    
end 
%save Group_ts_wm_csf_mvmnt.mat Group_ts_wm_csf_mvmnt
disp('Job finished');
end
