import random
import math
import sys

try:       
	float(sys.argv[1])
except IndexError: 
	print("\nYou must input coordinates into the program as follows for it to run. \nExample command: python lab1.py 29.1872 'N' 82.1401 'W'\n")
	print("Lake City: 30.1897 'N' 82.6393 'W' \nOcala: 29.1872 'N' 82.1401 'W'\n")
	sys.exit()

def randListGen(length):
	randlist = [];
	for i in range(length):
		randlist.append(random.randint(1,101))
		
	return randlist
	
	
def selectionSort(array, display):
	n = len(array)
	if (display == 1):
		print ('\nSelection Sort, n = ' + str(n) + '\n Unsorted Array: ' + str(array))
	smallestInd = 0
	indexArray = list(range(n))
	for i in range(n):
		temp = array[smallestInd]
		indexTemp = indexArray[smallestInd]
		array[smallestInd] = array[i-1]
		indexArray[smallestInd] = indexArray[i-1]
		array[i-1] = temp 
		indexArray[i-1] = indexTemp
		smallestInd = i
		for j in range(i,n):
			if (array[smallestInd] > array[j]):
				smallestInd = j
	return([indexArray, array])

def bubbleSort(array):		
	n = len(array)	
	print('\nBubble Sort, n = ' + str(n) + '\n Unsorted Array: ' + str(array))

	indexArray = list(range(n))
	flag = 0
	while(flag < n-1):
		flag = 0
		for i in range(n-1):
			if(array[i] > array[i+1]):
					temp = array[i]
					indexTemp = indexArray[i]
					array[i] = array[i+1]
					indexArray[i] = indexArray[i+1]
					array[i+1] = temp
					indexArray[i+1] = indexTemp
			else:
				flag = flag + 1
	return([indexArray, array])
	
bs = bubbleSort(randListGen(25))
print(' Index Array:    ' + str(bs[0]) + '\n Sorted Array:   ' + str(bs[1]))
ss = selectionSort(randListGen(25),1)
print(' Index Array:    ' + str(ss[0]) + '\n Sorted Array:   ' + str(ss[1]))

print('\nTesting for sortedness using sorted():')
print(sorted(bs[1]) == bs[1])
print(sorted(ss[1]) == ss[1])

def haversine(lat1, dir_lat1, lon1, dir_lon1, lat2, dir_lat2, lon2, dir_lon2):

    R = 6371000
    #todo
    #comment code

    phi_1 = math.radians(lat1)
    phi_2 = math.radians(lat2)

    delta_phi = math.radians(lat2 - lat1)
    delta_lambda = math.radians(lon2 - lon1)

    a = math.sin(delta_phi / 2.0) ** 2 + math.cos(phi_1) * math.cos(phi_2) * math.sin(delta_lambda / 2.0) ** 2
    
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))

    meters = R * c
    km = meters / 1000
    return(round(km,3))
    

class store:
	storelist = []
	def __init__(self, storeName, city, lat, dir_lat, lon, dir_lon):
		self.storeName = storeName
		self.city = city
		if (dir_lat == 'S'):
			lat = float(lat) * -1.0
		self.lat = float(lat)
		if (dir_lon == 'W'):
			lon = float(lon) * -1.0
		self.lon = float(lon)
		self.dir_lat = dir_lat
		self.dir_lon = dir_lon
		
	@classmethod
	def makeStoreList(cls,storeList):
		cls.storelist.append(store(storeList[0], storeList[1], storeList[2], storeList[3], storeList[4], storeList[5]))
		
		
with open('stores_location.dat', 'r') as f:
	for line in f:
		store.makeStoreList(line.split())


def distance():
	distances = []
	lat = float(sys.argv[1])
	dir_lat = sys.argv[2]
	lon = float(sys.argv[3])
	dir_lon = sys.argv[4]
	if (dir_lon == 'W'):
			lon = float(lon) * -1.0
	if (dir_lat == 'S'):
			lat = float(lat) * -1.0
	n = len(store.storelist)
	print('\nFinding closest stores for ' + str(lat) + ', ' +  str(lon))
	for i in range(n):
		distance = haversine(lat, dir_lat, lon, dir_lon, store.storelist[i].lat, store.storelist[i].dir_lat, store.storelist[i].lon, store.storelist[i].dir_lon)
		distances.append(distance)
	sortedstores = selectionSort(distances,0)
	index = sortedstores[0]
	j = 0
	for i in index:
		print(str(store.storelist[i].storeName) + ' ' + str(store.storelist[i].city) + ' ' +  str(round(sortedstores[1][j] * 0.621371, 2)) + ' miles')
		j = j + 1
distance()

