import numpy as np
import matplotlib.pyplot as plt
import math
import sys
def hilbert(order):
    #creating hilbert order 1
    dim = pow(2,1)
    cellnum = dim*dim
    x = 1/(dim*2)
    y = 1/(dim*2)
    xVals = np.array([])
    xValsOG = np.array([x,x,3*x,3*x])
    yVals = np.array([])
    yValsOG = np.array([y,3*y,3*y,y])
    xfVals = xValsOG
    yfVals = yValsOG
    
    #orders 2-7
    j = 1
    while j < order:
        dim = pow(2,j+1)
        cellnum = dim*dim
        x = 1/(dim*2)
        xVals = xfVals/2
        yVals = yfVals/2
        xfVals = np.array([])
        yfVals = np.array([])
        for i in range(4):
            tempx = np.array([])
            tempy = np.array([])
            if i == 0:
                tempx = xVals
                tempy = yVals
            elif i == 1:
                tempx = xVals
                tempy = yVals + .5
            elif i == 2:
                tempx = xVals + .5
                tempy = yVals + .5
            else:
                tempx = xVals + .5
                tempy = yVals
            xfVals = np.append(xfVals,tempx)
            yfVals = np.append(yfVals,tempy)
        flip(xfVals, yfVals, cellnum, x)
        j = j +1
    #plotting
    plt.figure(figsize=(10,10))
    plt.plot(xfVals, yfVals)
    plt.axis([0, 1, 0, 1])
    plt.xticks(np.linspace(0,1, num = dim+1))
    plt.yticks(np.linspace(0,1, num = dim+1))
    plt.grid(True)
    title = "hilbert" + str(order) + ".pdf"
    plt.savefig(title)
    


    
def flip(xVals, yVals, cellnum, step):
    s = int(math.sqrt(cellnum))
    ind = np.array([])
    #getting a list of indicies of x and y values from left to right
    for i in range(s):
        wy = np.where(yVals == (1-step)-(step*2*i))
        b = wy[0]
        for j in range(s): 
            wx = np.where(xVals == step+(step*2*j))
            a = wx[0]
            for k in range(len(a)):
                for l in range(len(b)):
                    if a[k] == b[l]:
                        ind = np.append(ind,a[k])
    #get array of x and y value incidies of bottom left and right squares from left to right
    bleft = np.array([])
    bright = np.array([])
    for m in range(s):
        if m % 2 == 0:
            bleft = np.append(bleft,ind[(int(len(ind)/2)) + int(s/2)*m :(int(len(ind)/2)) + int(s/2)*(m+1)])
        else:
            bright = np.append(bright,ind[(int(len(ind)/2)) + int(s/2)*m :(int(len(ind)/2)) + int(s/2)*(m+1)])
    #reshape for flipping
    bleft = np.reshape(bleft,(int(s/2),int(s/2)))
    bright = np.reshape(bright,(int(s/2),int(s/2)))
    #copy of ind for reasons that will be explained later
    nind = np.array(ind)
    #flipping bottom left square by \ diagonal
    n = len(bleft)
    blc = np.array(bleft)
    for j in range(n):
        for i in range(n):
            bleft[j][i] = blc[n-i-1][n-j-1]
    #flipping bottom right square by / diagonal
    for i in range(0, n):
        for j in range(i+1, n):
            bright[i][j],bright[j][i] = bright[j][i],bright[i][j]
    #reassigning ind of corners
    bleft = bleft.flatten()
    bright = bright.flatten()
    hind = int(len(ind)/2)
    row = int(s/2)
    rownum = int(len(bleft)/row)*2
    brow = int(len(bleft)/row)
    for i in range(rownum):
        if i % 2 == 0:
            ind[hind+i*row:hind+(i+1)*row] = bleft[brow*int(i/2):row*int(i/2)+row]
        else:
            ind[hind+(i)*row:hind+(i+1)*row] = bright[brow*int(i/2):row*int(i/2)+row]
    #writing ind to x and y vals
    xValc = np.array(xVals)
    yValc = np.array(yVals)
    #need copy of ind to swap correctly
    for i in range(len(xVals)):
        xVals[int(nind[i])] = xValc[int(ind[i])]
        yVals[int(nind[i])] = yValc[int(ind[i])]
try:       
	hilorder = int(sys.argv[1])
except ValueError: 
	print("Please input a valid interger for the order of the Hilbert curve.")
else:	
	if hilorder >= 1 and hilorder <= 7:
		hilbert(hilorder)
	elif hilorder > 7:
		hilbert(7)
	else:
		print("Please input a valid interger for the order of the Hilbert curve.")
