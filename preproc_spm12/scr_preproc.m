% written by hao (ver_17.07.12)
% rock3.hao@gmail.com
% qinlab.BNU
restoredefaultpath
clear

%% ------------------------------ Set Up ------------------------------- %%
% Set Path
spm_dir     = '/Users/hao1ei/Toolbox/spm12';
script_dir  = '/Users/hao1ei/MyProjects/Scripts/Preprocess/Preproc_spm12';
preproc_dir = '/Users/hao1ei/Downloads/ScriptsTest/Preproc/Preproc_SPM12/data';
subjlist    = fullfile(script_dir,'SubList_ANT1_YesExist_Hao2.txt');

% Set Basic Information
fmri_name   = {'ANT1'}; % if multi run, use: {'Run1';'Run2'}
tr          = 2;
t1_filter   = 'I';
func_filter = 'I';
datat_type  = 'nii';
slice_order = [1:2:33 2:2:32];

% Function Switch
preproc   = 1;
moveexclu = 0;

%% The following do not need to be modified
%% Import SubList
fid = fopen(subjlist); sublist = {}; cntlist = 1;
while ~feof(fid)
    linedata = textscan(fgetl(fid), '%s', 'Delimiter', '\t');
    sublist(cntlist,:) = linedata{1}; cntlist = cntlist + 1; %#ok<*SAGROW>
end
fclose(fid);
%% Addpath
addpath (genpath (spm_dir));
addpath (genpath (script_dir));

%% -------------------------- Preprocess fmri -------------------------- %%
% SliceTiming = 'a > ar'; Realign = 'r > c'; Normalise = 'w'; Smooth = 's'.
if preproc ==1
    for i = 1:length(sublist)
        for run = 1:length(fmri_name)
            YearID = ['20',sublist{i,1}(1:2)];
            SubjDir = sublist{i};
            disp ([SubjDir,' Preprocess Started'])
            
            T1Dir     = fullfile(preproc_dir,YearID,SubjDir,'/mri/anatomy/');
            FuncDir   = fullfile(preproc_dir,YearID,SubjDir,'/fmri/',fmri_name{run,1},'/unnormalized/');
            FinalDir = fullfile(preproc_dir,YearID,SubjDir,'/fmri/',fmri_name{run,1},'/smoothed_spm12/');
            
            cd (FuncDir)
            Step1_Script (FuncDir,func_filter,T1Dir,t1_filter,slice_order,tr,datat_type);
            Step2_Script (FuncDir,func_filter,T1Dir,t1_filter,slice_order,tr,datat_type);
            
            unix (sprintf ('gzip meanarI.nii'));
            unix (sprintf ('gzip wcarI.nii'));
            unix (sprintf ('gzip swcarI.nii'));
            unix (sprintf ('gzip I.nii'));
            unix (sprintf ('gzip I_all.nii'));
            
            unix (sprintf ('rm arI.mat'));
            unix (sprintf ('rm arI.nii'));
            unix (sprintf ('rm c*meanarI.nii'));
            unix (sprintf ('rm carI.nii'));
            unix (sprintf ('rm meanarI_seg8.mat'));
            
            rpFile      = fullfile(FuncDir,'rp_arI.txt');
            MeanFile    = fullfile(FuncDir,'meanarI.nii.gz');
            VlmRep_GS   = fullfile(FuncDir,'VolumRepair_GlobalSignal.txt');
            SmoothFile  = fullfile(FuncDir,'swcarI.nii.gz');
            NoSmoothFile  = fullfile(FuncDir,'wcarI.nii.gz');
            
            mkdir (FinalDir)
            movefile(rpFile,FinalDir)
            movefile(MeanFile,FinalDir)
            movefile(VlmRep_GS,FinalDir)
            movefile(SmoothFile,FinalDir)
            movefile(NoSmoothFile,FinalDir)
            
            cd (T1Dir)
            unix (sprintf ('rm I_seg8.mat'));
            unix (sprintf ('rm y_I.nii'));
            unix (sprintf ('gzip I.nii'));
        end
    end
end
cd (script_dir)

%% ------------------------- Movement Exclusion ------------------------ %%
if moveexclu ==1
    for k = 1:length(fmri_name)
        mConfigName = ['Config_MoveExclu_',fmri_name{k,1},'.m'];
        mConfig = fopen (mConfigName,'a');
        fprintf (mConfig,'%s\n',['paralist.ServerPath = ''',preproc_dir,''';']);
        fprintf (mConfig,'%s\n','paralist.PreprocessedFolder = ''smoothed_spm12'';');
        
        fprintf (mConfig,'%s\n',['fid = fopen(''',subjlist,''');']);
        fprintf (mConfig,'%s\n','ID_List = {};');
        fprintf (mConfig,'%s\n','Cnt_List = 1;');
        fprintf (mConfig,'%s\n','while ~feof(fid)');
        fprintf (mConfig,'%s\n','linedata = textscan(fgetl(fid), ''%s'', ''Delimiter'', ''\t'');');
        fprintf (mConfig,'%s\n','ID_List(Cnt_List,:) = linedata{1};');
        fprintf (mConfig,'%s\n','Cnt_List = Cnt_List + 1;');
        fprintf (mConfig,'%s\n','end');
        fprintf (mConfig,'%s\n','fclose(fid);');
        
        fprintf (mConfig,'%s\n','paralist.SubjectList = ID_List;');
        fprintf (mConfig,'%s\n',['paralist.SessionList = {''',fmri_name{k,1},'''};']);
        fprintf (mConfig,'%s\n','paralist.ScanToScanCrit = 0.5;');
        
        MoveExclu_spm12_Hao(mConfigName)
    end
    
    if ~exist('res&log','dir')
        mkdir (fullfile(script_dir,'res&log'))
    end
    movefile ('Log_Movement*.txt','res&log')
    movefile ('Config_MoveExclu*.m','res&log')
end

%% All Done
clear
disp ('All Done');