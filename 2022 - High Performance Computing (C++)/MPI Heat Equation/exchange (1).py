from mpi4py.MPI import Request
import numpy as np

# Time evolution for the inner part of the grid
def exchange_init(u, parallel):

    # Send to the up, receive from down
    parallel.requests[0] = parallel.comm.Isend((u[1,:], 1, parallel.rowtype),
                                                dest=parallel.nup)
    parallel.requests[1] = parallel.comm.Irecv((u[-1,:], 1, parallel.rowtype),
                                                source=parallel.ndown)
    # Send to the down, receive from up
    parallel.requests[2] = parallel.comm.Isend((u[-2,:], 1, parallel.rowtype),
                                                dest=parallel.ndown)
    parallel.requests[3] = parallel.comm.Irecv((u[0,:], 1, parallel.rowtype),
                                                source=parallel.nup)
    # Send to the left, receive from right
    parallel.requests[4] = parallel.comm.Isend((u.ravel()[1:], 1, 
                                                parallel.columntype),
                                                dest=parallel.nleft)
    idx = u.shape[1] - 1 # ny + 1
    parallel.requests[5] = parallel.comm.Irecv((u.ravel()[idx:], 1, 
                                                parallel.columntype),
                                                source=parallel.nright)
    # Send to the right, receive from left
    idx = u.shape[1] - 2 # ny
    parallel.requests[6] = parallel.comm.Isend((u.ravel()[idx:], 1, 
                                                parallel.columntype),
                                                dest=parallel.nright)
    parallel.requests[7] = parallel.comm.Irecv((u, 1, parallel.columntype),
                                                source=parallel.nleft)

def exchange_finalize(parallel):
    # MPI.Request.Waitall(parallel.requests) 
    Request.Waitall(parallel.requests) 

