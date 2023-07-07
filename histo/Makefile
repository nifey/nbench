histo: 
	nvcc -lcudart -I . -lm -lstdc++ --use_fast_math \
		main.cu histo_final.cu histo_intermediates.cu histo_main.cu histo_prescan.cu util.cu parboil_cuda.c \
		-o histo

clean :
	rm histo
