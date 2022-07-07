import random
import matplotlib.pyplot as plt


# example data
mu = 10  # mean of distribution
sigma = 20  # standard deviation of distribution
alpha = 5 #shape of gamma distribution
beta = 2 #scale of gamma distribution
xVals = []
yVals = []
i = 0
while i < 5000:
	xVals.append(random.normalvariate(mu, sigma))
	yVals.append(random.gammavariate(alpha,sigma))
	i += 1
plt.figure(1)  
plt.subplot(223)         	
plt.hist2d(xVals, yVals, bins = 50, normed = True, cmap=plt.cm.Reds)
plt.xlabel('X')
plt.ylabel('Y')
plt.title('2-d density histogram X,Y values')

plt.subplot(221)
plt.hist(xVals, color = 'c')
plt.xlabel('X')
plt.title('histogram X values (marginal)')

plt.subplot(224)
plt.hist(yVals, color = 'orange')
plt.xlabel('Y')
plt.title('histogram Y values (marginal)')
plt.savefig("riojasfigure.pdf")


