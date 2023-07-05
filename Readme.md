# nbench

Port of Parboil 2.5 benchmarks to CUDA Unified memory (cudaMallocManaged).

Download the dataset from http://impact.crhc.illinois.edu/parboil/parboil_download_page.aspx and use load_data.sh script to load the data at the expected locations

```sh
# After downloading the dataset
bash load_data.sh path/to/pb2.5datasets_standard.tgz

# Then for running each benchmark
cd bfs
make
./run
```

- You can change the dataset used for running by changing the input files and parameters in the run file.
- `sad` benchmark is not ported as it used old texture API extensively
