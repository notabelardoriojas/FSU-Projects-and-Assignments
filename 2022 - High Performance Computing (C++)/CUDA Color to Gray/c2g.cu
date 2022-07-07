#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include "Jpegfile.h"
#include <time.h>


__global__
void avg(BYTE * buffer)
{
    int i = blockIdx.x; 

    BYTE *pRed, *pGrn, *pBlu;
    pRed = buffer + 3 * i;
    pGrn = buffer + 3 * i + 1;
    pBlu = buffer + 3 * i + 2;

    // luminance
    int lum = (int)(.299 * (double)(*pRed) + .587 * (double)(*pGrn) + .114 * (double)(*pBlu));

    *pRed = (BYTE)lum;
    *pGrn = (BYTE)lum;
    *pBlu = (BYTE)lum;
}

int main()
{
    UINT img_y;
    UINT img_x;
    BYTE *buffer;
    clock_t t;
    //start timing
    t = clock();
    
    //read the file to buffer with RGB format
    buffer = JpegFile::JpegFileToRGB("sample.jpg", &img_x, &img_y);

    //the following code convert RGB to gray luminance.
    std::cout << "Dimensions: " << img_x << " " << img_y << std::endl;

    BYTE * d_buffer;
    cudaMalloc((void **)&d_buffer, img_x * img_y * 3 * sizeof(BYTE));

    cudaMemcpy(d_buffer, buffer, img_x * img_y * 3 * sizeof(BYTE), cudaMemcpyHostToDevice);

    avg<<<img_x * img_y, 1>>>(d_buffer);

    cudaMemcpy(buffer, d_buffer, img_x * img_y * 3 * sizeof(BYTE), cudaMemcpyDeviceToHost);

    //write the gray luminance to another jpg file
    JpegFile::RGBToJpegFile("mono.jpg", buffer, img_x, img_y, true, 75);
    
    t = clock() - t;
    double time_taken = ((double)t)/CLOCKS_PER_SEC; // in seconds
    printf("Took %f seconds to execute \n", time_taken);
    
    delete buffer;
    cudaFree(d_buffer);

	return 1;
}
