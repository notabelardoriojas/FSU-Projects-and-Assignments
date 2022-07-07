
I found an easier way to do this project with a library that wasn't Jpeglib (which is terrible!!)


BEFORE YOU DO ANYTHING: RUN THIS


module load devtoolset-9
module load mpi/openmpi3-x86_64

This code requires a version of OpenMP above 4.0 (4.5), so make sure your gcc compiler uses OpenMP 4.5+

To run the serial code it's as easy as 

./serial.out -k 4 -m 20 monkey.jpg

k = number of generators
m = number of iterations

same for the serial code except for:
t = number of threads

./omp.out -k 4 -m 20 -t *your desired amount of threads* monkey.jpg

You should get some awesome looking output!

Heck yeah,
Abelardo Riojas 

