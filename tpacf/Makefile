tpacf: 
	nvcc -lcudart -Wno-deprecated-declarations -I . -lm -lstdc++ --use_fast_math \
		args.cc model_io.cc main.cu parboil_cuda.c \
		-o tpacf

clean :
	rm tpacf
