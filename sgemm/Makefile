sgemm: 
	nvcc -lcudart -I . -lm -lstdc++ --use_fast_math \
		main.cu io.cu parboil_cuda.c \
		-o sgemm

clean :
	rm sgemm
