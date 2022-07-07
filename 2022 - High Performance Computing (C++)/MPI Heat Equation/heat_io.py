from __future__ import print_function
import numpy as np
from mpi4py import MPI
from parallel import Parallel

try:
    import h5py
    use_hdf5 = True
except ImportError:
    use_hdf5 = False

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

# Set the colormap
plt.rcParams['image.cmap'] = 'BrBG'

def write_field(field, parallel, step):

    nx, ny = [i - 2 for i in field.shape]
    nx_full = parallel.dims[0] * nx
    ny_full = parallel.dims[1] * ny
    if parallel.rank == 0:
        field_full = np.zeros((nx_full, ny_full), float)
        field_full[:nx, :ny] = field[1:-1, 1:-1]
        # Receive data from other ranks
        for p in range(1, parallel.size):
            coords = parallel.comm.Get_coords(p)
            idx = coords[0] * nx * ny_full + coords[1] * ny
            parallel.comm.Recv((field_full.ravel()[idx:], 1, 
                                parallel.subarraytype), source=p)
        # Write out the data
        plt.figure()
        plt.gca().clear()
        plt.imshow(field_full)
        plt.colorbar()
        #plt.axis('off')
        plt.savefig('heat_{0:04d}.png'.format(step))
    else:
        # Send the data
        parallel.comm.Ssend((field, 1, parallel.subarraytype), dest=0)


