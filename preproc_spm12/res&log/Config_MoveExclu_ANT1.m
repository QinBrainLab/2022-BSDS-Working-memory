paralist.ServerPath = '/Users/hao1ei/Downloads/ScriptsTest/Preproc/Preproc_SPM12/data';
paralist.PreprocessedFolder = 'smoothed_spm12';
fid = fopen('/Users/hao1ei/MyProjects/Scripts/Preprocess/Preproc_spm12/SubList_ANT1_YesExist_Hao2.txt');
ID_List = {};
Cnt_List = 1;
while ~feof(fid)
linedata = textscan(fgetl(fid), '%s', 'Delimiter', '\t');
ID_List(Cnt_List,:) = linedata{1};
Cnt_List = Cnt_List + 1;
end
fclose(fid);
paralist.SubjectList = ID_List;
paralist.SessionList = {'ANT1'};
paralist.ScanToScanCrit = 0.5;
