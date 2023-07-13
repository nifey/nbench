CUDA_INSTALL_PATH ?= /usr/local/cuda
CUDA_DIR ?= $(CUDA_INSTALL_PATH)
CUDA_LIB_DIR ?= $(CUDA_INSTALL_PATH)/lib

LOCAL_CC = gcc -g -O3 -Wall
CC := $(CUDA_DIR)/bin/nvcc

all : nn hurricane_gen

clean :
	rm -rf *.o nn hurricane_gen

nn : nn_cuda.cu
	$(CC) -lcudart -cuda nn_cuda.cu
	$(CC) -lcudart -o nn nn_cuda.cu

hurricane_gen : hurricane_gen.c
	$(LOCAL_CC) -o $@ $< -lm

#data :
#	mkdir data
#	./gen_dataset.sh
