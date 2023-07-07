stencil: 
	nvcc -lcudart -I . -lm -lstdc++ --use_fast_math \
		main.cu file.cc parboil_cuda.c \
		-o stencil

clean :
	rm stencil
