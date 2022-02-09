% written by hao (ver_17.07.12)
% rock3.hao@gmail.com
% qinlab.BNU
restoredefaultpath
clear

%% ------------------------------ Set Up ------------------------------- %%
% Basic Configure
your_name  = 'hao';
dcm2nii    = 'dcm2niix';
script_dir = '/Users/hao1ei/MyProjects/Scripts/Preprocess/Preproc_spm12/Preproc';
rawimg_dir = '/Users/hao1ei/Downloads/ScriptsTest/Preproc/Preproc_SPM12/Rawdata';
arrimg_dir = '/Users/hao1ei/Downloads/ScriptsTest/Preproc/Preproc_SPM12/data';
raw_list   = fullfile(script_dir,'list_Raw.txt');
img_list   = fullfile(script_dir,'list_Img.txt');

fmri_name    = {'ANT1';'ANT2'};
fmri_keyword = {'ANT1';'ANT2'};
time_del     = {'4'   ;   '4'};
time_remain  = {'173' ; '173'};

mri_name     = {'anatomy'};
mri_keyword  = {'Crop'}; 

% Function Switch
img_conv     = 1; % 0=Skip  1=Run
multi_choose = 0; % 0=Skip  1=Choose last image
timpnt_del   = 1; % 0=Skip  1=Run
sub_rename   = 0; % 0=Skip  1=Run

%% ---------------------------- Read Lists ----------------------------- %%
fid = fopen(raw_list); sublist = {}; cntlist = 1;
while ~feof(fid)
    linedata = textscan(fgetl(fid), '%s', 'Delimiter', '\t');
    sublist(cntlist,:) = linedata{1}; cntlist = cntlist + 1; %#ok<*SAGROW>
end
fclose(fid);

fid = fopen(img_list); sub2list = {}; cntlist   = 1;
while ~feof(fid)
    linedata = textscan(fgetl(fid), '%s', 'Delimiter', '\t');
    sub2list(cntlist,:) = linedata{1}; cntlist = cntlist + 1; %#ok<*SAGROW>
end
fclose(fid);

%% ----------------------------- Img Convert --------------------------- %%
if img_conv == 1
    for i = 1:length(sublist)
        YearID = ['20',sub2list{i,1}(1:2)];
        SubImgDir = fullfile(rawimg_dir,sublist{i,1});
        OutImgDir = fullfile(arrimg_dir,YearID,'Cache',sublist{i,1}(1:9));
        mkdir (OutImgDir);
        if strcmp(dcm2nii,'dcm2niix') == 1
            unix(sprintf([dcm2nii,' -x y -z n -o ',OutImgDir,' ',SubImgDir,'/*']));
        elseif strcmp(dcm2nii,'dcm2nii') == 1
            unix(sprintf([dcm2nii,' -g n -o ',OutImgDir,' ',SubImgDir,'/*']));
        end
        
        % Arrange mri
        for j = 1:length(mri_name)
            mriDir = fullfile(arrimg_dir,YearID,sublist{i,1},'mri',mri_name{j,1});
            mkdir (mriDir);
            TempmriName = dir([OutImgDir,'/*',mri_keyword{j,1},'*']);
            if isempty(TempmriName)
                unix(['echo ',sub2list{i,1},' >> ',script_dir,'/list_',mri_name{j,1},'_no_',your_name,'.txt']);
            elseif length(TempmriName) == 1
                unix(['mv ',[OutImgDir,'/',TempmriName(1,1).name],' ',mriDir,'/I.nii']);
                unix(['echo ',sub2list{i,1},' >> ',script_dir,'/list_',mri_name{j,1},'_yes_',your_name,'.txt']);
            elseif length(TempmriName) >= 2
                unix(['echo ',sub2list{i,1},' >> ',script_dir,'/list_',mri_name{j,1},'_morethan2_',your_name,'.txt']);
                if multi_choose == 1
                    unix(['mv ',[OutImgDir,'/',TempmriName(length(TempmriName),1).name],' ',mriDir,'/I.nii']);
                end
            end
        end
        
        % Arrange fmri
        for j = 1:length(fmri_name)
            fmriDir = fullfile(arrimg_dir,YearID,sublist{i,1},'fmri',fmri_name{j,1},'unnormalized');
            % TaskDesignDir=fullfile(ArrImgDir,YearID,SubName{i,1},'fmri',fmriName{j,1},'Task_Design');
            mkdir (fmriDir);
            % mkdir (TaskDesignDir);
            TempfmriName = dir ([OutImgDir,'/*',fmri_keyword{j,1},'*']);
            mriDir = fullfile (arrimg_dir,YearID,sublist{i,1},'mri',mri_name{1,1});
            if isempty(TempfmriName)
                unix (['echo ',sub2list{i,1},' >> ',script_dir,'/list_',fmri_name{j,1},'_no_',your_name,'.txt']);
            elseif length(TempfmriName) == 1
                unix (['mv ',[OutImgDir,'/',TempfmriName(1,1).name],' ',fmriDir,'/I.nii']);
                mriYN = exist([mriDir,'/I.nii'],'file');
                if mriYN == 2
                    unix(['echo ',sub2list{i,1},' >> ',script_dir,'/list_',fmri_name{j,1},'_yes_',your_name,'.txt']);
                end
            elseif length(TempfmriName) >= 2
                unix (['echo ',sub2list{i,1},' >> ',script_dir,'/list_',fmri_name{j,1},'_moreyhan2_',your_name,'.txt']);
                if multi_choose == 1
                    unix (['mv ',[OutImgDir,'/',TempfmriName(length(TempfmriName),1).name],' ',fmriDir,'/I.nii']);
                end
            end
        end
    end
end

%% ---------------------------- TimePoint Del -------------------------- %%
if timpnt_del == 1
    for i = 1:length(sublist)
        YearID = ['20',sub2list{i,1}(1:2)];
        for j = 1:length(fmri_name)
            fmriDir=fullfile (arrimg_dir,YearID,sublist{i,1},'fmri',fmri_name{j,1},'unnormalized');
            fmriYN = exist ([fmriDir,'/I.nii'],'file');
            if fmriYN == 0
                disp ([sub2list{i,1},' ',fmri_name{j,1},' no exist']);
            elseif fmriYN == 2
                unix (['mv ',[fmriDir,'/I.nii'],' ',fmriDir,'/I_all.nii']);
                unix (['fslroi ',fmriDir,'/I_all.nii ',fmriDir,'/I.nii ',time_del{j,1},' ',time_remain{j,1}]);
                unix (['gunzip ',fmriDir,'/I.nii.gz']);
            end
        end
    end
end

%% --------------------------- Subject Rename -------------------------- %%
if sub_rename == 1
    for i = 1:length(sublist)
        YearID = ['20',sub2list{i,1}(1:2)];
        SubYN = exist (fullfile(arrimg_dir,YearID,sublist{i,1}),'file');
        if SubYN == 0
            disp ([sub2list{i,1},' no exist']);
        elseif SubYN == 7
            unix (['mv ',arrimg_dir,'/',YearID,'/',sublist{i,1},' ',arrimg_dir,'/',YearID,'/',sub2list{i,1}]);
        end
    end
end

%% All Done
clear
disp ('All Done');