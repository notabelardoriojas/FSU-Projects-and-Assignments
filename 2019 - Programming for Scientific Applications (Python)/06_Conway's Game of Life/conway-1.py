import sys
import os
import random
import math
import time
import numpy as np


XX = u'\u2588'

proto = []
Map = []
world = []
#making a blank page
for num in range(1,23):
	proto.append([' ']*102)
	Map.append([' ']*102)


def printworld(worldtype):
	#making Map into world
	for num in range(0,22):
		row = str(''.join(worldtype[num]))
		world.append(row)
		print world[num]

def placeGlider(n,m):
	proto[n-1][m] = XX.encode('utf-8')
	proto[n][m+1] = XX.encode('utf-8')
	for i in range(-1,2):
		proto[n+1][m+i] = XX.encode('utf-8')

def placeSpaceship(n,m):
	proto[n][m] = XX.encode('utf-8')
	proto[n][m+3] = XX.encode('utf-8')
	proto[n+1][m+4] = XX.encode('utf-8')
	proto[n+2][m] = XX.encode('utf-8')
	proto[n+2][m+4] = XX.encode('utf-8')
	for i in range (1,5):
		proto[n+3][m+i] = XX.encode('utf-8')
def placeGlidergun(n,m):
	proto[n+6][m+1] = XX.encode('utf-8')
	proto[n+5][m+2] = XX.encode('utf-8')
	proto[n+6][m+2] = XX.encode('utf-8')
	for i in range(0,3):
		proto[n+4+i][n+10] = XX.encode('utf-8')
	proto[n+3][m+11] = XX.encode('utf-8')
	proto[n+7][m+11] = XX.encode('utf-8')
	proto[n+2][m+12] = XX.encode('utf-8')
	proto[n+2][m+13] = XX.encode('utf-8')
	proto[n+8][m+12] = XX.encode('utf-8')
	proto[n+8][m+13] = XX.encode('utf-8')
	proto[n+9][m+23] = XX.encode('utf-8')
	proto[n+9][m+24] = XX.encode('utf-8')
	proto[n+10][m+24] = XX.encode('utf-8')
	proto[n+6][m+26] = XX.encode('utf-8')
	proto[n+6][m+27] = XX.encode('utf-8')
	proto[n+8][m+26] = XX.encode('utf-8')
	proto[n+8][m+27] = XX.encode('utf-8')
	proto[n+7][m+26] = XX.encode('utf-8')
	proto[n+7][m+27] = XX.encode('utf-8')
	proto[n+7][m+28] = XX.encode('utf-8')
	proto[n+7][m+35] = XX.encode('utf-8')
	proto[n+8][m+35] = XX.encode('utf-8')
	proto[n+8][m+34] = XX.encode('utf-8')
	
		
	
	
def makeBorder(worldtype):
	worldtype[0][0] = '+'
	worldtype[21][0] = '+'
	worldtype[0][101] = '+'
	worldtype[21][101] = '+'
	for num in range(1,21):
		worldtype[num][0] = '|'
		worldtype[num][101] = '|'
	for num in range(1,101):
		worldtype[0][num] = '-'
		worldtype[21][num] = '-'


def applyRules(worldtype):
	
	for rownum in range(1,21):
		for colnum in range(1,101):
			#check for alive cell
			if worldtype[rownum][colnum] == XX.encode('utf-8'):
				neighbors = 0
				#check alive cell's neighbors
				for i in range(-1,2):
					if worldtype[rownum-1][colnum+i] == XX.encode('utf-8'):
						neighbors += 1
						#print 'ding 1'
				for j in range(-1,2):
					if worldtype[rownum+1][colnum+j] == XX.encode('utf-8'):
						neighbors += 1
						#print 'ding 2'
				if worldtype[rownum][colnum-1] == XX.encode('utf-8'):
						neighbors += 1
						#print 'ding 3'
				if worldtype[rownum][colnum+1] == XX.encode('utf-8'):
						neighbors += 1
						#print 'ding 4'
				#check neighbor count, reproduce if neighbors are 2 or 3
				#print "alive: proto[" + str(rownum) + "][" + str(colnum) + "]'s neighbors: " + str(neighbors)
				if neighbors == 2 or neighbors == 3:
					Map[rownum][colnum] = XX.encode('utf-8')
					#print "kept cell"
				else:
					Map[rownum][colnum] = ' '
			#check for dead cell
			elif worldtype[rownum][colnum] == ' ':
				neighbors = 0
				#check alive cell's neighbors
				for i in range(-1,2):
					if worldtype[rownum-1][colnum+i] == XX.encode('utf-8'):
						neighbors += 1
						#print 'ding 1'
				for j in range(-1,2):
					if worldtype[rownum+1][colnum+j] == XX.encode('utf-8'):
						neighbors += 1
						#print 'ding 2'
				if worldtype[rownum][colnum-1] == XX.encode('utf-8'):
						neighbors += 1
						#print 'ding 3'
				if worldtype[rownum][colnum+1] == XX.encode('utf-8'):
						neighbors += 1
						#print 'ding 4'
				#check neighbor count, reproduce if neighbors = 3
				#print "dead proto[" + str(rownum) + "][" + str(colnum) + "]'s neighbors: " + str(neighbors)
				if neighbors == 3:
					Map[rownum][colnum] = XX.encode('utf-8')
					#print "made cell"

	makeBorder(Map)
	return Map
	
makeBorder(proto)
#placeGlider(4,10)
#placeSpaceship(4,30)
placeGlidergun(2,10)
#applyRules(proto)
#printworld(proto)
while True:
	time.sleep(.1)
	os.system('clear')
	applyRules(proto)
	printworld(Map)
	del proto [:]
	for j in range(0,22):
		proto.append(Map[j])
	del Map[:]
	for k in range(0,22):
		Map.append([' ']*102)
	del world[:]

	
				

