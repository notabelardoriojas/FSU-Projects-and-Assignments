from mpi4py import MPI

class Parallel(object):

    def __init__(self, nx, ny):
        self.requests = []
        world = MPI.COMM_WORLD
        world_size = world.Get_size()
        self.dims = MPI.Compute_dims(world_size, (0,0))
        nx_local = nx / self.dims[0]
        ny_local = ny / self.dims[1]
        if nx_local * self.dims[0] != nx:
            print("Cannot divide grid evenly to processors in x-direction!")
            print("{0} x {1} != {2}".format(nx_local, self.dims[0], nx))
            raise RuntimeError('Invalid domain decomposition')
        if ny_local * self.dims[1] != ny:
            print("Cannot divide grid evenly to processors in y-direction!")
            print("{0} x {1} != {2}".format(ny_local, self.dims[1], ny))
            raise RuntimeError('Invalid domain decomposition')

        self.comm = world.Create_cart(self.dims, periods=None, reorder=True)
        self.nup, self.ndown = self.comm.Shift(0, 1)
        self.nleft, self.nright = self.comm.Shift(1, 1)
        self.size = self.comm.Get_size()
        self.rank = self.comm.Get_rank()
        self.coords = self.comm.coords

        if self.rank == 0:
            print("Using domain decomposition {0} x {1}".format(self.dims[0],
                                                                self.dims[1]))
            print("Local domain size {0} x {1}".format(nx_local, ny_local))

        # Maybe there is more elegant way to initialize the requests array?
        self.requests = [0, ] * 8

        # Datatypes for halo exchange
        self.rowtype = MPI.DOUBLE.Create_contiguous(ny_local + 2)
        self.rowtype.Commit()
        self.columntype = MPI.DOUBLE.Create_vector(nx_local + 2, 1, 
                                                   ny_local + 2)
        self.columntype.Commit()

        # Datatypes for subblock needed in text I/O
        # Rank 0 uses datatype for receiving data into full array while
        # other ranks use datatype for sending the inner part of array

        subsizes = [nx_local, ny_local]
        if self.rank == 0:
            sizes = [nx, ny]
            offsets = [0, 0]
        else:
            sizes = [nx_local + 2, ny_local + 2]
            offsets = [1, 1]

        self.subarraytype = MPI.DOUBLE.Create_subarray(sizes, subsizes, offsets)
        self.subarraytype.Commit()

        # Datatypes for restart I/O
        sizes = [nx + 2, ny + 2]
        offsets = [1 + self.coords[0] * nx_local, 1 + self.coords[1] * ny_local]
        if self.coords[0] == 0:
            offsets[0] -= 1
            subsizes[0] += 1

        if self.coords[0] == (self.dims[0] - 1):
            subsizes[0] += 1

        if self.coords[1] == 0:
            offsets[1] -= 1
            subsizes[1] += 1

        if self.coords[1] == (self.dims[1] - 1):
            subsizes[1] += 1

        self.filetype = MPI.DOUBLE.Create_subarray(sizes, subsizes, offsets)
        self.filetype.Commit()

        sizes = [nx_local + 2, ny_local + 2]
        offsets = [1, 1]
        if self.coords[0] == 0:
            offsets[0] = 0
        if self.coords[1] == 0:
            offsets[1] = 0

        self.restarttype = MPI.DOUBLE.Create_subarray(sizes, subsizes, offsets)
        self.restarttype.Commit()

