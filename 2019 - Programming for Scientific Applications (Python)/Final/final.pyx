import math
import time 
from matplotlib import pyplot as plt

#f(x,y) = sin(.5+y+(1.0/x)*cos(.5+x+(1.0/y))

cpdef g():
	cdef int dim = 1000
	oned = [0]*dim
	values = [oned]*dim
	cdef int i
	cdef int j
	cdef float xi
	cdef float yi
	for i in range(dim):
		for j in range(dim):
			xi = 1 + (4.0/dim)*i
			yi = 1 + (9.0/dim)*j
			#print (xi,yi)
			values[i][j] = math.sin(.5 + yi + (1.0/xi)) + math.cos(.5 + xi + (1.0/yi))
	return values
