from __future__ import print_function
import numpy as np
import time
import os

from heat_setup import initialize
from evolve import evolve_inner, evolve_edges
from exchange import exchange_init, exchange_finalize
from heat_io import write_field


# Basic parameters
a = 1.0                # Diffusion constant
#image_interval = 1000   # Write frequency for png files

# Grid spacings
dx = 0.03
dy = 0.04
dx2 = dx**2
dy2 = dy**2


dt = .0001

def main():
    # Initialize
    field, field0, parallel, iter0, timesteps = initialize()

    write_field(field, parallel, iter0)
    t0 = time.time()
    for iter in range(iter0, iter0 + timesteps):
        exchange_init(field0, parallel)
        evolve_inner(field, field0, a, dt, dx2, dy2)
        exchange_finalize(parallel)
        evolve_edges(field, field0, a, dt, dx2, dy2)
        if iter == 2e5 - 1:
            write_field(field, parallel, iter)
        field, field0 = field0, field

    t1 = time.time()
    if parallel.rank == 0:
        print("Running time: {0}".format(t1-t0))

if __name__ == '__main__':
    main()
