import numpy as np
import sys
from os.path import isfile

from parallel import Parallel
from heat_io import write_field

def initialize():

    timesteps = int(20/.0001)        # Number of time-steps to evolve system
    nx = 100
    ny = 100

    if len(sys.argv) == 4:
        nx = int(sys.argv[1])
        ny = int(sys.argv[2])
        timesteps = int(sys.argv[3])
        field, field0, parallel = generate_field(nx, ny)
    else:
        field, field0, parallel = generate_field(nx, ny)

    iter0 = 0

    return field, field0, parallel, iter0, timesteps

def generate_field(nx, ny):

    parallel = Parallel(nx, ny)
    nx_local = int(nx / parallel.dims[0])
    ny_local = int(ny / parallel.dims[1])

    field = np.zeros((nx_local + 2, ny_local + 2), dtype=float)
	

    # Boundaries
    if parallel.coords[0] == 0:
        field[0,:] = 1.0
    if parallel.coords[1] == 0:
        field[:,0] = 1.0
    if parallel.coords[1] ==  parallel.dims[1] - 1:
        field[:,-1] = 1.0
    if parallel.coords[0] ==  parallel.dims[0] - 1:
        field[-1,:] = 0.0

    field0 = field.copy()

    return field, field0, parallel
