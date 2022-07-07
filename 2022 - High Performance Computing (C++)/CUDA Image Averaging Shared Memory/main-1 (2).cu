#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include <iostream>
#include "omp.h"
#include "utils/pngio.h"

#define BLOCK_SIZE (16u)
#define FILTER_SIZE (5u)
#define TILE_SIZE (12U) // BLOCK_SIZE - (2 * (FILTER_SIZE/2))



//defining kernel function
__global__ void processImage(unsigned char * out, const unsigned char * in, size_t pitch, unsigned int width, unsigned int height){
	
	int x_o = (TILE_SIZE*blockIdx.x) + threadIdx.x;
	int y_o = (TILE_SIZE*blockIdx.y) + threadIdx.y;
	
	int x_i = x_o - (FILTER_SIZE/2);
	int y_i = y_o - (FILTER_SIZE/2);
	int sum = 0;
	
	//defining shared memory
	__shared__ unsigned char sBuffer[BLOCK_SIZE][BLOCK_SIZE];
	
	//copying inside shared memory
	if ((x_i >= 0) && (x_i < width) && (y_i >= 0) && (y_i < width)){
		sBuffer[threadIdx.y][threadIdx.x] = in[y_i * pitch + x_i];
	}
	else
		sBuffer[threadIdx.y][threadIdx.x] = 0;
	
	__syncthreads();
	
	if ( threadIdx.x < TILE_SIZE && threadIdx.y < TILE_SIZE ) {
		for (int r = 0; r < FILTER_SIZE; ++r )
			for (int c = 0; c < FILTER_SIZE; ++c)
				sum += sBuffer[threadIdx.y + r][threadIdx.x + c];
	sum /= FILTER_SIZE * FILTER_SIZE;
	
	if ( x_o < width && y_o < height )
		out[ y_o * width + x_o] = sum;
				
		}
	}

int main(int argc, char **argv) {
	std::cout << "Loading image..." << std::endl;
	//loading function
	png::image<png::rgb_pixel> img("../lena.png");
	
	unsigned int width = img.get_width();
	unsigned int height = img.get_height();
	
	//defining size to allocate memory
	int size = width * height * sizeof(unsigned char);
	
	//allocating memory buffer to host memory
	unsigned char *h_r = (unsigned char*) malloc ( size * sizeof(unsigned char));
	unsigned char *h_g = (unsigned char*) malloc ( size * sizeof(unsigned char));
	unsigned char *h_b = (unsigned char*) malloc ( size * sizeof(unsigned char));
	
	//allocating memory for the output
	unsigned char *h_r_n = (unsigned char*) malloc ( size * sizeof(unsigned char));
	unsigned char *h_g_n = (unsigned char*) malloc ( size * sizeof(unsigned char));
	unsigned char *h_b_n = (unsigned char*) malloc ( size * sizeof(unsigned char));
	
	//converting image to raw buffer
	pvg::pngtoRgb3(h_r, h_g, h_b, img);
	
	//allocating memory on device
	unsigned char *d_r_n = NULL;
	unsigned char *d_g_n = NULL;
	unsigned char *d_b_n = NULL;
	
	CUDA_CHECK_RETURN(cudaMalloc(&d_r_n, size));
	CUDA_CHECK_RETURN(cudaMalloc(&d_g_n, size));
	CUDA_CHECK_RETURN(cudaMalloc(&d_b_n, size));
	
	//allocating image buffer on device
	
	unsigned char *d_r = NULL;
	unsigned char *d_g = NULL;
	unsigned char *d_b = NULL;
	
	size_t pitch_r = 0;
	size_t pitch_g = 0;
	size_t pitch_b = 0;
	
	CUDA_CHECK_RETURN( cudaMallocPitch(&d_r, &pitch_r, width, height));
	CUDA_CHECK_RETURN( cudaMallocPitch(&d_g, &pitch_g, width, height));
	CUDA_CHECK_RETURN( cudaMallocPitch(&d_b, &pitch_b, width, height));
	
	//copy raw buffer from host to device
	CUDA_CHECK_RETURN( cudaMemcpy2D(d_r, pitch_r, h_r, width, width, height, cudaMemcpyHostToDevice) );
	CUDA_CHECK_RETURN( cudaMemcpy2D(d_g, pitch_g, h_g, width, width, height, cudaMemcpyHostToDevice) );
	CUDA_CHECK_RETURN( cudaMemcpy2D(d_b, pitch_b, h_b, width, width, height, cudaMemcpyHostToDevice) );
	
	//configure image kernel
	dim3 grid_size((width + TILE_SIZE - 1)/TILE_SIZE, (height + TILE_SIZE -1)/TILE_SIZE);
	dim3 block_size(BLOCK_SIZE, BLOCK_SIZE);
	
	double start = omp_get_wtime();
	
	processImage<<<grid_size, block_size>>>(d_r_n, d_r, pitch_r, width, height);
	processImage<<<grid_size, block_size>>>(d_g_n, d_g, pitch_g, width, height);
	processImage<<<grid_size, block_size>>>(d_b_n, d_b, pitch_b, width, height);
	
	CUDA_CHECK_RETURN(cudaDeviceSynchronize());
	
	double end = omp_get_wtime();
	
	CUDA_CHECK_RETURN( cudaMemcpy(h_r_n, d_r_n, size, cudaMemcpyDeviceToHost) );
	CUDA_CHECK_RETURN( cudaMemcpy(h_g_n, d_g_n, size, cudaMemcpyDeviceToHost) );
	CUDA_CHECK_RETURN( cudaMemcpy(h_g_n, d_b_n, size, cudaMemcpyDeviceToHost) );
	
	pvg::rgb3ToPng(img, h_r_n, h_g_n, h_b_n);
	std::cout<< "Done in "	<< end-start << " seconds" << std::endl;
	
	img.write("../lena_new.png");
	
	CUDA_CHECK_RETURN(cudaFree(d_r));
	CUDA_CHECK_RETURN(cudaFree(d_r_n));
	
	CUDA_CHECK_RETURN(cudaFree(d_g));
	CUDA_CHECK_RETURN(cudaFree(d_g_n));
	
	CUDA_CHECK_RETURN(cudaFree(d_b));
	CUDA_CHECK_RETURN(cudaFree(d_b_n));
	
	free(h_r);
	free(h_r_n);
	
	free(h_g);
	free(h_g_n);
	
	free(h_b);
	free(h_b_n);
	
	return 0;
}
