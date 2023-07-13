NVCC=nvcc
CC = g++
CUDA_INSTALL_PATH ?= /usr/local/cuda
CUDA_DIR ?= $(CUDA_INSTALL_PATH)
CUDA_LIB_DIR ?= $(CUDA_INSTALL_PATH)/lib

CUDA_INCLUDEPATH=$(CUDA_DIR)/include

NVCC_OPTS=-O3 -Xcompiler -m64 -g -G

GCC_OPTS=-O3 -Wall -Wextra -m64

OBJ = main_test_cu.o stats_logger.o vlc_kernel_sm64huff.o scan.o pack_kernels.o cpuencode.o
SRC = main_test_cu.cu
EXE = pavle

ifdef TESTING 
override TESTING = -DTESTING
endif

ifdef CACHECWLUT
override TESTING = -DCACHECWLUT
endif

pavle: $(OBJ) 
	$(NVCC) -lcudart $(TESTING) $(CACHECWLUT) $(NVCC_OPTS) $(OBJ) -o $(EXE) 

vlc_kernel_sm64huff.o: vlc_kernel_sm64huff.cu 
	$(NVCC) -lcudart $(TESTING) -c vlc_kernel_sm64huff.cu $(NVCC_OPTS)

scan.o: scan.cu 
	$(NVCC) -lcudart -c scan.cu $(NVCC_OPTS)

#cpuencode.o: cpuencode.cu
#	$(NVCC) -lcudart -c $(NVCC_OPTS) cpuencode.cu

pack_kernels.o: pack_kernels.cu 
	$(NVCC) -lcudart -c pack_kernels.cu $(NVCC_OPTS)

main_test_cu.o: main_test_cu.cu cutil.h
	$(NVCC) -lcudart $(TESTING) -c main_test_cu.cu $(NVCC_OPTS) -I $(CUDA_INCLUDEPATH) 

.o:.cpp
	$(CC) ++ $(GCC_OPTS) -c $@ -o $<

clean:
	rm -f *.o $(EXE) 
