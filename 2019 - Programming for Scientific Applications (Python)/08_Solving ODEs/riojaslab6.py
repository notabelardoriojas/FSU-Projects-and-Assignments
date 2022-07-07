import numpy as np
from matplotlib import pyplot as plt

class ODEsolver():
	def __init__(self, t0, tf, delta, x0, y0,functions):
		self.x = [x0]
		self.y = [y0]
		self.functions = functions
		self.f = functions[0]
		self.g = functions[1]
		self.tvals = [t0,tf]
		self.delta = delta
		self.n = int(((tf-t0)/delta)) + 1
	def solve(self):
		for i in range(1,self.n):
			self.x = np.append(self.x , self.delta*(self.f(self.x[i-1],self.y[i-1])) + self.x[i-1])
			self.y = np.append(self.y , self.delta*(self.g(self.x[i-1],self.y[i-1])) + self.y[i-1])
		return self.x, self.y

def f(x,y):
	return 1 - 4*x + (y*x*x)
def g(x,y,):
	return (3*x) - (y*x*x)
	
functions = [f,g]

ode1 = ODEsolver(0.0,500.0,.01,1.5,3.0,functions)
x,y = ode1.solve()
tvals = np.linspace(0,500,50001)
plt.figure(1)
plt.subplot(121)
plt.xlabel("t")
plt.ylabel("x(t) blue, y(t) red")
plt.plot(tvals,x, color = 'b')
plt.plot(tvals,y, color = 'r')

plt.subplot(122)
plt.xlabel("x")
plt.ylabel("y")
plt.plot(x,y)
plt.show()