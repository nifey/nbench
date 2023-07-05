sgemm: 
	nvcc -lcudart -Wno-deprecated-declarations -I . -lm -lstdc++ --use_fast_math \
		main.cu io.cc parboil_cuda.c \
		-o sgemm

clean :
	rm sgemm
