# nbench

Port of Parboil 2.5 and Rodinia 3.1 benchmarks to CUDA Unified memory (cudaMallocManaged).

Download the parboil dataset from http://impact.crhc.illinois.edu/parboil/parboil_download_page.aspx and rodinia dataset from http://www.cs.virginia.edu/~skadron/lava/Rodinia/Packages/rodinia_3.1.tar.bz2. Then use `load_data.sh` script to load the data at the expected locations

```sh
# After downloading the dataset
bash load_data.sh path/to/pb2.5datasets_standard.tgz path/to/rodinia_3.1.tar.bz2

# Then for running each benchmark
cd bfs
make
./run
```

- You can change the dataset used for running by changing the input files and parameters in the run file.
- `sad` from parboil and `hybridsort, kmeans, mummergpu, myocyte, leukocyte` from rodinia benchmarks are not ported as they use old texture API extensively
