from mpi4py import MPI
from PIL import Image
import numpy as np
from math import sqrt
import time
comm = MPI.COMM_WORLD

my_rank = comm.Get_rank()
num_processes = comm.Get_size()



if my_rank == 0:
	#read in the image on the master
	image = np.array(Image.open('monkey.jpg'))
	rows, cols, channels = image.shape
	image = image.reshape(rows*cols, channels).astype(np.float64)
	num_pixels = len(image)
	#now choose k random pixels
	k_pixels = np.random.choice(list(range(num_pixels)), size=num_processes, replace=False)
	generators = [image[i] for i in k_pixels]

else:
	image = None
	generators = None

start = time.time() #starting the clock here right after preprocessing is finished
image = comm.bcast(image, root=0)
generator = comm.scatter(generators, root=0)

iter = 0
while iter < 10: #only going to do 10 iterations
	#now that every process has it's own generator and copy of the image we calculate the distance between the image and the generator

	distance = []
	num_pixels, channels = image.shape
	for i in range(num_pixels):
		sum = 0;
		for c in range(channels):
			dist = image[i][c] - generator[c]
			dist = dist*dist
			sum += dist
		distance.append(sqrt(sum))


	#print('Process {}: here are the distances between my generator and the first 10 pixels:\n\t First ten: {}\n\t My generator: {}'.format(my_rank, distance[:10], generator))

	#and send it to the master process
	distances = comm.gather(distance, root=0)
	#now the master process has this 2d array of distances and it needs to make a vector of assignments for each new generator
	if my_rank == 0:
		assignments = np.zeros(num_pixels)
		distances = np.array(distances)
		for i in range(num_pixels):
			pixel_array = distances[:,i]
			assignments[i] = np.argmin(pixel_array)
		#now that we have our assignments the individual processes calculate their new values of the generators
		assign = []
		for i in range(num_processes):
			assign.append(np.where(assignments == i))
	else:
		assign = None

	#scatter the assignment to each process	
	assignment = comm.scatter(assign, root=0)
	#set generators to zero
	generator = np.zeros(3)
	#for some reason i have to do this
	assignment = assignment[0]
	for pix in assignment:
		generator += image[pix]
	#now we have a new value for the generator
	generator = np.true_divide(generator, len(assignment))
	iter += 1


#after that's all done we finish up with the master process
generators = comm.gather(generator, root=0)
assignments = comm.gather(assignment, root=0)
end = time.time() #stopping the clock here 
print('Total execution time: {} seconds'.format(end-start))
if my_rank == 0:
	new_image = np.zeros((rows*cols, channels))
	generators = np.array(generators).astype(np.uint8)
	for gen, assignment in enumerate(assignments):
		for pixel in assignment:
			new_image[pixel] = generators[gen]
	new_image = new_image.reshape((rows,cols,channels)).astype(np.uint8)
	im = Image.fromarray(new_image)
	im.save("segmented.jpeg")
			
		
	
MPI.Finalize

