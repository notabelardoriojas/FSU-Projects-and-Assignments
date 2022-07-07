import numpy as np


#TAKEN FROM AN OLD ASSIGNMENT (THANKS PROF. QUAIFE!!)

# Time evolution for the inner part of the grid
def evolve_inner(u, u_previous, a, dt, dx2, dy2):
    """Explicit time evolution.
       u:            new temperature field
       u_previous:   previous field
       a:            diffusion constant
       dt:           time step
       dx2:          grid spacing squared, i.e. dx^2
       dy2:            -- "" --          , i.e. dy^2"""

    u[2:-2, 2:-2] = u_previous[2:-2, 2:-2] + a * dt * ( \
            (u_previous[3:-1, 2:-2] - 2*u_previous[2:-2, 2:-2] + \
             u_previous[1:-3, 2:-2]) / dx2 + \
            (u_previous[2:-2, 3:-1] - 2*u_previous[2:-2, 2:-2] + \
                 u_previous[2:-2, 1:-3]) / dy2 )

# Time evolution for the edges  of the grid
def evolve_edges(u, u_previous, a, dt, dx2, dy2):
    """Explicit time evolution.
       u:            new temperature field
       u_previous:   previous field
       a:            diffusion constant
       dt:           time step
       dx2:          grid spacing squared, i.e. dx^2
       dy2:            -- "" --          , i.e. dy^2"""

    u[1, 1:-1] = u_previous[1, 1:-1] + a * dt * ( \
            (u_previous[2, 1:-1] - 2*u_previous[1, 1:-1] + \
             u_previous[0, 1:-1]) / dx2 + \
            (u_previous[1, 2:] - 2*u_previous[1, 1:-1] + \
                 u_previous[1, :-2]) / dy2 )

    u[-2, 1:-1] = u_previous[-2, 1:-1] + a * dt * ( \
            (u_previous[-1, 1:-1] - 2*u_previous[-2, 1:-1] + \
             u_previous[-3, 1:-1]) / dx2 + \
            (u_previous[-2, 2:] - 2*u_previous[-2, 1:-1] + \
                 u_previous[-2, :-2]) / dy2 )

    u[1:-1, 1] = u_previous[1:-1, 1] + a * dt * ( \
            (u_previous[2:, 1] - 2*u_previous[1:-1, 1] + \
             u_previous[:-2, 1]) / dx2 + \
            (u_previous[1:-1, 2] - 2*u_previous[1:-1, 1] + \
                 u_previous[1:-1, 0]) / dy2 )

    u[1:-1, -2] = u_previous[1:-1, -2] + a * dt * ( \
            (u_previous[2:, -2] - 2*u_previous[1:-1, -2] + \
             u_previous[:-2, -2]) / dx2 + \
            (u_previous[1:-1, -1] - 2*u_previous[1:-1, -2] + \
                 u_previous[1:-1, -3]) / dy2 )
