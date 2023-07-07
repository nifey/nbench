mri-q: 
	nvcc -lcudart -I . -lm -lstdc++ --use_fast_math \
		file.cu main.cu parboil_cuda.c \
		-o mri-q

clean :
	rm mri-q
