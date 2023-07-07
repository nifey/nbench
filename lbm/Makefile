lbm: 
	nvcc -lcudart -I . -lm -lstdc++ --use_fast_math \
		main.cc lbm.cu parboil_cuda.c \
		-o lbm

clean :
	rm lbm
