/***************************************************************************
 *cr
 *cr            (C) Copyright 2010 The Board of Trustees of the
 *cr                        University of Illinois
 *cr                         All Rights Reserved
 *cr
 ***************************************************************************/

/* 
 * Main entry of dense matrix-matrix multiplication kernel
 */

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <malloc.h>
#include <vector>
#include <parboil.h>
#include <iostream>
#include "sgemm_kernel.cu"

// I/O routines
extern bool readColMajorMatrixFile(const char *fn, int &nr_row, int &nr_col, float **v);
extern bool writeColMajorMatrixFile(const char *fn, int, int, float*);

extern "C"
void computeGold(float *, const float*, const float*, unsigned int, unsigned int, unsigned int);

int
main (int argc, char *argv[]) {

  struct pb_Parameters *params;
  struct pb_TimerSet timers;

  int matArow, matAcol;
  int matBrow, matBcol;
  float *matA, *matBT;

  pb_InitializeTimerSet(&timers);

  /* Read command line. Expect 3 inputs: A, B and B^T 
     in column-major layout*/
  params = pb_ReadParameters(&argc, argv);
  if ((params->inpFiles[0] == NULL) 
      || (params->inpFiles[1] == NULL)
      || (params->inpFiles[2] == NULL)
      || (params->inpFiles[3] != NULL))
    {
      fprintf(stderr, "Expecting three input filenames\n");
      exit(-1);
    }
 
  /* Read in data */
  pb_SwitchToTimer(&timers, pb_TimerID_IO);

  // load A
  readColMajorMatrixFile(params->inpFiles[0],
      matArow, matAcol, &matA);

  // load B^T
  readColMajorMatrixFile(params->inpFiles[2],
      matBcol, matBrow, &matBT);

  pb_SwitchToTimer( &timers, pb_TimerID_COMPUTE );

  // CUDA memory allocation
  float *matC;
  cudaMallocManaged(&matC, matArow * matBcol * sizeof(float));

  pb_SwitchToTimer( &timers, pb_TimerID_KERNEL );

  // Use standard sgemm interface
  regtileSgemm('N', 'T', matArow, matBcol, matAcol, 1.0f, \
      matA, matArow, matBT, matBcol, 0.0f, matC, matArow);

  cudaDeviceSynchronize();
  if (params->outFile) {
    /* Write C to file */
    pb_SwitchToTimer(&timers, pb_TimerID_IO);
    writeColMajorMatrixFile(params->outFile,
	matArow, matBcol, matC); 
  }

  pb_SwitchToTimer(&timers, pb_TimerID_NONE);

  double GPUtime = pb_GetElapsedTime(&(timers.timers[pb_TimerID_KERNEL]));
  std::cout<< "GFLOPs = " << 2.* matArow * matBcol * matAcol/GPUtime/1e9 << std::endl;
  pb_PrintTimerSet(&timers);
  pb_FreeParameters(params);
  cudaFree(matA);
  cudaFree(matBT);
  cudaFree(matC);
  return 0;
}
