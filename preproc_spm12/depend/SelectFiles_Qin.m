function [InputImgFile, SelectErr] = SelectFiles_Qin(FileDir, PrevPrefix, DataType)
% adapted from 'preprocessfmri_selectfiles' in Shaozheng Qin's Lab

ListFile = dir(fullfile(FileDir, [PrevPrefix, '.nii']));
if ~isempty(ListFile)
    try
        unix(sprintf('gunzip -fq %s', fullfile(FileDir, [PrevPrefix, '*.gz'])));
    catch
    end
end
SelectErr = 0;
switch DataType
    case 'img'
        InputImgFile = spm_select('ExtFPList', FileDir, ['^', PrevPrefix, '.*.img']);
    case 'nii'
        InputImgFile = spm_select('ExtFPList', FileDir, ['^', PrevPrefix, '.nii']);
        V = spm_vol(InputImgFile);
        if size(V(1).private.dat.dim,2)==4
            nframes = V(1).private.dat.dim(4);
            InputImgFile = spm_select('ExtFPList', FileDir, ['^', PrevPrefix, '.nii'], (1:nframes));
            clear V nframes;
        end
end
InputImgFile = deblank(cellstr(InputImgFile));
if isempty(InputImgFile{1})
    SelectErr = 1; %#ok<*NASGU>
    error(['No data   ',fullfile(FileDir,[PrevPrefix,'*']),'  was found!!']);
    return; %#ok<*UNRCH>
end
end