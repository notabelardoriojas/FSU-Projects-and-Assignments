import numpy as np
import math
from matplotlib import pyplot as plt

class simpInt():
	def __init__(self, functions, bound1, bound2, intervals):
		self.f = functions[0]
		self.x0 = bound1
		self.xf = bound2
		self.delta = (bound2-bound1)/intervals
		self.t = intervals
	def solve(self):
		xVals = np.linspace(self.x0,self.xf,self.t+1)
		total = self.f(self.x0) + self.f(self.xf)
		for i in range(1,self.t):
			if i % 2 == 1:
				total += 4*(self.f(xVals[i]))
			else:
				total += 2*(self.f(xVals[i]))
		return total* (self.delta/3)

def f(x):
	return np.sin(x)
functions = [f]

intervals=[1,2,10,50,100]
evaluations = []
for i in range(len(intervals)):
	integral = simpInt(functions, 0.0, 7*math.pi, intervals[i])
	answer = integral.solve()
	evaluations.append(answer)
plt.xlabel("Number of intervals")
plt.ylabel("Simpson's method evaluation")
plt.plot(intervals,evaluations)
line1 = plt.plot([0,100],[2,2],label = "true evaluation of the integral", color = 'g')
plt.text(30,-10, "The method seems to converge to the true value \nat an exponential rate, reaching values \nvery close to the actual value at t = 50.")
plt.legend()
#plt.savefig("RiojasLab7.pdf")
plt.show()
