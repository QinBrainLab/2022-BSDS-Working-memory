function Step1_Script(funcdir,funcfilter,t1dir,t1filter,sliceorder,tr,DataType)
%% inputs:
% 1) magimage: the magnitude image for shorter TE, absolute path;
% 2) phaseimage: the phase image, absolute path;
% 3) funcimage: the functional images the researchers want to preprocess,absolute path
% 4) filemapmfile: a .m file contains all the parameters for the fieldmap data. This file would be different across studies, pertinent to the scanner and sequence you use for data collection. Always it could be got from your technician, absolute path
% 5) t1: the high-resolution anatomic image for each subjects, it is optional, you can leave a ~ if you don't want to align anatomic image to DVM for quality check. If you want to do this, t1 image should be in its absolute path

%% developed by Changming Chen, at Beijing Normal University
% 2016-9-24
[funcimages, ~] = SelectFiles_Qin(funcdir, funcfilter, DataType);
[t1, ~] = SelectFiles_Qin(t1dir, t1filter, DataType);
spmver=spm('version');
[a,~,~]=fileparts(mfilename('fullpath'));
if strfind(spmver,'SPM12')
    %% preprocess from slice timing, realign&unwarp, coregister
    clear matlabbatch;
    load(fullfile(a,'Step1_Batch.mat'));
    matlabbatch{1}.spm.temporal.st.scans = {strcat(funcimages,',1')};
    nslices = max(sliceorder);
    matlabbatch{1}.spm.temporal.st.nslices = nslices;
    matlabbatch{1}.spm.temporal.st.tr = tr;
    matlabbatch{1}.spm.temporal.st.ta = tr-tr/nslices;
    matlabbatch{1}.spm.temporal.st.so = sliceorder;
    matlabbatch{1}.spm.temporal.st.refslice = sliceorder(ceil(nslices/2));
    % matlabbatch{2}.spm.
    matlabbatch{3}.spm.spatial.preproc.tissue(1).tpm = {[spm('dir'),filesep,'tpm',filesep,'TPM.nii,1']};
    matlabbatch{3}.spm.spatial.preproc.tissue(2).tpm = {[spm('dir'),filesep,'tpm',filesep,'TPM.nii,2']};
    matlabbatch{3}.spm.spatial.preproc.tissue(3).tpm = {[spm('dir'),filesep,'tpm',filesep,'TPM.nii,3']};
    matlabbatch{3}.spm.spatial.preproc.tissue(4).tpm = {[spm('dir'),filesep,'tpm',filesep,'TPM.nii,4']};
    matlabbatch{3}.spm.spatial.preproc.tissue(5).tpm = {[spm('dir'),filesep,'tpm',filesep,'TPM.nii,5']};
    matlabbatch{3}.spm.spatial.preproc.tissue(6).tpm = {[spm('dir'),filesep,'tpm',filesep,'TPM.nii,6']};
    matlabbatch{4}.spm.spatial.coreg.estimate.source = {strcat(t1{1},',1')};
    save(fullfile(funcdir,'Step1_BatchAssign'),'matlabbatch')
    spm_jobman('run',matlabbatch);
    
    %% calculate global
    [rfiles,~] = SelectFiles_Qin(funcdir, 'carI', DataType);
    VY = spm_vol(rfiles);
    NumScan = length(VY);
    disp('calculating the global signals ...');
    fid = fopen(fullfile(funcdir, 'VolumRepair_GlobalSignal.txt'), 'w+');
    for iScan = 1:NumScan
        fprintf(fid, '%.4f\n', spm_global(VY{iScan}));
    end
    fclose(fid);
end
