
#include <parboil.h>
#include <stdio.h>
#include <stdlib.h>

#include "file.h"
#include "gpu_info.h"
#include "spmv_jds.h"
#include "jds_kernels.cu"
#include "convert_dataset.h"


/*
static int generate_vector(float *x_vector, int dim) 
{	
	srand(54321);	
	for(int i=0;i<dim;i++)
	{
		x_vector[i] = (rand() / (float) RAND_MAX);
	}
	return 0;
}
*/

int main(int argc, char** argv) {
	struct pb_TimerSet timers;
	struct pb_Parameters *parameters;
	
	
	
	
	
	printf("CUDA accelerated sparse matrix vector multiplication****\n");
	printf("Original version by Li-Wen Chang <lchang20@illinois.edu> and Shengzhao Wu<wu14@illinois.edu>\n");
	printf("This version maintained by Chris Rodrigues  ***********\n");
	parameters = pb_ReadParameters(&argc, argv);
	if ((parameters->inpFiles[0] == NULL) || (parameters->inpFiles[1] == NULL))
    {
      fprintf(stderr, "Expecting two input filenames\n");
      exit(-1);
    }

	
	pb_InitializeTimerSet(&timers);
	pb_SwitchToTimer(&timers, pb_TimerID_COMPUTE);
	
	//parameters declaration
	int len;
	int depth;
	int dim;
	int pad=32;
	int nzcnt_len;
	
	//host memory allocation
	//matrix
	float *h_data;
	int *h_indices;
	int *h_ptr;
	int *h_perm;
	int *h_nzcnt;
	//vector
    float *h_x_vector;
	
	//device memory allocation
	//matrix
	float *d_data;
	int *d_indices;
	int *d_ptr;
	int *d_perm;
	int *d_nzcnt;
	//vector
	float *d_Ax_vector;
    float *d_x_vector;
	
    //load matrix from files
	pb_SwitchToTimer(&timers, pb_TimerID_IO);
	//inputData(parameters->inpFiles[0], &len, &depth, &dim,&nzcnt_len,&pad,
	//    &h_data, &h_indices, &h_ptr,
	//    &h_perm, &h_nzcnt);
	int col_count;
	coo_to_jds(
		parameters->inpFiles[0], // bcsstk32.mtx, fidapm05.mtx, jgl009.mtx
		1, // row padding
		pad, // warp size, IMPORTANT: change in kernel as well
		1, // pack size
		1, // is mirrored?
		0, // binary matrix
		1, // debug level [0:2]
		&h_data, &h_ptr, &h_nzcnt, &h_indices, &h_perm,
		&col_count, &dim, &len, &nzcnt_len, &depth
	);
	

  h_x_vector=(float*)malloc(sizeof(float)*dim);
  input_vec( parameters->inpFiles[1],h_x_vector,dim);

	pb_SwitchToTimer(&timers, pb_TimerID_COMPUTE);
	
	cudaDeviceProp deviceProp;
    cudaGetDeviceProperties(&deviceProp, 0);
	
	
	pb_SwitchToTimer(&timers, pb_TimerID_COPY);
	//memory allocation
	cudaMallocManaged((void **)&d_data, len*sizeof(float));
	cudaMallocManaged((void **)&d_indices, len*sizeof(int));
	cudaMallocManaged((void **)&d_ptr, depth*sizeof(int));
	cudaMallocManaged((void **)&d_perm, dim*sizeof(int));
	cudaMallocManaged((void **)&d_nzcnt, nzcnt_len*sizeof(int));
	cudaMallocManaged((void **)&d_x_vector, dim*sizeof(float));
	cudaMallocManaged((void **)&d_Ax_vector,dim*sizeof(float));
	memset((void *) d_Ax_vector, 0, dim*sizeof(float));
	
	//memory copy
	memcpy(d_data, h_data, len*sizeof(float));
	memcpy(d_indices, h_indices, len*sizeof(int));
	memcpy(d_perm, h_perm, dim*sizeof(int));
	memcpy(d_x_vector, h_x_vector, dim*sizeof(int));
	cudaMemcpyToSymbol(jds_ptr_int, h_ptr, depth*sizeof(int));
	cudaMemcpyToSymbol(sh_zcnt_int, h_nzcnt,nzcnt_len*sizeof(int));
	
    cudaThreadSynchronize();
	pb_SwitchToTimer(&timers, pb_TimerID_COMPUTE);
	unsigned int grid;
	unsigned int block;
    compute_active_thread(&block, &grid,nzcnt_len,pad, deviceProp.major,deviceProp.minor,
					deviceProp.warpSize,deviceProp.multiProcessorCount);

	
  cudaFuncSetCacheConfig(spmv_jds, cudaFuncCachePreferL1);

	//main execution
	pb_SwitchToTimer(&timers, pb_TimerID_KERNEL);
	for (int i= 0; i<50; i++)
	spmv_jds<<<grid, block>>>(d_Ax_vector,
  				d_data,d_indices,d_perm,
				d_x_vector,d_nzcnt,dim);
							
    CUERR // check and clear any existing errors
	
	
	pb_SwitchToTimer(&timers, pb_TimerID_COPY);


	cudaFree(d_data);
    cudaFree(d_indices);
    cudaFree(d_ptr);
	cudaFree(d_perm);
    cudaFree(d_nzcnt);
    cudaFree(d_x_vector);
 
	if (parameters->outFile) {
		pb_SwitchToTimer(&timers, pb_TimerID_IO);
		outputData(parameters->outFile,d_Ax_vector,dim);
		
	}
	cudaFree(d_Ax_vector);
	pb_SwitchToTimer(&timers, pb_TimerID_COMPUTE);
	
	free (h_data);
	free (h_indices);
	free (h_ptr);
	free (h_perm);
	free (h_nzcnt);
	free (h_x_vector);
	pb_SwitchToTimer(&timers, pb_TimerID_NONE);

	pb_PrintTimerSet(&timers);
	pb_FreeParameters(parameters);

	return 0;

}
