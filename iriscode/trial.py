# This code reads the labels from Galler and probes and finds how many common labels exist


def findMatch(f1, f2):
	a = f1.readlines()
	b = f2.readlines()
	a = set(a)
	b = set(b)
	return len(a&b)

if __name__ == '__main__':
	f1 = open('../LG2200_2008/labels.txt','r')
	f2 = open('../LG4000_2010/labels.txt','r')
	print(findMatch(f1,f2))
	f1.close()
	f2.close()