import math
import time
import final
from matplotlib import pyplot as plt

#f(x,y) = sin(.5+y+(1.0/x)*cos(.5+x+(1.0/y))

def f():
	dim = 1000
	oned = [0]*dim
	values = [oned]*dim
	for i in range(dim):
		for j in range(dim):
			xi = 1 + (4.0/dim)*i
			yi = 1 + (9.0/dim)*j
			#print (xi,yi)
			values[i][j] = math.sin(.5 + yi + (1.0/xi)) + math.cos(.5 + xi + (1.0/yi))
	return values
	
start = time.time()
vals = f()	
end = time.time()
ptt = end-start
print("python total time = " + str(end-start))

start = time.time()
vals = final.g()	
end = time.time()
ctt = end-start
print("cython total time = " + str(end-start))

print("ratio = " + str(ctt/ptt))
plt.imshow(vals)
plt.show()
