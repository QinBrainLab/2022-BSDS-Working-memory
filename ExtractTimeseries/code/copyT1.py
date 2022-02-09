import os
import shutil
import re
# initialize variable
parentfolder1='e:\\data\\uncertainty_anxiety_ghy\\2014\\nifti\\nifti_all'
parentfolder2='c:\Users\coolspider2015_bnu\Desktop\\sub41\\FunImg'

#1_006_t1_mprage_sag_144_20140513,copy T1
tempdir1=os.listdir(parentfolder1)
for t1 in tempdir1:
	tempdir2=os.listdir(parentfolder1+'/'+ t1)
	for t2 in tempdir2:
		#pattern = re.compile('1_00._t1_mprage.*?',re.S)
		pattern = re.compile('1_00._K19-----jiangtainzai_zhou_225'+'.*?',re.S)
		#pattern = re.compile('1_00._ge_func_3p75x3p75x4_225'+'.*?',re.S)
		if re.findall(pattern,t2): 
			print t2
			src = parentfolder1+'\\'+t1+'\\'+t2
			os.makedirs(parentfolder2+'\\'+t1)
			dst  =parentfolder2+'\\'+t1
			os.chdir(src)
			src_file= [os.path.join(src, file) for file in os.listdir(src)]
			shutil.copy(src_file[0], dst)
			#os.removedirs(dst)