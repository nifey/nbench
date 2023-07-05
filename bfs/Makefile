bfs: 
	nvcc -lcudart -Wno-deprecated-declarations -I . -lm -lstdc++ --use_fast_math \
		main.cu parboil_cuda.c\
		-o bfs

clean :
	rm bfs
