import os
import shutil
import re
src = '/lustre/iCAN/data/2011'
dst = '/lustre/iCAN/data/genghaiyang/nback/h18_l18/conn_FC/FunImg'
sublistpath = '/lustre/iCAN/data/genghaiyang/nback/sublist/sublist_TA_36.txt'

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
			shutil.copy(src +'/'+s + '/fmri/nback/smoothed_spm8/swcarI.nii.gz', dst)
			os.rename(dst + '/swcarI.nii.gz',dst+'/'+str(cnt)+'_'+s+'_swcarI.nii.gz')
			#os.remove(dst + '\\swcarI.nii.gz')
