# This code generates the files 'images.txt' and 'labels.txt' in every dataset folder

import os

def findImagePaths(base):
	# print('2010' in base)
	BASE_PATH = base
	paths = []
	imgpaths = []
	file = open(base+'/images.txt','w')
	for i, j in enumerate(os.walk(BASE_PATH)):
		(dirname, dirnames, filenames) = j
		if i == 0:
			for subdirname in dirnames:
				paths.append(dirname+'/'+subdirname)
		else:
			txt = open(os.path.join(dirname,filenames[0]),'r')
			lines = txt.readlines()

			images = [line.split('\t')[2].split('/')[-1].strip() for line in lines if line.startswith('file\t')]
			x = len(images)
			trueimgs = []
			for l in range(int(x/2)):
				d = dirname.split('\\')[-1]
				if images[l].startswith(d) and images[l+int(x/2)].startswith(d):
					if '2010' in base:
						trueimgs.append(images[l])
						trueimgs.append(images[l+int(x/2)])
						break;
					else:
						trueimgs.append(images[l])
						trueimgs.append(images[l+int(x/2)])
			txt.close()
			for filename in trueimgs:
				if filename.endswith('.tiff'):
					imgpaths.append(paths[i-1]+'/'+filename+'\n')
	file.writelines(imgpaths)
	file.close()

def generateLabels(base):
	labelFile = open(base+'/labels.txt','w')
	file = open(base+'/images.txt','r')
	imagePaths = file.readlines()
	file.close()
	labels = [path.split('/')[-2]+'\n' for path in imagePaths]
	# print(labels[0:5])
	labelFile.writelines(labels)
	labelFile.close()


if __name__ == "__main__":
	paths = ['../LG2200_2008','../LG2200_2010','../LG4000_2010']
	[findImagePaths(p) for p in paths]
	[generateLabels(p) for p in paths]