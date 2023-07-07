/***************************************************************************
 *cr
 *cr            (C) Copyright 2007 The Board of Trustees of the
 *cr                        University of Illinois
 *cr                         All Rights Reserved
 *cr
 ***************************************************************************/

#include <endian.h>
#include <stdlib.h>
#include <malloc.h>
#include <stdio.h>
#include <inttypes.h>

#if __BYTE_ORDER != __LITTLE_ENDIAN
# error "File I/O is not implemented for this system: wrong endianness."
#endif

extern "C"
void inputData(char* fName, int* _numK, int* _numX,
               float** kx, float** ky, float** kz,
               float** x, float** y, float** z,
               float** phiR, float** phiI)
{
  int numK, numX;
  FILE* fid = fopen(fName, "r");

  if (fid == NULL)
    {
      fprintf(stderr, "Cannot open input file\n");
      exit(-1);
    }
  fread (&numK, sizeof (int), 1, fid);
  *_numK = numK;
  fread (&numX, sizeof (int), 1, fid);
  *_numX = numX;
  cudaMallocManaged(kx, numK * sizeof (float));
  fread (*kx, sizeof (float), numK, fid);
  cudaMallocManaged(ky, numK * sizeof (float));
  fread (*ky, sizeof (float), numK, fid);
  cudaMallocManaged(kz, numK * sizeof (float));
  fread (*kz, sizeof (float), numK, fid);
  cudaMallocManaged(x, numX * sizeof (float));
  fread (*x, sizeof (float), numX, fid);
  cudaMallocManaged(y, numX * sizeof (float));
  fread (*y, sizeof (float), numX, fid);
  cudaMallocManaged(z, numX * sizeof (float));
  fread (*z, sizeof (float), numX, fid);
  cudaMallocManaged(phiR, numK * sizeof (float));
  fread (*phiR, sizeof (float), numK, fid);
  cudaMallocManaged(phiI, numK * sizeof (float));
  fread (*phiI, sizeof (float), numK, fid);
  fclose (fid); 
}

extern "C"
void outputData(char* fName, float* outR, float* outI, int numX)
{
  FILE* fid = fopen(fName, "w");
  uint32_t tmp32;

  if (fid == NULL)
    {
      fprintf(stderr, "Cannot open output file\n");
      exit(-1);
    }

  /* Write the data size */
  tmp32 = numX;
  fwrite(&tmp32, sizeof(uint32_t), 1, fid);

  /* Write the reconstructed data */
  fwrite (outR, sizeof (float), numX, fid);
  fwrite (outI, sizeof (float), numX, fid);
  fclose (fid);
}
