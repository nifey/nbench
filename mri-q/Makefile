mri-q: 
	nvcc -lcudart -Wno-deprecated-declarations -I . -lm -lstdc++ --use_fast_math \
		file.cc main.cu parboil_cuda.c \
		-o mri-q

clean :
	rm mri-q
