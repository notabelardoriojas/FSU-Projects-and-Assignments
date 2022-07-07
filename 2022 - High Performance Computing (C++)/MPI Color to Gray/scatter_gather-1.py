from mpi4py import MPI
from PIL import Image
import numpy as np
import time
comm = MPI.COMM_WORLD

my_rank = comm.Get_rank()
num_processes = comm.Get_size()

def color_to_gray(chunk):
	rows, cols, channels = chunk.shape
	gray_chunk = np.zeros((rows,cols))
	for i in range(rows):
		for j in range(cols):
			sum = 0;
			for c in range(channels):
				sum += chunk[i][j][c]
			sum /= 3;
			gray_chunk[i][j] = sum
	return gray_chunk
	

if my_rank == 0:
	#read in the image on the master
	image = np.array(Image.open('Monkey.jpeg'))
	rows, cols, channels = image.shape
	#chunk everything down
	chunk_size = int(rows/(num_processes-1))
	left_over_rows = rows - (chunk_size*(num_processes-1))
	chunks = []
	#first chunk is for the master from 0 to left_over_rows
	chunk = image[0:left_over_rows]
	chunks.append(chunk)
	#now we append all the chunks for the individual processes
	for i in range(0, num_processes-1):
		start = left_over_rows+i*chunk_size
		stop = left_over_rows+(i+1)*chunk_size
		chunk = image[start:stop]
		chunks.append(chunk)
else:
	chunks = None
	
#now that we've done all the preprocessing, we can use MPI scatter

#also going to start the clock here on the master rank
if my_rank == 0:
	start = time.time()
	
chunk = comm.scatter(chunks, root=0)
chunk = color_to_gray(chunk)
g_chunks = comm.gather(chunk,root=0)

if my_rank == 0:
	#stopping the clock on the master rank
	end = time.time()
	print('Total execution time: {} seconds'.format(end-start))
	#saving the image in the master process
	g_image = g_chunks[0]
	for g_chunk in g_chunks[1:]:
		g_image = np.concatenate((g_image, g_chunk), axis = 0)
	g_image = g_image.astype(np.uint8)
	im = Image.fromarray(g_image, 'L')
	im.save("gray.jpeg")
	
MPI.Finalize
