#!/usr/bin/env python
from __future__ import print_function
import sys
import numpy as np
#np.set_printoptions(threshold=sys.maxsize)
import mandelbrot as mandel
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.cm as cm
import time

if __name__ == '__main__':
    #X = -0.7453
    #Y = 0.1127
    #R = 0.00065
    X = -0.0452407411
    Y = 0.9868162204352258
    R = 0.0000001
    print("Mandelbrot set fractal generator for coordinates {}/{}\n".format(X, Y))
    im_width = 1000
    im_height = 1000
    ymin,ymax = X-R, X+R
    xmin, xmax = Y-R, Y+R
    xwidth = xmax-xmin
    yheight = ymax - ymin
    nitmax = 10000
    zabsmax = 2.0
    tic = time.time()
    mm = mandel.mandelbrot_loop(im_width, im_height, yheight, xwidth, ymin, xmin, nitmax)
    toc = time.time()
    print("Elapsed time for calculations:",toc-tic)
    print("Plot the Mandelbrot set into the file mandelbrotfig.pdf")
    fig, ax = plt.subplots()
    ax.imshow(mm, interpolation='nearest', cmap=cm.jet)
    plt.savefig('mandelbrotfig.pdf')
