cutcp: 
	nvcc -lcudart -Wno-deprecated-declarations -I . -lm -lstdc++ --use_fast_math \
		main.c readatom.c output.c excl.c cutcpu.c cutoff6overlap.cu parboil_cuda.c \
		-o cutcp

clean :
	rm cutcp
