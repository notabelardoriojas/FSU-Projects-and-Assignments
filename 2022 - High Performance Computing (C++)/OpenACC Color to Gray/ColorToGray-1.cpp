#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include "Jpegfile.h"
#include "omp.h"
#include <chrono>

using namespace std::chrono;

int main()
{
	UINT x;
	UINT y;
	BYTE *buffer;
	//read the file to buffer with RGB format
	buffer = JpegFile::JpegFileToRGB("testcolor.jpg", &y, &x);

	//the following code convert RGB to gray luminance.
	std::cout << "Image size: " << y << " " << x << std::endl;
	UINT row,col;

	double end = omp_get_wtime();
	#pragma acc data copy(buffer[0:y * x * 3])
	{
			#pragma acc kernels
			for (row=0;row<x;row++) {
				for (col=0;col<y;col++) {
				BYTE *pRed, *pGrn, *pBlu;
				pRed = buffer + row * y * 3 + col * 3;
				pGrn = buffer + row * y * 3 + col * 3 + 1;
				pBlu = buffer + row * y * 3 + col * 3 + 2;

				// luminance
				int lum = (int)(.299 * (double)(*pRed) + .587 * (double)(*pGrn) + .114 * (double)(*pBlu));

				*pRed = (BYTE)lum;
				*pGrn = (BYTE)lum;
				*pBlu = (BYTE)lum;
				}
			}
	}
	
	double end = omp_get_wtime();
    auto duration = duration_cast<milliseconds>(stop - start);

    std::cout<< "Done in "	<< end-start << " seconds" << std::endl;

	//write the gray luminance to another jpg file
	JpegFile::RGBToJpegFile("output.jpg", buffer, y, x, true, 75);
	
	delete buffer;
	return 1;
}