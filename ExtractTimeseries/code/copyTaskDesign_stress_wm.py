import os
import shutil
import re
src = 'J:\\BNU\\wm_stress\\ppi_networks\\niifile\\2011'
dst = 'E:\\!data\\wm_stress\\conn_network\\TaskDesign'
sublistpath = 'c:\\Users\\coolspider2015_bnu\\Desktop\\sublist_TA_36.txt'
sublist= open(sublistpath,"a+")
n2=[]
for j in sublist.readlines():
    n2.append(j.split()[0])
sublist.close()

tmpdir = os.listdir(src)

cnt  = 0
for s in n2:
	for t in tmpdir:
		if s==t:
			cnt = cnt+1
			shutil.copy(src +'\\'+s + '\\fmri\\nback\\task_design\\taskdesign_nback.m', dst)
			os.rename(dst + '\\taskdesign_nback.m',dst+'\\'+str(cnt)+'_'+s+'_taskdesign_nback.m')
			#os.remove(dst + '\\swcarI.nii.gz')