mri-gridding: 
	nvcc -lcudart -Wno-deprecated-declarations -I . -lm -lstdc++ --use_fast_math \
		CPU_kernels.c CUDA_interface.cu scanLargeArray.cu sort.cu main.cu parboil_cuda.c \
		-o mri-gridding

clean :
	rm mri-gridding
