all: euler3d euler3d_double  pre_euler3d  pre_euler3d_double 

euler3d: euler3d.cu
	nvcc $(KERNEL_DIM) -lcudart -O2 -Xptxas -v euler3d.cu -o euler3d

euler3d_double: euler3d_double.cu
	nvcc -lcudart -Xptxas -v -O3 euler3d_double.cu -o euler3d_double


pre_euler3d: pre_euler3d.cu
	nvcc -lcudart -Xptxas -v -O3 pre_euler3d.cu -o pre_euler3d

pre_euler3d_double: pre_euler3d_double.cu
	nvcc -lcudart -Xptxas -v -O3 pre_euler3d_double.cu -o pre_euler3d_double

clean:
	rm -f euler3d euler3d_double pre_euler3d pre_euler3d_double *.linkinfo density density_energy momentum
