from PIL import Image
import numpy as np
from math import sqrt
import time


#set K here
k = 1

#read in the image on the master
image = np.array(Image.open('monkey.jpg'))
rows, cols, channels = image.shape
image = image.reshape(rows*cols, channels).astype(np.float64)
num_pixels = len(image)
#now choose k random pixels
k_pixels = np.random.choice(list(range(num_pixels)), size=k, replace=False)
generators = np.array([image[i] for i in k_pixels])
start = time.time() #starting the clock here right after preprocessing is finished
iter = 0
while iter < 10:
	#for each generator calculate the distance between the gen and the image
	distances = []
	for gen in generators:
		distance = np.zeros(num_pixels)
		for i in range(num_pixels):
			sum = 0
			for c in range(channels):
				dist = image[i][c] - gen[c]
				dist = dist*dist
				sum += dist
			distance[i] = sqrt(sum)
		distances.append(distance)

	#now we have this 2D array of distances
	distances = np.array(distances)
	#loop through the image and find the generator which is closest to the image
	assignments = np.zeros(num_pixels)
	for i in range(num_pixels):
		pixel_array = distances[:,i]
		assignments[i] = np.argmin(pixel_array)

	#now we calculate the value of the new generators
	gen_assignments = []
	for i in range(k):
		gen_assignments.append(np.where(assignments==i)[0])

	new_generators = []
	for gen_assignment in gen_assignments:
		new_gen = np.zeros(3)
		for pix in gen_assignment:
			new_gen += image[pix]
		new_gen = np.true_divide(new_gen, len(gen_assignment))
		new_generators.append(new_gen)
		
	generators = new_generators
	iter += 1
	print(iter)


new_image = np.zeros((rows*cols, channels))
generators = np.array(generators).astype(np.uint8)
end = time.time() #stopping the clock here 
print('Total execution time: {} seconds'.format(end-start))
for gen, assignment in enumerate(gen_assignments):
	for pixel in assignment:
		new_image[pixel] = generators[gen]
new_image = new_image.reshape((rows,cols,channels)).astype(np.uint8)
im = Image.fromarray(new_image)
im.save("segmented.jpeg")
