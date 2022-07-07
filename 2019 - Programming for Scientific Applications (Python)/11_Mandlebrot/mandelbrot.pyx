import numpy as np
cimport numpy as np
from libc.math cimport abs as absolutevalue

DTYPE = np.double

cdef double calcz(double complex z, double complex c, double zabsmax):
  cdef double ratio = 0.0
  cdef double nit = 0.0
  cdef double nitmax = 255.0
  while absolutevalue(z) < zabsmax and nit < nitmax:
      z = z*z + c
      nit += 1.0
  ratio = nit / nitmax
  return ratio



cpdef np.ndarray[np.float64_t, ndim=1] mandelbrot_loop(long im_width, long im_height, double xwidth, double yheight, double xmin, double ymin, double nitmax):
    cdef double zabsmax = 2.0
    cdef double maxval = 0.0
    cdef int ix
    cdef int iy
    cdef int i
    cdef double nit = 0.0
    cdef double complex c
    cdef double complex z = .0j
    cdef np.ndarray mm = np.zeros([im_height*im_width], dtype=DTYPE)
    for i in range(im_width * im_height):
        ix = i/im_width
        iy = i - ix * im_width
        c = complex(xmin + ix*xwidth/im_width, ymin + iy*yheight/im_height)
        mm[i] = calcz(z,c,zabsmax)
    return mm.reshape(im_width,im_height)
