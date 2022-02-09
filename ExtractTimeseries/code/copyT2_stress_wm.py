import os
import shutilc
import re
src = '/lustre/iCAN/data/2011'
dst = '/lustre/iCAN/data/genghaiyang/nback/h18_l18/conn_FC/T1Img'
sublistpath = '/lustre/iCAN/data/genghaiyang/nback/sublist/sublist_TA_36.txt'

sublist= open(sublistpath,"a+")
n2=[]
for j in sublist.readlines():
    n2.append(j.split()[0])
sublist.close()

tmpdir = os.listdir(src)
cnt  = 0
for s in n2:
	for t in tmpdir:c
		if s==t:
			cnt = cnt+1
			shutil.copy(src +'/'+s + '/mri/anatomy/I.nii.gz', dst)
			os.rename(dst + '/I.nii.gz',dst+'/'+str(cnt)+'_'+s+'_I.nii.gz')
			#os.remove(dst + '\\swcarI.nii.gz')
