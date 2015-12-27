from os import listdir
import os

arr = (os.listdir('C:\\Users\\WMORRIS\\Documents\\Projects\\datasciencecoursera\\Getting and Cleaning Data\\project\\UCI HAR Dataset\\test\\Inertial Signals'))
print (arr)

k =[]
for i in range(0, len(arr)):
	arr[i]="%s" %(arr[i])
	j = arr[i]
	print (j[0:-4])
	k.append(j[0:-4])
print (k)
# for i in arr:
# 	variable = i[0:-4]
# 	script = '%s<-read.table("train/%s")' % (variable, i)
# 	print (script)