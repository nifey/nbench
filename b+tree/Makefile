CUDA_DIR = /usr/local/cuda
CUDA_LIB_DIR := /usr/local/cuda/lib
CUDA_LIB = -lcudart
C_C = gcc
CUD_C = nvcc

b+tree.out:	./main.o \
		./kernel/kernel_gpu_cuda_wrapper.o \
		./kernel/kernel_gpu_cuda_wrapper_2.o \
		./util/timer/timer.o \
		./util/num/num.o \
		./util/cuda/cuda.o
	$(C_C)	./main.o \
			./kernel/kernel_gpu_cuda_wrapper.o \
			./kernel/kernel_gpu_cuda_wrapper_2.o \
			./util/timer/timer.o \
			./util/num/num.o \
			./util/cuda/cuda.o \
			-lm \
			-L$(CUDA_LIB_DIR) \
			$(CUDA_LIB)\
                       -o b+tree.out

main.o:	./common.h \
		./main.h \
		./main.c
	$(C_C)	$(KERNEL_DIM) ./main.c \
			-c \
			-o ./main.o \
			-O3

./kernel/kernel_gpu_cuda_wrapper.o:	./common.h \
									./kernel/kernel_gpu_cuda_wrapper.h \
									./kernel/kernel_gpu_cuda_wrapper.cu
	$(CUD_C) $(KERNEL_DIM) ./kernel/kernel_gpu_cuda_wrapper.cu \
				-c \
				-o ./kernel/kernel_gpu_cuda_wrapper.o \
				-O3 \
				$(CUDA_FLAG)

./kernel/kernel_gpu_cuda_wrapper_2.o:	./common.h \
										./kernel/kernel_gpu_cuda_wrapper_2.h \
										./kernel/kernel_gpu_cuda_wrapper_2.cu
	$(CUD_C) $(KERNEL_DIM) ./kernel/kernel_gpu_cuda_wrapper_2.cu \
				-c \
				-o ./kernel/kernel_gpu_cuda_wrapper_2.o \
				-O3 \
				$(CUDA_FLAG)

./util/timer/timer.o:	./common.h \
						./util/timer/timer.h \
						./util/timer/timer.c
	$(C_C)	./util/timer/timer.c \
			-c \
			-o ./util/timer/timer.o \
			-O3

./util/num/num.o:	./common.h \
					./util/num/num.h \
					./util/num/num.c
	$(C_C)	./util/num/num.c \
			-c \
			-o ./util/num/num.o \
			-O3

./util/cuda/cuda.o:	./common.h \
					./util/cuda/cuda.h \
					./util/cuda/cuda.cu
	$(CUD_C)	./util/cuda/cuda.cu \
				-c \
				-o ./util/cuda/cuda.o \
				-O3 \
				$(CUDA_FLAG)

clean:
	rm	*.o *.out \
		./kernel/*.o \
		./util/timer/*.o \
		./util/num/*.o \
		./util/cuda/*.o \
                output.txt
