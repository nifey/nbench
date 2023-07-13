CUDA_INSTALL_PATH ?= /usr/local/cuda
CUDA_DIR ?= $(CUDA_INSTALL_PATH)
CUDA_LIB_DIR ?= $(CUDA_INSTALL_PATH)/lib

CC := $(CUDA_DIR)/bin/nvcc

INCLUDE := $(CUDA_DIR)/include

SRC = gaussian.cu
EXE = gaussian

release: $(SRC)
	$(CC) -lcudart $(KERNEL_DIM) $(SRC) -o $(EXE) -I$(INCLUDE) -L$(CUDA_LIB_DIR) 

clean:
	rm gaussian
