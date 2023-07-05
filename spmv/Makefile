spmv: 
	nvcc -lcudart -Wno-deprecated-declarations -I . -lm -lstdc++ --use_fast_math \
		-I common_src/convert-dataset \
		./common_src/convert-dataset/convert_dataset.c \
		./common_src/convert-dataset/mmio.c \
		main.cu file.cc gpu_info.cc parboil_cuda.c \
		-o spmv

clean :
	rm spmv
