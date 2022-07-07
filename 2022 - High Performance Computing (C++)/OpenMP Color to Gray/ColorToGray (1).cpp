#include <omp.h>
#include <stdio.h>
#include <iostream>
#include <stdlib.h>
#include "Jpegfile.h"

int main()
{
	double start,end;
	start = omp_get_wtime(); 
	UINT height;
	UINT width;
	BYTE *dataBuf;
	//read the file to dataBuf with RGB format
	dataBuf = JpegFile::JpegFileToRGB("testcolor.jpg", &width, &height);

	//the following code convert RGB to gray luminance.
	
	//UINT row,col;

	#pragma omp parallel shared(dataBuf) 
	{ //parallel block start
	// how many workers do we have?
	unsigned numThreads = omp_get_num_threads();
	const int chunk = height/numThreads;
    // which one am I?
    unsigned id = omp_get_thread_num();
	for (int row = id*chunk; row < id*chunk + chunk; row += 1) {
		//printf("Thread %d: I just started row %d\n", id, row);
		for (int col = 0;col<width;col++) {
			BYTE *pRed, *pGrn, *pBlu;
			pRed = dataBuf + row * width * 3 + col * 3;
			pGrn = dataBuf + row * width * 3 + col * 3 + 1;
			pBlu = dataBuf + row * width * 3 + col * 3 + 2;

			int lum = (int)(.299 * (double)(*pRed) + .587 * (double)(*pGrn) + .114 * (double)(*pBlu));

			*pRed = (BYTE)lum;
			*pGrn = (BYTE)lum;
			*pBlu = (BYTE)lum;
			}
		}
	printf("Thread %d: I'm done! I did rows %d to %d\n",id, chunk*id, chunk*id + chunk);
	}//end parallel block
	JpegFile::RGBToJpegFile("testmono.jpg", dataBuf, width, height, true, 75);
	//printf("made it to the end\n");
	end = omp_get_wtime();
	printf("took %f seconds\n", end-start);
	delete dataBuf;
	//write the gray luminance to another jpg file

	return 1;
}
